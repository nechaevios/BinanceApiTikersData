//
//  NetworkManager.swift
//  BinanceApiTikersData
//
//  Created by Nechaev Sergey  on 28.09.2021.
//

import Foundation
import Alamofire

enum ApiEndpoints: String {
    case allTickers = "https://api.binance.com/api/v3/ticker/price"
    case singleTicker = "https://api.binance.com/api/v3/ticker/price?symbol="
    case singleOrderBook = "https://api.binance.com/api/v3/ticker/bookTicker?symbol="
    
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch<T: Decodable>(dataType: T.Type, from url: String, completion: @escaping(Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            do {
                let decoder = JSONDecoder()
                
                let type = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(type))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchLastPrice(_ url: String, completion: @escaping(Result <Ticker, NetworkError>) -> Void) {
        AF.request(url)
            .validate()
            .responseJSON { responseData in
                switch responseData.result {
                case .success(let value):
                    guard let lastPriceData = value as? [String: Any] else { return }
                    let tickerData = Ticker(tickerData: lastPriceData)
                    
                    DispatchQueue.main.async {
                        completion(.success(tickerData))
                    }
                case .failure:
                    completion(.failure(.decodingError))
                }
            }
    }
    
    func fetchOrderBook(_ url: String, completion: @escaping(Result <OrderBook, NetworkError>) -> Void) {
        AF.request(url)
            .validate()
            .responseDecodable(of: OrderBook.self) { responseData in
                switch responseData.result {
                case .success(let value):
                    completion(.success(value))
                case .failure:
                    completion(.failure(.decodingError))
                }
            }
    }
    
    func fetchLastPriceWSS(_ url: String, completion: @escaping(Result <Ticker, NetworkError>) -> Void) {
        
    }
}
