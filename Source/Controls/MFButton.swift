/**
 * @file        MFButton.swift
 * @brief      Define MFButton class
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

public class MFButton: MIButton, MFFrame
{
        public static let FrameName            = "Button"
        public static let TitleSlotName        = "title"        // NSString
        public static let ClickedEventName     = "clicked"

        private var mCore:      MFFrameCore? = nil
        private var mContext:   KSContext?   = nil

        public var frameName: String { get {
                return MFButton.FrameName
        }}

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

                let core = MFFrameCore(frameName: MFButton.FrameName, context: ctxt)

                /* add listner for title */
                core.addObserver(name: MFButton.TitleSlotName, listner: {
                        (val: Any?) -> Void in
                        if let str = val as? NSString {
                                super.title = str as String
                        } else {
                                NSLog("[Error] Unexpected \(MFButton.TitleSlotName) value in \(#file)")
                        }
                })

                /* set callback for the click */
                super.setButtonPressedCallback({
                        () -> Void in
                        //NSLog("(\(#function) clicked")
                        if let obj = core.value(name: MFButton.ClickedEventName) as? JSValue {
                                //NSLog("call clicked event of MFButton")
                                obj.call(withArguments: [])
                        }
                })

                mCore    = core
                mContext = ctxt
        }

        @MainActor @preconcurrency required dynamic init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
}

