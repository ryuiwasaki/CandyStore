//
//  ViewController.swift
//  CandyStore
//
//  Created by Ryu Iwasaki on 05/22/2016.
//  Copyright (c) 2016 Ryu Iwasaki. All rights reserved.
//

import UIKit
import CandyStore
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        CandyStore.setReleaseInfo(ReleaseInfo(version: "1.0.2", notes: "aaa")!)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        CandyStore.showInfoIfNeededInViewController(self)
        
    }

}

