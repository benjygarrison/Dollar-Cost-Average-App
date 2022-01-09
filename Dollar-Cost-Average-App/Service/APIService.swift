//
//  APIService.swift
//  Dollar-Cost-Average-App
//
//  Created by Ben Garrison on 1/8/22.
//

import Foundation
import Combine

struct APIService {
    
    //Note: API keys optained from Alphavantage.co
    
    enum APIServiceError: Error {
        case encoding
        case badRequest
    }
    
    
    var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    let keys = ["AAWK5TIK1RDGCUNX", "JDXNA3L9FGWUR3GL", "8CA6861DXYDWIIBK"]
    
    
    
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        
        let result = parseQueryString(text: keywords)
        
        var symbol = String()
        
        switch result {
            case .success(let query):
                symbol = query
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
        }
        
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(symbol)&apikey=\(API_KEY)"
        
        let urlResult = parseURL(urlString: urlString)
        
        switch urlResult {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url).map({ $0.data }).decode(type: SearchResults.self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
    }
    
    
    
    func fetchTimeSeriesMonthlyAdjusted(keywords: String) -> AnyPublisher<TimeSeriesMonthlyAdjusted, Error> {
        
        let result = parseQueryString(text: keywords)
        
        var symbol = String()
        
        switch result {
            case .success(let query):
                symbol = query
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
        }
        
        let urlString = "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(API_KEY)"
        
        let urlResult = parseURL(urlString: urlString)
        
        switch urlResult {
        case .success(let url):
            return URLSession.shared.dataTaskPublisher(for: url).map({ $0.data }).decode(type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
        
    }
    
    
    
    private func parseQueryString(text: String) -> Result<String, Error> {
        
        if let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return .success(query)
        } else {
            return .failure(APIServiceError.encoding)
        } //to avoid crash when typing space and url contains "%20"
    }
    
    
    private func parseURL(urlString: String) -> Result<URL, Error> {
        
        if let url = URL(string:urlString) {
            return .success(url)
        } else {
            return .failure(APIServiceError.badRequest)
        }
    }
    
    
}



