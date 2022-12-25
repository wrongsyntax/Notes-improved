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
        logger.log(level: .info, "TRASH FILE: \(fileToTrash)")
         
    }
}
