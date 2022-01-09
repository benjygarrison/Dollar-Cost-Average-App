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
    
    var API_KEY: String {
        return keys.randomElement()! // ?? ""
    }
    
    let keys = ["AAWK5TIK1RDGCUNX", "JDXNA3L9FGWUR3GL", "8CA6861DXYDWIIBK"]
    
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url).map({ $0.data }).decode(type: SearchResults.self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
        
    }
    
}



