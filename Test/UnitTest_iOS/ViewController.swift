//
//  ViewController.swift
//  UnitTest_iOS
//
//  Created by Tomoo Hamada on 2025/06/24.
//

import MultiUIKit
import MultiFrameKit
import JavaScriptKit
import UIKit
import JavaScriptCore

class ViewController: UIViewController
{

        @IBOutlet var mRootView: MIStack!

        override func viewDidLoad() {
                super.viewDidLoad()
                NSLog("viewDidLoad")
                // Do any additional setup after loading the view.

                // Do any additional setup after loading the view.
                guard let vm = JSVirtualMachine() else {
                        NSLog("[Error] Failed to allocate VM at \(#file)")
                        return
                }
                let ctxt = KSContext(virtualMachine: vm)

                let button0 = MFButton(context: ctxt)
                mRootView.addSubview(button0)
        }
}

