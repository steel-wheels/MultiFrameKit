//
//  ViewController.swift
//  UnitTest_macOS
//
//  Created by Tomoo Hamada on 2025/06/18.
//

import MultiFrameKit
import MultiUIKit
import JavaScriptKit
import JavaScriptCore
import Cocoa

class ViewController: MIViewController
{

        @IBOutlet var mRootView: MIStack!

        override func viewDidLoad() {
                super.viewDidLoad()

                // Do any additional setup after loading the view.
                let vm   = JSVirtualMachine()
                let ctxt = KSContext(virtualMachine: vm)

                let lib     = MFLibrary()
                let storage = MITextStorage()
                if let err = lib.load(into: ctxt, storage: storage) {
                        NSLog("[Error] \(err.description)")
                }

                let button0 = MFButton(context: ctxt)
                mRootView.addSubview(button0)
        }

        override var representedObject: Any? {
                didSet {
                // Update the view, if already loaded.
                }
        }


}

