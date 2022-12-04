//
//  HomeViewController.swift
//  Notes-improved
//
//  Created by Uzair Tariq on 2022-11-19.
//  Copyright © 2022 Uzair Tariq. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeNavBar()
        initializeCreationButton()
    }
    
    @objc func didTapSettingsButton() {
        performSegue(withIdentifier: "homeViewToSettingsModalSegue", sender: self)
    }
    
    @objc func didTapDebugButton() {
        performSegue(withIdentifier: "homeViewToDebugViewSegue", sender: self)
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
    
    private func getFilesInCurrentDirectory() -> [URL]? {
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: currentDirectoryURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles])
            return contents
        } catch let error as NSError {
            let errorAlert = UIAlertController(title: "Error Getting Files", message: "\(error)", preferredStyle: .alert)
            self.present(errorAlert, animated: true)
        }
        return nil
    }
    
    @IBOutlet weak var filesCollectionView: UICollectionView!
    
    private func initializeFilesView() {
        
    }
    
    // Creation and Deletion functions are in CreationPopoverViewController
    
    // MARK: Creation Button
    @IBOutlet weak var creationButtonOutlet: UIButton!
    
    private func initializeCreationButton() {
        let shadowColour: UIColor = UIColor(named: "AccentColor") ?? UIColor.systemRed
        let shadowOpacity: Float = 0.5
        let shadowOffset: CGSize = .zero
        let shadowRadius: CGFloat = 10
        creationButtonOutlet.addDropShadow(colour: shadowColour, opacity: shadowOpacity, offset: shadowOffset, radius: shadowRadius)
    }
}
