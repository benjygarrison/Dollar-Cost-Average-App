//
//  DCAService.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/9/22.
//

import Foundation

struct DCAService {
    
    func calculate(initialInvestmentAmount: Double, monthlyDCA: Double, initialDateOfInvestment: Int) -> DCAresult {
        
        
        
        return .init(currentValue: 0, investmentAmount: 0, gain: 0, yield: 0, annualReturn: 0)
    }
    
}

struct DCAresult {
    
    let currentValue: Double
    let investmentAmount: Double
    let gain: Double
    let yield: Double
    let annualReturn: Double
    
}
