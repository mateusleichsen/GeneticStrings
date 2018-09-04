//
//  TextPopupViewController.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 03.09.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class TextPopoverViewController: UIViewController {
    var message:String!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.layer.borderColor = UIColor.white.cgColor
        messageLabel.layer.borderWidth = 1
        messageLabel.text = message
    }
}
