//
//  OptionsPopoverViewController.swift
//  Notes-improved
//
//  Created by Uzair Tariq on 2022-12-04.
//  Copyright © 2022 Uzair Tariq. All rights reserved.
//

import os
import UIKit

class FileOptionsPopoverViewController: UIViewController {
    
    let logger = Logger(subsystem: "UzairTariq.Notes-improved", category: "FileOptionsPopover")
    
    public var sendingURL: URL!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        trashFile(self.sendingURL)
        
    }
    
    private func trashFile(_ fileToTrash: URL) {
        do {
            let rootURL: URL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let destinationURL: URL = rootURL.appending(path: ".Trash").appending(path: fileToTrash.lastPathComponent)
            
            try FileManager.default.moveItem(at: fileToTrash, to: destinationURL)
        } catch let error as NSError {
            self.present(buildErrorAlert(error: error, attemptedAction: "Deleting item"), animated: true)
            logError(logger, error: error, attemptedAction: "Deleting item")
        }
    }
}
