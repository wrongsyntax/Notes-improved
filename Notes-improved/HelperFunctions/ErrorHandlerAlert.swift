//
//  ErrorHandlerAlert.swift
//  Notes-improved
//
//  Created by Uzair Tariq on 2022-12-25.
//  Copyright © 2022 Uzair Tariq. All rights reserved.
//

import os
import Foundation
import UIKit

public func buildErrorAlert(error: NSError, attemptedAction: String) -> UIAlertController {
    let errorAlert = UIAlertController(title: "Error \(attemptedAction)", message: "\(error.localizedDescription)", preferredStyle: .alert)
    errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .default))
    
    return errorAlert
}
