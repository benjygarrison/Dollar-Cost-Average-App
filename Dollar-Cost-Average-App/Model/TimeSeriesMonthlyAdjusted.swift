//
//  TimeSeriesMonthlyAdjusted.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/9/22.
//

import Foundation

struct TimeSeriesMonthlyAdjusted: Decodable {
    
    let metadata: Metadata
    let monthlyAdjustedTimeSeries: [String: OpenHighLowCLose]
    
    
    
}

struct Metadata: Decodable {
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "2.Symbol"
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
