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
    }
    
    @IBOutlet private var pdfView: PDFView!
    
    private func initializePdfView() {
        pdfView.displayDirection = .vertical
        pdfView.usePageViewController(false)
        pdfView.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        pdfView.autoScales = true
        pdfView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      pdfView.autoScales = true
    }
    
    
    
// https://programmingwithswift.com/open-pdf-file-with-swift-pdfkit-wkwebview/
//    private func createPdfDocument(forFilename filename: String) -> PDFDocument? {
//        if let resourceUrl = self.getResourceUrl(forFilename: filename) {
//            return PDFDocument(url: resourceUrl)
//        }
//
//        return nil
//    }
//
//    private func displayPdf(forFilename filename: String) {
//        if let pdfDocument = self.createPdfDocument(forFilename: filename) {
//
//        }
//    }
//
//    private func getResourceUrl(forFilename filename: String) -> URL? {
//        if let resourceUrl = Bundle.main.url(forResource: filename, withExtension: "pdf") {
//            return resourceUrl
//        }
//
//        return nil
//    }
}
