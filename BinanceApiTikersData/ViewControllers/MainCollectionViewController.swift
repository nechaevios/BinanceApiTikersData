//
//  MainCollectionViewController.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {
    
    let userActions = UserActions.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
        
        cell.ActionLabel.text = userActions[indexPath.item].rawValue
        return cell
        
    }
        
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        
        switch userAction {
        case .showAllTickers: performSegue(withIdentifier: "showAllTickers", sender: nil)
        case .showBtcUsdt: performSegue(withIdentifier: "showBtcUsdt", sender: nil)
        }
        
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showImage" {
//            guard let singleImageVC = segue.destination as? SingleImageViewController else { return }
//            singleImageVC.imageData = singleImage
//
//        } else if segue.identifier == "showGif" {
//            guard let singleGifVC = segue.destination as? SingleGifViewController else { return }
//            singleGifVC.imageData = singleGif
//        }
    }

}

extension MainCollectionViewController {
    enum UserActions: String, CaseIterable {
        case showAllTickers = "All prices"
        case showBtcUsdt = "BTC / USDT"
    }
}
