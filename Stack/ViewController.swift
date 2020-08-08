//
//  ViewController.swift
//  Stack
//
//  Created by Abhishek on 25/07/2020.
//  Copyright © 2020 Abhishek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func proceedToLending(_ sender: Any) {
        let contoller1 = AmountViewController(nibName: "AmountViewController", bundle: nil)
        let contoller2 = EMIViewController(nibName: "EMIViewController", bundle: nil)
        let contoller3 = BankViewController(nibName: "BankViewController", bundle: nil)
        
        let vc = [contoller1, contoller2, contoller3]
        let cta = ["Proceed to EMI section", "select your bank account", "Tap for 1-click KYC"]
        
        let stackVC = StackController(viewControllers: vc, text: cta)
        stackVC.modalPresentationStyle = .fullScreen
        self.present(stackVC, animated: true, completion: nil)
    }
}

