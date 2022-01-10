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
    
    
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var investmentAmountLabel: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var annualReturnLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDCATextField: UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    @IBOutlet weak var dateSlider: UISlider!
    
    @Published private var initialInvestmentAmount: Int?
    @Published private var monthlyDCA: Int?
    @Published private var initialDateOfInvestment: Int?
    
    private var subscribers = Set<AnyCancellable>()
    private let dcaService = DCAService()
    
    var asset: Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTextFields()
        setupDateSlider()
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
    
    private func setupDateSlider() {
        if let count = asset?.timeSeriesMonthlyAdjusted.getMonthInfo().count {
            let dateSliderCount = count - 1
            dateSlider.maximumValue = dateSliderCount.floatValue
        }
    }
    
    private func observeForm() {
        $initialDateOfInvestment.sink { [weak self] (index) in
            guard let index = index else { return }
            self?.dateSlider.value = index.floatValue
            
            if let dateString = self?.asset?.timeSeriesMonthlyAdjusted.getMonthInfo()[index].date.MMYYFormat {
                self?.initialDateOfInvestmentTextField.text = dateString
            }
        }.store(in: &subscribers)
        
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
        
        Publishers.CombineLatest3($initialInvestmentAmount, $monthlyDCA, $initialDateOfInvestment).sink { [weak self] (initialInvestmentAmount, monthlyDCA, initialDateOfInvestment) in
            
            guard let initialInvestmentAmount = initialInvestmentAmount, let monthlyDCA = monthlyDCA, let initialDateOfInvestment = initialDateOfInvestment else { return }

            
            let result = self?.dcaService.calculate(initialInvestmentAmount: initialInvestmentAmount.doubleValue, monthlyDCA: monthlyDCA.doubleValue, initialDateOfInvestment: initialDateOfInvestment)
            
            self?.currentValueLabel.text = result?.currentValue.stringValue
            self?.investmentAmountLabel.text = result?.investmentAmount.stringValue
            self?.gainLabel.text = result?.gain.stringValue
            self?.yieldLabel.text = result?.yield.stringValue
            self?.annualReturnLabel.text = result?.annualReturn.stringValue
    
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
    
    
    @IBAction func dateSlderDidChange(_ sender: UISlider) {
        initialDateOfInvestment = Int(sender.value)
        print(sender.value)
    }
    
}

extension CalculatorTableViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == initialDateOfInvestmentTextField {
            performSegue(withIdentifier: "showInitialDate", sender: asset?.timeSeriesMonthlyAdjusted)
            return false
        }
        return true
    }
    
}
