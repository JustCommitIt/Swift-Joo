//
//  ViewController.swift
//  Study CoreGraphics
//
//  Created by 박재우 on 2023/04/16.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var selectedRotatingBlinkingButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedRotatingBlinkingButton.layer.cornerRadius = 10
    }

}

