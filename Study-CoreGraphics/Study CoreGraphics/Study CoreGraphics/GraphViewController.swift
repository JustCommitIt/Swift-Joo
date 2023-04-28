//
//  GraphViewController.swift
//  Study CoreGraphics
//
//  Created by 박재우 on 2023/04/28.
//

import UIKit

class GraphViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let graphData = (data: [12.0, 11, 15, 19, 21, 15, 13, 11, 11.2], color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        let graphView = GraphView(data: graphData.data, color: graphData.color)
        view.addSubview(graphView)

        graphView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            graphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            graphView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            graphView.heightAnchor.constraint(equalToConstant: view.frame.height / 2),
        ])
    }
}
