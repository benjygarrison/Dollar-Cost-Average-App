//
//  DCAService.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/9/22.
//

import Foundation

struct DCAService {
    
    func calculate(initialInvestmentAmount: Double, monthlyDCA: Double, initialDateOfInvestment: Int) -> DCAresult {
        
        let investmentAmount = getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount, monthlyDCA: monthlyDCA, initialDateOfInvestment: initialDateOfInvestment)
        
        return .init(currentValue: 0, investmentAmount: investmentAmount, gain: 0, yield: 0, annualReturn: 0)
    }
    
    private func getInvestmentAmount(initialInvestmentAmount: Double, monthlyDCA: Double, initialDateOfInvestment: Int) -> Double {
        
        var totalAmount = Double()
        totalAmount += initialInvestmentAmount
        let dcaAmount = initialDateOfInvestment.doubleValue * monthlyDCA
        totalAmount += dcaAmount
        
        return totalAmount
    }
    
}

struct DCAresult {
    
    let currentValue: Double
    let investmentAmount: Double
    let gain: Double
    let yield: Double
    let annualReturn: Double
    
}
