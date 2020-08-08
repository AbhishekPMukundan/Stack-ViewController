//
//  CTA.swift
//  Stack
//
//  Created by Abhishek on 25/07/2020.
//  Copyright © 2020 Abhishek. All rights reserved.
//

import UIKit

class CTA: UIViewController {
    
    @IBOutlet weak var ctaLabel: UILabel!{
        didSet {
            ctaLabel.text = ctaText
        }
    }
    var ctaText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    init(ctaLabelText: String) {
        self.ctaText = ctaLabelText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
