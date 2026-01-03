/**
 * @file        MFFrame.swift
 * @brief      Define data types for the Frame
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiUIKit
import MultiDataKit
import JavaScriptKit
import Foundation
import JavaScriptCore

@objc public protocol MFFrameCoreProtorol: JSExport
{
        func _value(_ name: JSValue) -> JSValue
        func _setValue(_ name: JSValue, _ val: JSValue) -> JSValue              // -> boolean
        func _addObserver(_ property: JSValue, _ cbfunc: JSValue) -> JSValue    // -> boolean
}

@MainActor public protocol MFFrame
{
        var frameName: String { get }
        var core: MFFrameCore { get }
}

public func MFInterfaceTagToFrameId(interfaceTag tag: Int) -> Int
{
        return tag != MINullTagId ? tag >> MITagBits : MINullTagId
}

public func MFFrameIdToInterfaceTag(frameId fid: Int) -> Int {
        return fid != MINullTagId ? fid << MITagBits : MINullTagId
}

public extension MFFrame
{
        typealias ListenerFunction = MFObserverDictionary.ListenerFunction

        func value(name nm: String) -> MIValue? {
                if let obj = self.core.value(name: nm) {
                        return MIValue.fromObject(object: obj)
                } else {
                        return nil
                }
        }

        func setValue(name nm: String, value val: MIValue) {
                self.core.setValue(name: nm, value: val)
        }

        func addObserver(name nm: String, listner lfunc: @escaping ListenerFunction){
                self.core.addObserver(name: nm, listner: lfunc)
        }
}

@objc public class MFFrameCore: NSObject, MFFrameCoreProtorol
{
        public typealias ListenerFunction = MFObserverDictionary.ListenerFunction
        public typealias ListnerHolder    = MFObserverDictionary.ListnerHolder

        private var mFrameName:         String
        private var mProperties:        MFObserverDictionary
        private var mChildren:          Array<MFFrame>
        private var mListnerHolders:    Array<ListnerHolder>
        private var mContext:           KSContext

        public var parent:              MFFrame?
        public var children: Array<MFFrame> { get {
                return mChildren
        }}

        public init(frameName fname: String, context ctxt: KSContext) {
                mFrameName      = fname
                mProperties     = MFObserverDictionary(context: ctxt)
                mChildren       = []
                mListnerHolders = []
                mContext        = ctxt
                parent          = nil
        }

        deinit {
                for listner in mListnerHolders {
                        mProperties.removeObserver(listnerHolder: listner)
                }
        }

        public func toScriptValue() -> JSValue {
                return JSValue(object: self, in: mContext)
        }

        public func value(name nm: String) -> NSObject? {
                return mProperties.value(forKey: nm)
        }

        public func _value(_ name: JSValue) -> JSValue {
                guard let nmstr = _name(name: name) else {
                        return JSValue(nullIn: mContext)
                }
                if let obj = value(name: nmstr) {
                        return JSValue(object: obj, in: mContext)
                } else {
                        return JSValue(nullIn: mContext)
                }
        }

        public func setValue(name nm: String, value val: MIValue) {
                mProperties.setValue(val.toObject(), forKey: nm)
        }

        public func _setValue(_ name: JSValue, _ val: JSValue) -> JSValue {
                guard let nmstr = _name(name: name) else {
                        return JSValue(bool: false, in: mContext)
                }
                mProperties.setValue(val, forKey: nmstr)
                return JSValue(bool: true, in: mContext)
        }

        public func addObserver(name nm: String, listner lfunc: @escaping ListenerFunction){
                let holder = mProperties.addObserver(forKey: nm, listnerFunction: lfunc)
                mListnerHolders.append(holder)
        }

        public func _addObserver(_ property: JSValue, _ cbfunc: JSValue) -> JSValue {
                guard let propstr = _name(name: property) else {
                        return JSValue(bool: false, in: mContext)
                }
                addObserver(name: propstr, listner: {
                        (_ : Any?) -> Void in
                        if let selfval = JSValue(object: self, in: self.mContext) {
                                cbfunc.call(withArguments: [selfval])
                        } else {
                                NSLog("[Error] Failed to add observer at \(#function)")
                        }
                })
                return JSValue(bool: true, in: mContext)
        }

        private func _name(name nm: JSValue) -> String? {
                if let str = nm.toString() {
                        return str ;
                } else {
                        NSLog("[Error] The name parameter must be string at \(#function)")
                        return nil
                }
        }
}
