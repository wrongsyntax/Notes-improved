//
//  CreationPopoverControllerViewController.swift
//  Notes-improved
//
//  Created by Uzair Tariq on 2022-12-02.
//  Copyright © 2022 Uzair Tariq. All rights reserved.
//

import os
import UIKit

class CreationPopoverViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    let logger = Logger(subsystem: "UzairTariq.Notes-improved", category: "CreationPopover")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.presentationController?.delegate = self
    }
    
    private let homeViewController = HomeViewController(nibName: nil, bundle: nil)

    @IBAction func didTapCreateNewDocument(_ sender: Any) {
        let currentDirectory = homeViewController.currentDirectoryURL
        print("create new document in \(String(describing: currentDirectory))")
    }
    
    @IBAction func didTapCreateNewFolder(_ sender: Any) {
        var inputTextField: UITextField?
        
        let newFolderAlert = UIAlertController(title: "New Folder", message: nil, preferredStyle: .alert)
        newFolderAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        newFolderAlert.addTextField(configurationHandler: { (textField: UITextField!) in
            textField.placeholder = "New Folder"
            inputTextField = textField
        })
        newFolderAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.createNewDirectory(called: inputTextField?.text ?? "NewFolder")
            self.dismiss(animated: true)
        }))
        
        present(newFolderAlert, animated: true)
    }
    
    private func createNewDirectory(called newDirectoryName: String) {
        let newPath = homeViewController.currentDirectoryURL.appending(path: newDirectoryName)
        
        do {
            try FileManager.default.createDirectory(at: newPath, withIntermediateDirectories: true, attributes: nil)
            logger.log(level: .info, "Creating new directory: \(newPath)")
        } catch let error as NSError {
            let errorAlert = UIAlertController(title: "Error Creating Folder", message: "\(error)", preferredStyle: .alert)
            self.present(errorAlert, animated: true)
            logger.log(level: .error, "Error creating folder: \(error)")
        }
    }
    
    private func createNewDocument() {
        
    }
}
