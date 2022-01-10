//
//  DateSelectionTableViewController.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/9/22.
//

import UIKit

class DateSelectionTableViewController: UITableViewController {
    
    var timeSeriesMonthlyAdjusted: TimeSeriesMonthlyAdjusted?
    var monthInfo: [MonthInfo] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMonthInfo()
    }
    
    private func setupMonthInfo() {
        if let monthInfo = timeSeriesMonthlyAdjusted?.getMonthInfo() {
            self.monthInfo = monthInfo
        }
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
        let monthInfo = monthInfo[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DateSelectionTableViewCell
        cell.configure(with: monthInfo)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}




    
    class DateSelectionTableViewCell: UITableViewCell {
        
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
        
        func configure(with monthInfo: MonthInfo) {
        backgroundColor = .red
    }
}
