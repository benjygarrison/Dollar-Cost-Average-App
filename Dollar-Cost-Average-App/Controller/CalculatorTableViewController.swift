//
//  CalculatorTableViewController.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/9/22.
//

import Foundation
import UIKit
import Combine

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDCATextField: UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    
    @Published private var initialInvestmentAmount: Int?
    @Published private var monthlyDCA: Int?
    //@Published private var inititalDateOfInvestment
    
    private var subscribers = Set<AnyCancellable>()
    
    
    var asset: Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFields()
        observeForm()
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
    
    private func observeForm() {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: initialInvestmentAmountTextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self] (text) in
            self?.initialInvestmentAmount = Int(text) ?? 0
            print("\(text)")
        }.store(in: &subscribers)

        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: monthlyDCATextField).compactMap({
            ($0.object as? UITextField)?.text
        }).sink { [weak self] (text) in
            self?.monthlyDCA = Int(text) ?? 0
            print("\(text)")
        }.store(in: &subscribers)
        
        Publishers.CombineLatest($initialInvestmentAmount, $monthlyDCA).sink { (initialInvestmentAmount, monthlyDCA) in
            print()
        }.store(in: &subscribers)
        
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
        guard navigationController?.visibleViewController is DateSelectionTableViewController else { return }
        navigationController?.popViewController(animated: true)
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
