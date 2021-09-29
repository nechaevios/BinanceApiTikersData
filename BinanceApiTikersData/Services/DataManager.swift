//
//  DataManager.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import Foundation

class BinanceTickers {
    static let shared = BinanceTickers()
    
    private init() {}
    
    var tickerList: [Ticker] = []
    private var watchList: [Ticker] = []
    private var watchListSymbols: [String] = []
    
    func updateTickerInList(_ ticker: Ticker) {
        if let tickerIndex = tickerList.firstIndex(where: { $0.symbol == ticker.symbol }) {
            tickerList[tickerIndex].price = ticker.price
        } else {
            tickerList.append(ticker)
        }
        
    }
    
    func addToWatchList(_ symbol: String) -> Bool {
        if !watchListSymbols.contains(symbol) {
            watchListSymbols.append(symbol)
            return true
            
        }
        return false
        
    }
    
    func removeFromWatchList (_ symbol: String) -> Bool {
        if let symbolIndex = watchListSymbols.firstIndex(where: { $0 == symbol }) {
            watchListSymbols.remove(at: symbolIndex)
            return true
            
        }
        return false
        
    }
    
    func isSymbolInWatchlist(_ symbol: String) -> Bool {
        watchListSymbols.contains(symbol)
        
    }
    
    func generateWatchList() -> [Ticker] {
        self.tickerList.filter { self.watchListSymbols.contains( $0.symbol ) }
        
    }

}
