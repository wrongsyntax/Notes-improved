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
            let trashURL: URL = rootURL.appending(path: ".Trash")
            var destinationURL: URL = trashURL.appending(path: fileToTrash.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: destinationURL.path()) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH-mm-ss"
                // Update destinationURL to include date
                destinationURL = trashURL.appending(path: fileToTrash.lastPathComponent + dateFormatter.string(from: Date()))
                try FileManager.default.moveItem(at: fileToTrash, to: destinationURL)
            } else {
                try FileManager.default.moveItem(at: fileToTrash, to: destinationURL)
            }
            
            successLog(logger, message: "Deleted file: \(fileToTrash) -> \(destinationURL)")
        } catch let error as NSError {
            self.present(buildErrorAlert(error: error, attemptedAction: "Deleting item"), animated: true)
            errorLog(logger, error: error, attemptedAction: "Deleting item")
        }
    }
}
