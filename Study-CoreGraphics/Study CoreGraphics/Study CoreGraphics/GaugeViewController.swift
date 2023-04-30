//
//  GaugeViewController.swift
//  Study CoreGraphics
//
//  Created by 박재우 on 2023/05/01.
//

import UIKit

class GaugeViewController: UIViewController {

    @IBOutlet weak var counterView: GaugeView!
    @IBOutlet weak var counterLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func pushButtonPressed(_ button: GaugeButton) {
        if button.isAddButton {
            if counterView.counter < 8 {
                counterView.counter += 1
            }
        } else {
            if counterView.counter > 1 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
    }
}
