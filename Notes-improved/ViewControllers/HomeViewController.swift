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
        
        self.initializeNavBar()
    }
    
    private func initializeNavBar() {
        // Nav Bar stuff
        navigationItem.title = "Notes(im)"
        
        var navBarRightItems: [UIBarButtonItem] = []
        
        // Definitions
        let settingsBarButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(didTapSettingsButton))
        let debugBarButton = UIBarButtonItem(image: UIImage(systemName: "ant.circle"), style: .plain, target: self, action: #selector(didTapDebugButton))
        
        // Tint Colours
        debugBarButton.tintColor = UIColor.systemYellow
        
        // Add items
        navBarRightItems.append(settingsBarButton)
        if UserDefaults.showDebugButtonInNavBar {
            navBarRightItems.append(debugBarButton)
        }
        
        navigationItem.rightBarButtonItems = navBarRightItems        
    }
    
    @objc func didTapSettingsButton() {
        performSegue(withIdentifier: "segueToSettingsModal", sender: self)
    }
    
    @objc func didTapDebugButton() {
        performSegue(withIdentifier: "segueToDebugView", sender: self)
    }
}
