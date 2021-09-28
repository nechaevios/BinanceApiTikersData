//
//  Ticker.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import Foundation

struct Ticker: Decodable {
    let symbol: String
    let price: String
}

struct OrderBook: Decodable {
    let bidPrice: String
    let bidQty: String
    let askPrice: String
    let askQty: String
}


