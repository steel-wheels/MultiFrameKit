/**
 * @file        MFStack.swift
 * @brief      Define MFStack class
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

public class MFStack: MIStack, MFFrame
{
        static let FrameName = "Box"

        private var mContext:   MFContext?   = nil
        private var mCore:      MFFrameCore? = nil

        public init(context ctxt: MFContext){
                let frame = CGRect(x: 0.0, y: 0.0, width: 160, height: 32)
                super.init(frame: frame)

                let core = MFFrameCore(frameName: MFStack.FrameName, context: ctxt)
                mCore    = core
                mContext = ctxt
        }

        @MainActor @preconcurrency required dynamic init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }

        public var frameName: String { get {
                return MFStack.FrameName
        }}

        public var core: MFFrameCore { get {
                if let core = mCore {
                        return core
                } else {
                        fatalError("No core at \(#function)")
                }
        }}
}

