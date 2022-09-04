//
//  Logger.swift
//  NasaAstronomyPicture
//
//  Created by H453293 on 02/09/22.
//

import Foundation
import os.log

enum LogEvent: String {
    case e = "[‼️]" // error
    case i = "[ℹ️]" // info
    case d = "[⚙️]" // debug
    case v = "[🔬]" // verbose
    case w = "[⚠️]" // warning
    case s = "[🔥]" // severe
}

/// Logger class to configure the logging options
class Logger {
    /// Function to print the debug logs
    /// - Parameters:
    ///   - items: object that you want to log
    ///   - file: filename where the log is generated
    ///   - function: function name with class where log was generated
    ///   - line: line number where the log was generated
    public class func d(_ items: String,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line) {
        /// We can use other conditions to block the loggings
        if NAPEnvironment.shared.environment == .development {
            let filename = URL.init(string: file)?.lastPathComponent
            os_log(.debug,"%@ %@ : %@ : %@, Line: %d", LogEvent.d.rawValue,
                   items, String(describing: filename), function, line)
        }
    }
    
    /// Function to print the error logs
    /// - Parameters:
    ///   - items: object that you want to log
    ///   - file: filename where the log is generated
    ///   - function: function name with class where log was generated
    ///   - line: line number where the log was generated
    public class func e(_ items: String,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line) {
        /// We can use other conditions to block the loggings
        if NAPEnvironment.shared.environment == .development {
            let filename = URL.init(string: file)?.lastPathComponent
            os_log(.error,"%@ %@ : %@ : %@, Line: %d", LogEvent.e.rawValue,
                   items, String(describing: filename), function, line)
        }
    }
}
