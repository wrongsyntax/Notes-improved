//
//  HomeViewController.swift
//  Notes-improved
//
//  Created by Uzair Tariq on 2022-11-19.
//  Copyright © 2022 Uzair Tariq. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeNavBar()
        initializeCreationButton()
    }
    
    // MARK: Nav Bar
    private func initializeNavBar() {
        navigationItem.title = "Notes(im)"
        
        var navBarRightItems: [UIBarButtonItem] = []
        let hierarchicalConfig = { (colour: UIColor) -> UIImage.SymbolConfiguration in
            return UIImage.SymbolConfiguration(hierarchicalColor: colour)
        }
        
        // Definitions
        let settingsImage = UIImage(systemName: "gearshape.circle", withConfiguration: hierarchicalConfig(UIColor.label))
        let settingsBarButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(didTapSettingsButton))
        
        let debugImage = UIImage(systemName: "ant.circle", withConfiguration: hierarchicalConfig(UIColor.systemYellow))
        let debugBarButton = UIBarButtonItem(image: debugImage, style: .plain, target: self, action: #selector(didTapDebugButton))
        
        // Add items
        navBarRightItems.append(settingsBarButton)
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
    
    // MARK: Creation Button
    @IBOutlet weak var creationButtonOutlet: UIButton!
    
    private func initializeCreationButton() {
        let shadowColour: UIColor = UIColor(named: "AccentColor") ?? UIColor.systemRed
        let shadowOpacity: Float = 0.5
        let shadowOffset: CGSize = .zero
        let shadowRadius: CGFloat = 10
        creationButtonOutlet.addDropShadow(colour: shadowColour, opacity: shadowOpacity, offset: shadowOffset, radius: shadowRadius)
    }
    
    @IBAction func didTapCreationButton(_ sender: UIButton) {
        presentCreationPopover(sender)
    }
    
    private func presentCreationPopover(_ sender: Any) {
        let creationPopover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "creationPopoverViewController")
        creationPopover.modalPresentationStyle = .popover
        creationPopover.popoverPresentationController?.permittedArrowDirections = .down
        creationPopover.popoverPresentationController?.delegate = self
        creationPopover.popoverPresentationController?.sourceView = sender as? UIView
        creationPopover.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
        self.present(creationPopover, animated: true)
    }
    
    // MARK: File Management
    private func initializeFileManager() -> URL? {
        do {
            let documentsDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            return documentsDirectoryURL
        } catch let error as NSError {
            let errorAlert = UIAlertController(title: "Error Initializing FileManager", message: "\(error)", preferredStyle: .alert)
            self.present(errorAlert, animated: true)
        }
        return nil
    }

    lazy var rootDirectoryURL: URL = initializeFileManager()!
    lazy var currentDirectoryURL: URL = rootDirectoryURL
    
    private func getContentsInDirectory(at directory: URL) -> [URL]? {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            return contents
        } catch let error as NSError {
            let errorAlert = UIAlertController(title: "Error Getting Files", message: "\(error)", preferredStyle: .alert)
            self.present(errorAlert, animated: true)
        }
        return nil
    }
    
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
            cell.documentName.text = currentDirectoryURL.absoluteString
            cell.delegate = self  // For popover
            return cell
        } else {
            let cell = filesCollectionView.dequeueReusableCell(withReuseIdentifier: "FolderCell", for: indexPath as IndexPath) as! FolderCollectionViewCell
            cell.folderName.text = contents[indexPath.row].lastPathComponent
            cell.folderContentCount.text = String(getContentsInDirectory(at: contents[indexPath.row])?.count ?? 0) + " items"
            cell.delegate = self  // For popover
            return cell
        }
    }
    
    // TODO: Automatically reload when view is initially dismissed
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("dismissed")
        filesCollectionView.reloadData()
    }
}

extension HomeViewController: HeaderCollectionViewCellDelegate {
    func presentOptionsPopover(_ sender: Any) {
        let optionsPopover = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "optionsPopoverViewController")
        optionsPopover.modalPresentationStyle = .popover
        optionsPopover.popoverPresentationController?.permittedArrowDirections = [.left, .right]
        optionsPopover.popoverPresentationController?.delegate = self
        optionsPopover.popoverPresentationController?.sourceView = sender as? UIView
        optionsPopover.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
        self.present(optionsPopover, animated: true)
    }
}

protocol HeaderCollectionViewCellDelegate {
    func presentOptionsPopover(_ sender: Any)
}

class DocumentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var documentName: UILabel!
    @IBOutlet weak var documentCreationDate: UILabel!
    var delegate: HeaderCollectionViewCellDelegate!
    
    @IBAction func didTapOptionsButton(_ sender: UIButton) {
        self.delegate.presentOptionsPopover(sender)
    }
}

class FolderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var folderName: UILabel!
    @IBOutlet weak var folderContentCount: UILabel!
    var delegate: HeaderCollectionViewCellDelegate!
    
    @IBAction func didTapOptionsButton(_ sender: Any) {
        self.delegate.presentOptionsPopover(sender)
    }
}
