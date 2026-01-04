//
//  ViewController.swift
//  UnitTest_iOS
//
//  Created by Tomoo Hamada on 2025/06/24.
//

import MultiUIKit
import MultiFrameKit
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
                let vm   = JSVirtualMachine()
                let ctxt = MFContext(virtualMachine: vm)
                
                let button0 = MFButton(context: ctxt, frameId: 0)
                mRootView.addSubview(button0)
        }
}

