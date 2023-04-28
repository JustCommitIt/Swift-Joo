//
//  ViewController.swift
//  Study CoreGraphics
//
//  Created by 박재우 on 2023/04/16.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var buttons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()

        buttons.forEach{ button in
            button.layer.cornerRadius = 10
        }
    }

}
