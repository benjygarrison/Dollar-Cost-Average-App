//
//  TimeSeriesMonthlyAdjusted.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/9/22.
//

import Foundation
import CoreText

struct MonthInfo {
    let date: Date
    let adjustedOpen: Double
    let adjustedClose: Double
}

struct TimeSeriesMonthlyAdjusted: Decodable {
    let metadata: Metadata
    let monthlyAdjustedTimeSeries: [String: OpenHighLowCLose]
    
    enum CodingKeys: String, CodingKey {
     case metadata = "Meta Data"
        case monthlyAdjustedTimeSeries = "Monthly Adjusted Time Series"
    }
    
    func getMonthInfo() -> [MonthInfo] {
        var monthInfo: [MonthInfo] = []
        let sortedTimeSeriesMonthlyAdjusted = monthlyAdjustedTimeSeries.sorted(by: { $0.key > $1.key })
        print("sorted: \(sortedTimeSeriesMonthlyAdjusted)")
        return monthInfo
    }
    
}

struct Metadata: Decodable {
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}

struct OpenHighLowCLose: Decodable {
    let open: String
    let close: String
    let adjustedClose: String
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
    }
    
}
