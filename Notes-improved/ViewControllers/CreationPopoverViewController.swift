//
//  CreationPopoverControllerViewController.swift
//  Notes-improved
//
//  Created by Uzair Tariq on 2022-12-02.
//  Copyright © 2022 Uzair Tariq. All rights reserved.
//

import UIKit

class CreationPopoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let homeViewController = HomeViewController(nibName: nil, bundle: nil)

    @IBAction func didTapCreateNewDocument(_ sender: Any) {
        let currentDirectory = homeViewController.currentDirectoryURL
        print("create new document in \(String(describing: currentDirectory))")
    }
    
    @IBAction func didTapCreateNewFolder(_ sender: Any) {
        let currentDirectory = homeViewController.currentDirectoryURL
        print("create new folder in \(String(describing: currentDirectory))")
    }
    
    private func createNewDirectory() {
        
    }
    
    private func deleteDirectory() {
        
    }
    
    private func createNewDocument() {
        
    }
    
    private func deleteDocument() {
        
    }
}
