//
//  CoinManager.swift
//  BitCoin
//
//  Created by Анастасия Рыбакова on 14.09.2023.
//

import Foundation

// 2.5 -> 2.6
// Проктокол, в котором объявляем методы делегата: эти методы по обновлению UI во VC  и обработке ошибок
protocol CoinManagerProtocol {
    func didUpdateCoinValueUI(_ coinManager: CoinManager, price: Double)
    func didFailWithError(error: Error)
}


struct CoinManager {
    
    // 2.4 -> 2.5
    // Делегат, который будет выполнять методы в performRequest, сами методы описаны во ViewController
    var delegate: CoinManagerProtocol?
    
    // curl https://rest.coinapi.io/v1/exchangerate/BTC/USD
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "0C70E8E7-4864-4D4B-AFAC-283F687FA04E"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    // 1.6 -> 2.1
    // Передаем выбранную валюту из VC чтобы по валюте делать запрос API
    func getCoinPrice(for currency: String) {
        print("Currency in CoinManager is \(currency)")
        
        // Ссылка на запрос в формате String
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print("URL = \(urlString)")
        
        // Вызов запроса API в сеть
        performRequest(with: urlString)
    }
    
    // 2.1 -> 2.2
    // Создаем запрос API (используем делегат из шага 2.2 и протокол из шага 2.3)
    private func performRequest(with urlString: String) {
        
        // 1) Create a URL
        guard let url = URL(string: urlString) else {
            print("Wrong URL String")
            return
        }
        
        // 2) Create URLSession
        let session = URLSession(configuration: .default)
        
        // 3) Give the session a task
        let task = session.dataTask(with: url) { data, response, error in
            
            // Проверили наличие ошибки, если она есть, дальше не идем
            if error != nil {
//                print(error!) // обрабатываем ошибку делегатом
                delegate?.didFailWithError(error: error!)
            }
            
            // Получили данные с сервера
            guard let safeData = data else { return }
            let safeDataString = String(data: safeData, encoding: .utf8)
            print(safeDataString)
            
            // Декодируем данные и получаем значение цены Double (шаг 2.2)
            guard let coinPrice = parseJSON(safeData) else { return }
            
            // 2.6 -> 3.1
            // Делегат передает данные во VC и обновлят там UI
            delegate?.didUpdateCoinValueUI(self, price: coinPrice)
        }
        
        // 4) Start the task
        task.resume()
    }
    
    
    // 2.2 -> 2.3
    // Декодируем ответ с сервера (на шаге 2.3 создаем модель данных)
    private func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        
        // Декодируем в методе do-catch тк .decode throws ошибку
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            print("Last price = \(lastPrice)")
            return lastPrice
        } catch {
            print(error)
            return nil
        }
    }
}
