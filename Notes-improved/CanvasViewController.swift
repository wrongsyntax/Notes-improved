//
//  CanvasViewController.swift
//  Notes(improved)
//
//  Created by Uzair Tariq on 2022-11-14.
//  Copyright © 2022 Uzair Tariq. All rights reserved.
//

import UIKit
import PDFKit

class CanvasViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        pdfView.displayDirection = .vertical
        pdfView.usePageViewController(false)
        pdfView.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        pdfView.autoScales = true
        pdfView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      pdfView.autoScales = true
    }
    
    @IBOutlet private var pdfView: PDFView!
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
