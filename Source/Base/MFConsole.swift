/**
 * @file        MFConsole.swift
 * @brief      Define MFConsole class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiUIKit
import JavaScriptCore
import Foundation

@objc public protocol MFConsoleProtorol: JSExport
{
        func log(_ name: JSValue)
        func error(_ name: JSValue)
}

@objc public class MFConsole: MIConsole, MFConsoleProtorol
{
        static public let InstanceName            = "console"

        public static let VariableName = "console"

        public static func setup(storage strg: MITextStorage, context ctxt: MFContext){
                let console = MIConsole(storage: strg)
                let value   = JSValue(object: console, in: ctxt)
                ctxt.setObject(value, forKeyedSubscript: MFConsole.InstanceName as NSString)
        }

        public func log(_ name: JSValue) {
                if let str = name.toString() {
                        super.print(string: str + "\n")
                } else {
                        NSLog("\(name)")
                }
        }
        
        public func error(_ name: JSValue)  {
                if let str = name.toString() {
                        super.print(string: str)
                } else {
                        NSLog("[Error] \(name)")
                }
        }
}

