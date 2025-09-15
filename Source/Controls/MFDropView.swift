/**
 * @file        MFDropView.swift
 * @brief      Define MFDropView class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiUIKit
import JavaScriptCore
#if os(OSX)
import  AppKit
#else   // os(OSX)
import  UIKit
#endif  // os(OSX)

open class MFDropView: MIDropView, MFFrame
{
        static let FrameName            = "Button"

        private var mCore:      MFFrameCore? = nil
        private var mContext:   MFContext?   = nil

        public var frameName: String { get {
                return MFDropView.FrameName
        }}

        public var core: MFFrameCore { get {
                if let core = mCore {
                        return core
                } else {
                        fatalError("No core at \(#function)")
                }
        }}

        public init(context ctxt: MFContext, frameId fid: Int){
                let frame = CGRect(x: 0.0, y: 0.0, width: 160, height: 32)
                super.init(frame: frame)
                self.coreTag = fid

                let core = MFFrameCore(frameName: MFDropView.FrameName, frameId: fid, context: ctxt)
                mCore    = core
                mContext = ctxt
        }

        @MainActor @preconcurrency required dynamic public init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
}

