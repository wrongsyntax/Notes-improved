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
        initializeCreateButtons()
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
    
    // TODO: Extract this whole view into its own file then add it to this view
    @IBOutlet weak var createButtonsBoundingRect: UIView!
    
    private func initializeCreateButtons() {
        createButtonsBoundingRect.addDashedBorder()
    }
    
    // Updates dashed border when switching between dark and light
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        createButtonsBoundingRect.addDashedBorder()
    }
}
