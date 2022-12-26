//
//  LoggingFunctions.swift
//  Notes-improved
//
//  Created by Uzair Tariq on 2022-12-25.
//  Copyright © 2022 Uzair Tariq. All rights reserved.
//

import os
import Foundation

public func successLog(_ logger: Logger, message: String) {
    logger.log(level: .info, "🟢 \(message)")
}

public func infoLog(_ logger: Logger, message: String) {
    logger.log(level: .info, "🔵 \(message)")
}

public func warningLog(_ logger: Logger, message: String) {
    logger.log(level: .debug, "🟡 \(message)")
}

public func errorLog(_ logger: Logger, error: NSError, attemptedAction: String) {
    logger.log(level: .error, "🔴 ERROR \(attemptedAction) \n\(error)")
}
