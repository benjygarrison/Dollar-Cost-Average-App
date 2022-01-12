//
//  Dollar_Cost_Average_AppTests.swift
//  Dollar-Cost-Average-AppTests
//
//  Created by Ben Garrison on 1/10/22.
//

import XCTest
@testable import Dollar_Cost_Average_App

class Dollar_Cost_Average_AppTests: XCTestCase {

    var sut: DCAService! // "system under test"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DCAService()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    //MARK: All test functions must be prefixed with "test", ie testExample2(), testExample3(), etc. Just add something like "_" to beginning to disable a test.
    
    func testExample() throws {
        //Desired testing syntax:
        //given
        let num1 = 5
        let num2 = 3
        //when
        let result = sut.performSubtraction(num1: num1, num2: num2)
        //then
        XCTAssertEqual(result, 2)

    }
    
    func testExample2() {
        //Desired testing syntax:
        //given
        let num1 = 1
        let num2 = 2
        //when
        let result = performAddition(num1: num1, num2: num2)
        //then
        XCTAssertEqual(result, 3)
        XCTAssertTrue(result * 3 == 9)
    }
    
    //Generic function to be tested:
    
    func performAddition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
    
    /*Function naming convention:
     what + given + expectation
     */
    
    func testInvestmentAmount_whenDCAIsUSed_expectResult() {
        //given
        let initialAmount: Double = 100
        let monthlyDCA: Double = 100
        let initialDateOfInvestmentIndex = 5
        
        //when
        let totalInvestmentAmount = sut.getInvestmentAmount(initialInvestmentAmount: initialAmount,
                                                            monthlyDCA: monthlyDCA,
                                                            initialDateOfInvestment: initialDateOfInvestmentIndex)
        //then
        XCTAssertEqual(totalInvestmentAmount, 600)
    
    }
    
    //MARK: test case examples:
    
    private func buildWinningAsset() -> Asset {
        let metaData = buildMetadata()
        let searchResult = buildSearchResult()
        let timeSeries: [String : OpenHighLowCLose] = ["2021-01-31" : OpenHighLowCLose(open: "100", close: "110", adjustedClose: "110"),
                                                       "2021-02-28" : OpenHighLowCLose(open: "110", close: "120", adjustedClose: "120"),
                                                       "2021-03-31" : OpenHighLowCLose(open: "120", close: "130", adjustedClose: "130"),
                                                       "2021-04-30" : OpenHighLowCLose(open: "130", close: "140", adjustedClose: "140"),
                                                       "2021-05-31" : OpenHighLowCLose(open: "140", close: "150", adjustedClose: "150"),
                                                       "2021-06-30" : OpenHighLowCLose(open: "150", close: "160", adjustedClose: "160")]
        
        let timeSeriesMonthlyAdjusted = TimeSeriesMonthlyAdjusted(metadata: metaData,
                                                                  monthlyAdjustedTimeSeries: timeSeries)
        
        return Asset(searchResult: searchResult,
                     timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
    }
    
    private func buildLosingAsset() -> Asset {
        let metaData = buildMetadata()
        let searchResult = buildSearchResult()
        let timeSeries: [String : OpenHighLowCLose] = ["2021-01-31" : OpenHighLowCLose(open: "150", close: "140", adjustedClose: "140"),
                                                       "2021-02-28" : OpenHighLowCLose(open: "140", close: "130", adjustedClose: "130"),
                                                       "2021-03-31" : OpenHighLowCLose(open: "130", close: "120", adjustedClose: "120"),
                                                       "2021-04-30" : OpenHighLowCLose(open: "120", close: "110", adjustedClose: "110"),
                                                       "2021-05-31" : OpenHighLowCLose(open: "110", close: "100", adjustedClose: "100"),
                                                       "2021-06-30" : OpenHighLowCLose(open: "100", close: "90", adjustedClose: "90")]
        
        let timeSeriesMonthlyAdjusted = TimeSeriesMonthlyAdjusted(metadata: metaData,
                                                                  monthlyAdjustedTimeSeries: timeSeries)
        
        return Asset(searchResult: searchResult,
                     timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
    }
    
    
    private func buildSearchResult() -> SearchResult{
        return SearchResult(symbol: "ABC", name: "ABC CO", type: "ETF", currency: "USD")
    }
    
    private func buildMetadata() -> Metadata {
        return Metadata(symbol: "ABC")
    }
    
    //case 1: if asset is winning + DCA is used -> should return positive
   func testResult_givenWinningAssetAndDCAIsUSed_expectPositiveGains() {
       //given
       let asset = buildWinningAsset()
       let initialAmount: Double = 100
       let monthlyDCA: Double = 100
       let initialDateOfInvestmentIndex = 5
       //when
       let result = sut.calculate(asset: asset,
                                  initialInvestmentAmount: initialAmount,
                                  monthlyDCA: monthlyDCA,
                                  initialDateOfInvestment: initialDateOfInvestmentIndex)
       //then
       XCTAssertEqual(result.investmentAmount, 600, "investment amount is wrong") //<- error message if value is incorrect (optional)

    }
    
//    //case 1: if asset is winning + DCA is used -> should return positive
    func testResult_givenLosingAssetAndDCAIsUSed_expectNegativeGains() {
        //given
        let asset = buildLosingAsset()
        let initialAmount: Double = 100
        let monthlyDCA: Double = 100
        let initialDateOfInvestmentIndex = 5
        //when
        let result = sut.calculate(asset: asset,
                                   initialInvestmentAmount: initialAmount,
                                   monthlyDCA: monthlyDCA,
                                   initialDateOfInvestment: initialDateOfInvestmentIndex)
        //then
        print(result.currentValue)
        XCTAssertLessThan(result.currentValue, 600, "value entered is not greater than: \(result.currentValue)") //current value = $440.33
     }

}
