//
//  Ticker.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

struct Ticker: Decodable {
    let symbol: String
    let price: String
}
