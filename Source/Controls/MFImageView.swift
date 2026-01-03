/**
 * @file        MFImageView.swift
 * @brief      Define MFImageView class
 * @par Copyright
 *   Copyright (C) 2025 Steel Wheels Project
 */

import MultiUIKit
import JavaScriptKit
import JavaScriptCore
#if os(OSX)
import  AppKit
#else   // os(OSX)
import  UIKit
#endif  // os(OSX)

public class MFImageView: MIImageView, MFFrame
{
        static let FrameName            = "Image"

        public static let FileSlotName  = "file"       // NSURL

        private var mCore:      MFFrameCore? = nil
        private var mContext:   KSContext?   = nil

        public var frameName: String { get { return MFImageView.FrameName }}

        public var core: MFFrameCore { get {
                if let core = mCore {
                        return core
                } else {
                        fatalError("No core at \(#function)")
                }
        }}

        public init(context ctxt: KSContext){
                let frame = CGRect(x: 0.0, y: 0.0, width: 160, height: 32)
                super.init(frame: frame)

                let core = MFFrameCore(frameName: MFDropView.FrameName, context: ctxt)
                mCore    = core
                mContext = ctxt

                /* add listner for title */
                core.addObserver(name: MFImageView.FileSlotName, listner: {
                        (val: Any?) -> Void in
                        if let file = val as? NSString {
                                if let img = MIImage(contentsOf: URL(fileURLWithPath: file as String)) {
                                        super.image = img
                                } else {
                                        NSLog("[Error] Failed to load image:\(file) at \(#file)")
                                }
                        } else {
                                NSLog("[Error] Unexpected \(MFImageView.FileSlotName) value in \(#file)")
                        }
                })
        }
        
        @MainActor @preconcurrency required dynamic public init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
}

