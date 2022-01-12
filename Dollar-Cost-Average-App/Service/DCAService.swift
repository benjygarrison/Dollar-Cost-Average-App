//
//  DCAService.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/9/22.
//

import Foundation
import UIKit

struct DCAService {
    
    
    //MARK: generic test function:
    func performSubtraction(num1: Int, num2: Int) -> Int {
        return num1 - num2
    }
    
    func calculate(asset: Asset, initialInvestmentAmount: Double, monthlyDCA: Double, initialDateOfInvestment: Int) -> DCAresult {
        
        let investmentAmount = getInvestmentAmount(initialInvestmentAmount: initialInvestmentAmount, monthlyDCA: monthlyDCA, initialDateOfInvestment: initialDateOfInvestment)
        
        let latestSharePrice = getLatestSharePrice(asset: asset)
        
        let numberOfShares = getNumberOfShares(asset: asset, initialInvestmentAmount: initialInvestmentAmount, monthlyDCA: monthlyDCA, initialDateOfInvestment: initialDateOfInvestment)
        
        let currentValue = getCurrentValue(numberOfShares: numberOfShares, latestSharePrice: latestSharePrice)
        
        let isProfitable = currentValue > investmentAmount
        
        let gain = currentValue - investmentAmount
        
        let yield = gain / investmentAmount
        
        let annualReturn = getAnnualReturn(currentValue: currentValue, investmentAmount: investmentAmount, initialDateOfInvestment: initialDateOfInvestment)
        
        return .init(currentValue: currentValue,
                     investmentAmount: investmentAmount,
                     gain: gain,
                     yield: yield,
                     annualReturn: annualReturn,
                     isProfitable: isProfitable)
    }
    
    func getInvestmentAmount(initialInvestmentAmount: Double,
                                     monthlyDCA: Double,
                                     initialDateOfInvestment: Int) -> Double {
        
        var totalAmount = Double()
        totalAmount += initialInvestmentAmount
        let dcaAmount = initialDateOfInvestment.doubleValue * monthlyDCA
        totalAmount += dcaAmount
        
        return totalAmount
    }
    
    private func getCurrentValue(numberOfShares: Double, latestSharePrice: Double) -> Double {
        return numberOfShares * latestSharePrice
    }
    
    private func getAnnualReturn(currentValue: Double, investmentAmount: Double, initialDateOfInvestment: Int) -> Double {
        let rate = currentValue / investmentAmount
        let years = (initialDateOfInvestment.doubleValue + 1) / 12
        let result = pow(rate, (1 / years)) - 1
        return result
    }
    
    private func getLatestSharePrice(asset: Asset) -> Double {
        return asset.timeSeriesMonthlyAdjusted.getMonthInfo().first?.adjustedClose ?? 0
    }
    
    private func getNumberOfShares(asset: Asset, initialInvestmentAmount: Double, monthlyDCA: Double, initialDateOfInvestment: Int) -> Double {
        var totalShares = Double()
        let initialInvestmentOpenPrice = asset.timeSeriesMonthlyAdjusted.getMonthInfo()[initialDateOfInvestment].adjustedOpen
        let initialInvestmentShares = initialInvestmentAmount / initialInvestmentOpenPrice
        totalShares += initialInvestmentShares
        asset.timeSeriesMonthlyAdjusted.getMonthInfo().prefix(initialDateOfInvestment).forEach { (monthInfo) in
            let dcaInvestmentShares = monthlyDCA / monthInfo.adjustedOpen
            totalShares += dcaInvestmentShares
        }
        return totalShares
    }
    
}

struct DCAresult {
    
    let currentValue: Double
    let investmentAmount: Double
    let gain: Double
    let yield: Double
    let annualReturn: Double
    let isProfitable: Bool
}
