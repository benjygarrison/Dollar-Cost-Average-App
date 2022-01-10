//
//  CalculatorTableViewController.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/9/22.
//

import Foundation
import UIKit

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    
    var asset: Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        symbolLabel.text = asset?.searchResult.symbol
        assetNameLabel.text = asset?.searchResult.name
    }
    
    
}
