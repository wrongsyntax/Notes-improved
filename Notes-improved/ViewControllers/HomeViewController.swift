//
//  HomeViewController.swift
//  Notes-improved
//
//  Created by Uzair Tariq on 2022-11-19.
//  Copyright © 2022 Uzair Tariq. All rights reserved.
//

import os
import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate {
    
    let logger = Logger(subsystem: "UzairTariq.Notes-imporoved", category: "HomeView")
    
    // MARK: Initialize View
    var viewTitle: String = "Notes(im)"
    var showCreateButton: Bool = true
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeNavBar(navTitle: self.viewTitle)
        initializeCreationButton()
    }
    
    // Automatically reloads filesCollectionView
    override func viewDidLayoutSubviews() {
        filesCollectionView.reloadData()
    }
    // Reload CollectionView whenever any popover is dismissed by user
    // Probably not necessary anymore
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        filesCollectionView.reloadData()
    }

    // MARK: Nav Bar
    private func initializeNavBar(navTitle: String) {
        navigationItem.title = navTitle
        
        var navBarRightItems: [UIBarButtonItem] = []
        let hierarchicalConfig = { (colour: UIColor) -> UIImage.SymbolConfiguration in
            return UIImage.SymbolConfiguration(hierarchicalColor: colour)
        }
        
        // Definitions
        let settingsImage = UIImage(systemName: "gearshape.circle", withConfiguration: hierarchicalConfig(UIColor.label))
        let settingsBarButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(didTapSettingsButton))
        
        let debugImage = UIImage(systemName: "ant.circle", withConfiguration: hierarchicalConfig(UIColor.systemYellow))
        let debugBarButton = UIBarButtonItem(image: debugImage, style: .plain, target: self, action: #selector(didTapDebugButton))
        
        let trashImage = UIImage(systemName: "trash.circle", withConfiguration: hierarchicalConfig(UIColor.label))
        let trashBarButton = UIBarButtonItem(image: trashImage, style: .plain, target: self, action: #selector(didTapTrashButton))
        
        // Add items (furthest right first)
        navBarRightItems.append(settingsBarButton)
        navBarRightItems.append(trashBarButton)
        if UserDefaults.showDebugButtonInNavBar {
            navBarRightItems.append(debugBarButton)
        }
        
        navigationItem.rightBarButtonItems = navBarRightItems        
    }
    
    @objc func didTapSettingsButton() {
        performSegue(withIdentifier: "homeViewToSettingsModalSegue", sender: self)
    }
    
    @objc func didTapDebugButton() {
        performSegue(withIdentifier: "homeViewToDebugViewSegue", sender: self)
    }
    
    @objc func didTapTrashButton() {
        navigateToFolder(at: rootDirectoryURL.appending(path: ".Trash"), viewTitle: "Trash", allowCreation: false)
    }
    
    // MARK: Creation Button
    @IBOutlet weak var creationButtonOutlet: UIButton!
    
    private func initializeCreationButton(show: Bool = true) {
        let shadowColour: UIColor = UIColor(named: "AccentColor") ?? UIColor.systemRed
        if !self.showCreateButton {
            creationButtonOutlet.layer.opacity = 0
            creationButtonOutlet.isEnabled = false
        }
        let shadowOpacity: Float = 0.5
        let shadowOffset: CGSize = .zero
        let shadowRadius: CGFloat = 10
        creationButtonOutlet.addDropShadow(colour: shadowColour, opacity: shadowOpacity, offset: shadowOffset, radius: shadowRadius)
    }
    
    @IBAction func didTapCreationButton(_ sender: UIButton) {
        presentCreationPopover(sender)
    }
    
    private func presentCreationPopover(_ sender: Any) {
        let creationPopover: CreationPopoverViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "creationPopoverViewController") as! CreationPopoverViewController
        creationPopover.modalPresentationStyle = .popover
        creationPopover.popoverPresentationController?.permittedArrowDirections = .down
        creationPopover.popoverPresentationController?.delegate = self
        creationPopover.popoverPresentationController?.sourceView = sender as? UIView
        creationPopover.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
        creationPopover.sendingURL = currentDirectoryURL
        self.present(creationPopover, animated: true)
    }
    
    // MARK: File Management
    private func initializeFileManager() -> [String: URL]? {
        do {
            let documentsDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
//            let trashDirectoryURL: URL = documentsDirectoryURL.appending(path: ".Trash")
//            if !FileManager.default.fileExists(atPath: trashDirectoryURL.path()) {
//                try FileManager.default.createDirectory(at: trashDirectoryURL, withIntermediateDirectories: true)
//            }
//
//            let templatesDirectoryURL: URL = documentsDirectoryURL.appending(path: ".Templates")
//            if !FileManager.default.fileExists(atPath: trashDirectoryURL.path()) {
//                try FileManager.default.createDirectory(at: templatesDirectoryURL, withIntermediateDirectories: true)
//            }
            
            // Templates will also be here in the future probably
            return ["documents": documentsDirectoryURL]
        } catch let error as NSError {
            self.present(buildErrorAlert(error: error, attemptedAction: "Initializing FileManager"), animated: true)
            errorLog(logger, error: error, attemptedAction: "Initializing FileManager")
        }
        return nil
    }
    
    lazy var initializedDirectories: [String: URL] = initializeFileManager()!
    lazy var rootDirectoryURL: URL = initializedDirectories["documents"]!
    lazy var currentDirectoryURL: URL = rootDirectoryURL
    
    private func getContentsInDirectory(at directory: URL) -> [URL]? {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            return contents
        } catch let error as NSError {
            self.present(buildErrorAlert(error: error, attemptedAction: "Getting files in \(directory.lastPathComponent)"), animated: true)
            errorLog(logger, error: error, attemptedAction: "Getting files in \(directory.lastPathComponent)")
        }
        return nil
    }
    
    // MARK: Navigation b/w Folders
    func navigateToFolder(at directory: URL, viewTitle: String? = nil, allowCreation: Bool = true) {
        let nextFolderViewController: HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeViewController") as! HomeViewController
        nextFolderViewController.currentDirectoryURL = directory
        nextFolderViewController.showCreateButton = allowCreation
        // BUG: viewTitle argument still required despite default value
        nextFolderViewController.viewTitle = viewTitle ?? directory.lastPathComponent
        self.navigationController?.pushViewController(nextFolderViewController, animated: true)
    }
    
    // MARK: CollectionView
    @IBOutlet weak var filesCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = getContentsInDirectory(at: currentDirectoryURL) ?? []
        return numberOfItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // https://stackoverflow.com/questions/36561666/displaying-two-different-cells-in-a-collection-view-swift-2-0-ios
        
        let contents: [URL] = getContentsInDirectory(at: currentDirectoryURL) ?? []
        
        if !contents[indexPath.row].hasDirectoryPath {
            let cell = filesCollectionView.dequeueReusableCell(withReuseIdentifier: "DocumentCell", for: indexPath as IndexPath) as! DocumentCollectionViewCell
            cell.documentName.text = currentDirectoryURL.absoluteString  // might be wrong
            cell.associatedDocument = contents[indexPath.row]
            cell.delegate = self  // For popover
            return cell
        } else {
            let cell = filesCollectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath as IndexPath) as! FolderCollectionViewCell
            cell.folderName.text = contents[indexPath.row].lastPathComponent
            cell.folderContentCount.text = String(getContentsInDirectory(at: contents[indexPath.row])?.count ?? 0) + " items"
            cell.associatedFolder = contents[indexPath.row]
            cell.delegate = self  // For popover
            return cell
        }
    }
}

// MARK: File Options Popover
extension HomeViewController: FileCollectionViewCellDelegate {
    func presentFileOptionsPopover(_ sender: Any, senderURL: URL) {
        let optionsPopover: FileOptionsPopoverViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "fileOptionsPopoverViewController") as! FileOptionsPopoverViewController
        optionsPopover.modalPresentationStyle = .popover
        optionsPopover.popoverPresentationController?.permittedArrowDirections = [.left, .right]
        optionsPopover.popoverPresentationController?.delegate = self
        optionsPopover.popoverPresentationController?.sourceView = sender as? UIView
        optionsPopover.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
        optionsPopover.sendingURL = senderURL
        self.present(optionsPopover, animated: true)
    }
}

protocol FileCollectionViewCellDelegate {
    func presentFileOptionsPopover(_ sender: Any, senderURL: URL)
    func navigateToFolder(at directory: URL, viewTitle: String?, allowCreation: Bool)
}

// MARK: CollectionView Cells
class DocumentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var documentName: UILabel!
    @IBOutlet weak var documentCreationDate: UILabel!
    var associatedDocument: URL!
    var delegate: FileCollectionViewCellDelegate!
    
    @IBAction func didTapOptionsButton(_ sender: UIButton) {
        self.delegate.presentFileOptionsPopover(sender, senderURL: associatedDocument)
    }
}

class FolderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var folderName: UILabel!
    @IBOutlet weak var folderContentCount: UILabel!
    var associatedFolder: URL!
    var delegate: FileCollectionViewCellDelegate!
    
    @IBAction func didTapOptionsButton(_ sender: Any) {
        self.delegate.presentFileOptionsPopover(sender, senderURL: associatedFolder)
    }
    
    @IBAction func didTapFolder(_ sender: AnyObject) {
        // A bit hacked by adding a new button but should work for now
        self.delegate.navigateToFolder(at: associatedFolder, viewTitle: nil, allowCreation: true)
    }
}
