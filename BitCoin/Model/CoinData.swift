//
//  CoinData.swift
//  BitCoin
//
//  Created by Анастасия Рыбакова on 14.09.2023.
//

import Foundation

// 2.3 -> 2.4
// Сощдаем модель данных для декодирования полученного ответа в формате JSON
struct CoinData: Decodable {
    let rate: Double
}
