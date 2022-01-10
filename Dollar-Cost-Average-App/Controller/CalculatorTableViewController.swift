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
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDCATextField: UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    
    
    var asset: Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFields()
    }
    
    private func setupViews() {
        symbolLabel.text = asset?.searchResult.symbol
        assetNameLabel.text = asset?.searchResult.name
        
        currencyLabels.forEach { (label) in
            label.text = asset?.searchResult.currency
        }
        
    }
    
    private func setupTextFields() {
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDCATextField.addDoneButton()
        initialDateOfInvestmentTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInitialDate", let dateSelectionTableViewController = segue.destination as? DateSelectionTableViewController, let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted {
            dateSelectionTableViewController.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
            dateSelectionTableViewController.didSelectDate  = { [weak self]
                index in self?.handleDateSelection(at: index)
            }
        }
    }
    
    private func handleDateSelection(at index: Int) {
        if let monthInfo = asset?.timeSeriesMonthlyAdjusted.getMonthInfo() {
            let monthInfo = monthInfo[index]
            let dateString = monthInfo.date.MMYYFormat
            initialDateOfInvestmentTextField.text = dateString
        }
    }
    
    
}

extension CalculatorTableViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == initialDateOfInvestmentTextField {
            performSegue(withIdentifier: "showInitialDate", sender: asset?.timeSeriesMonthlyAdjusted)
        }
        return false
    }
    
}
