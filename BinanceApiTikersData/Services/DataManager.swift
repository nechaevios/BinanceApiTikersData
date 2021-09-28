//
//  DataManager.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import Foundation

class WatchList {
    static let shared = WatchList()
    
    private init() {}
    
    var watchList: [Ticker] = []
    
    func addToWatchList(_ ticker: Ticker) -> Bool {
        if !watchList.contains(ticker) {
            watchList.append(ticker)
            return true
        }
        return false
    }

}

class TickerList {
    static let shared = TickerList()
    
    private init() {}
    
    var tickerList: [Ticker] = []
    
    func updateTickerInList(_ ticker: Ticker) {
        if let tickerIndex = tickerList.firstIndex(where: { $0.symbol == ticker.symbol }) {
            tickerList[tickerIndex].price = ticker.price
        } else {
            tickerList.append(ticker)
        }
        
    }

}
