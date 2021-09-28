//
//  TickerCell.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import UIKit

class TickerCell: UITableViewCell {

    @IBOutlet weak var tickerPriceLabel: UILabel!
    @IBOutlet weak var tickerNameLabel: UILabel!
    
    func configure(with ticker: Ticker) {
        tickerNameLabel.text = ticker.symbol
        tickerPriceLabel.text = ticker.price
        
    }


}
