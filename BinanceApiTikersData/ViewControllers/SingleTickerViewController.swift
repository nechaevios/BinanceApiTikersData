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
        tickerPriceLabel.text = "Last price: \(selectedTicker.price)"
        
    }
    
    @IBAction func addToWatchlist(_ sender: UIButton) {
        if BinanceTickers.shared.addToWatchList(selectedTicker.symbol){
            successAlert()
        } else {
            failureAlert()
        }
        
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        alamofireUpdatelastPrice()
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
    
    // MARK: Networking
    func alamofireUpdatelastPrice() {
        AF.request(ApiEndpoints.singleTicker.rawValue + selectedTicker.symbol)
            .responseJSON { responseData in
                print(responseData)
            }
    }
    func fetchSingleTickerData() {
        NetworkManager.shared.fetch(dataType: Ticker.self, from: ApiEndpoints.singleTicker.rawValue + selectedTicker.symbol) { result in
            switch result {
            case .success(let currentTickerData):
                self.tickerPriceLabel.text = "Last price: \(currentTickerData.price)"
                BinanceTickers.shared.updateTickerInList(currentTickerData)
            case .failure(let error):
                self.tickerPriceLabel.text = "Last price: \(self.selectedTicker.price)"
                print(error)
            }
        }
        
    }
    
    func fetchTickerOrderBook() {
        NetworkManager.shared.fetch(dataType: OrderBook.self, from: ApiEndpoints.singleOrderBook.rawValue + selectedTicker.symbol) { result in
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
