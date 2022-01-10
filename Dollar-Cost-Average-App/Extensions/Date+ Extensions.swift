//
//  Date+ Extensions.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/9/22.
//

import Foundation

extension Date {
    
//good date resource: nsdateformatter.com
    
    
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
