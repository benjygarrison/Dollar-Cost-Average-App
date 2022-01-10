//
//  DateSelectionTableViewController.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/9/22.
//

import UIKit

class DateSelectionTableViewController: UITableViewController {
    
    //Skipped, checkmarks and slider (secs 7.32, 7.33, 7.34)
    
    
    var timeSeriesMonthlyAdjusted: TimeSeriesMonthlyAdjusted?
    private var monthInfo: [MonthInfo] = []
    var didSelectDate: ((Int) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMonthInfo()
        setupNavigation()
    }
    
    private func setupNavigation() {
        title = "Select date"
    }
    
    private func setupMonthInfo() {
        monthInfo = timeSeriesMonthlyAdjusted?.getMonthInfo() ?? []
    }
    
}

extension DateSelectionTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DateSelectionTableViewCell
        let index = indexPath.item
        let monthInfo = monthInfo[index]
        cell.configure(with: monthInfo, index: index)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectDate?(indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

    
    class DateSelectionTableViewCell: UITableViewCell {
        
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
        
        func configure(with monthInfo: MonthInfo, index: Int) {
       
            monthLabel.text = monthInfo.date.MMYYFormat
            
            if index == 1 {
                monthsAgoLabel.text = "1 month ago"
            } else if index > 1 {
                monthsAgoLabel.text = "\(index) months ago"
            } else {
                monthsAgoLabel.text = "Just invested"
            }
    }
}
