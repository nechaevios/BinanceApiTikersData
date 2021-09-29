//
//  SingleTickerViewController.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import UIKit
import Alamofire

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
        tickerPriceLabel.text = selectedTicker.price
    }
    
    @IBAction func addToWatchlist(_ sender: UIButton) {
        if BinanceTickers.shared.addToWatchList(selectedTicker.symbol){
            successAlert()
        } else {
            failureAlert()
        }
        
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        alamofireUpdateLastPrice()
        alamofireUpdateOrderBook()
    }
    
    private func successAlert() {
        let alert = UIAlertController(
            title: "Success",
            message: "\(selectedTicker.symbol) was added to watchlist",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
        
    }
    
    private func failureAlert() {
        let alert = UIAlertController(
            title: "Failure",
            message: "\(selectedTicker.symbol) is already in watchlist",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
        
    }
    
}

extension SingleTickerViewController {
    
    // MARK: UIUpdate
    private func updateLabelsData(in labels: UILabel..., with texts: String..., forLastPrice: Bool) {
        let lastPriceLabelAddition = forLastPrice ? "Last price: " : ""
        let pairs = zip(labels, texts)
        pairs.forEach { pair in
            pair.0.text = lastPriceLabelAddition + pair.1
        }
    }
}


extension SingleTickerViewController {
    
    // MARK: Networking
    func alamofireUpdateLastPrice() {
        NetworkManager.shared.fetchLastPrice(ApiEndpoints.singleTicker.rawValue + selectedTicker.symbol)
        { response in
            switch response {
            case .success(let tickerData):
                self.updateLabelsData(
                    in: self.tickerPriceLabel,
                    with: tickerData.price,
                    forLastPrice: true
                )
                BinanceTickers.shared.updateTickerInList(tickerData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func alamofireUpdateOrderBook() {
        NetworkManager.shared.fetchOrderBook(ApiEndpoints.singleOrderBook.rawValue + selectedTicker.symbol)
        { response in
            switch response {
            case .success(let orderBookData):
                self.updateLabelsData(
                    in: self.bidPriceLabel, self.bidVolumeLabel,
                    self.askPriceLabel, self.askVolumeLAbel,
                    with: orderBookData.bidPrice, orderBookData.bidQty,
                    orderBookData.askPrice, orderBookData.askQty,
                    forLastPrice: false
                )
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func fetchSingleTickerData() {
        NetworkManager.shared.fetch(
            dataType: Ticker.self,
            from: ApiEndpoints.singleTicker.rawValue + selectedTicker.symbol
        ) { result in
            switch result {
            case .success(let currentTickerData):
                self.updateLabelsData(
                    in: self.tickerPriceLabel,
                    with: currentTickerData.price,
                    forLastPrice: true
                )
                BinanceTickers.shared.updateTickerInList(currentTickerData)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    func fetchTickerOrderBook() {
        NetworkManager.shared.fetch(
            dataType: OrderBook.self,
            from: ApiEndpoints.singleOrderBook.rawValue + selectedTicker.symbol
        ) { result in
            switch result {
            case .success(let orderBookData):
                self.updateLabelsData(
                    in: self.bidPriceLabel, self.bidVolumeLabel,
                    self.askPriceLabel, self.askVolumeLAbel,
                    with: orderBookData.bidPrice, orderBookData.bidQty,
                    orderBookData.askPrice, orderBookData.askQty,
                    forLastPrice: false
                )
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}
