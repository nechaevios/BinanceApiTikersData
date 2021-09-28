//
//  SingleTickerViewController.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import UIKit

class SingleTickerViewController: UIViewController {
    
    
    @IBOutlet weak var tickerNameLabel: UILabel!
    @IBOutlet weak var tickerPriceLabel: UILabel!
    
    @IBOutlet weak var bidPriceLabel: UILabel!
    @IBOutlet weak var bidVolumeLabel: UILabel!
    
    @IBOutlet weak var askPriceLabel: UILabel!
    @IBOutlet weak var askVolumeLAbel: UILabel!
    
    var selectedTicker: Ticker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tickerNameLabel.text = selectedTicker.symbol
        tickerPriceLabel.text = "Last price: \(selectedTicker.price)"

    }
}

extension SingleTickerViewController {
    func fetchSingleTickerData() {
        NetworkManager.shared.fetch(dataType: Ticker.self, from: ApiEndpoint.singleTicker.rawValue + selectedTicker.symbol) { result in
            switch result {
            case .success(let currentTickerData):
                self.tickerPriceLabel.text = "Last price: \(currentTickerData.price)"
            case .failure(let error):
                self.tickerPriceLabel.text = "Last price: \(self.selectedTicker.price)"
                print(error)
            }
        }
    }
    func fetchTickerOrderBook() {
        NetworkManager.shared.fetch(dataType: OrderBook.self, from: ApiEndpoint.singleOrderBook.rawValue + selectedTicker.symbol) { result in
            switch result {
            case .success(let orderBookData):
                self.bidPriceLabel.text = orderBookData.bidPrice
                self.bidVolumeLabel.text = orderBookData.bidQty
                self.askPriceLabel.text = orderBookData.askPrice
                self.askVolumeLAbel.text = orderBookData.askQty
            case .failure(let error):
                print(error)
            }
        }
    }
}
