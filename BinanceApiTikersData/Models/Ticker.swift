//
//  Ticker.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import Foundation

struct Ticker: Decodable {
    let symbol: String
    var price: String
}

extension Ticker: Comparable, Equatable {
    static func < (lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.symbol < rhs.symbol
    }
    
    static func == (lhs: Ticker, rhs: Ticker) -> Bool {
        lhs.symbol == rhs.symbol
    }

}

struct OrderBook: Decodable {
    let bidPrice: String
    let bidQty: String
    let askPrice: String
    let askQty: String
}


