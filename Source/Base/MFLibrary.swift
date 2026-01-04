/**
 * @file        MFLibrary.swift
 * @brief      Define NFLibrary class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiDataKit
import MultiUIKit
import JavaScriptKit
import JavaScriptCore
import Foundation

open class MFLibrary: KSLibrary
{
        public func load(into ctxt: KSContext, storage strg: MITextStorage) -> NSError? {
                if let err = super.load(into: ctxt) {
                        return err
                }

                /* load object */
                let console = MFConsole(storage: strg)
                let value   = JSValue(object: console, in: ctxt)
                ctxt.setObject(value, forKeyedSubscript: MFConsole.InstanceName as NSString)

                return nil
        }
}

