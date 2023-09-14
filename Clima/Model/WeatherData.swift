//
//  WeatherData.swift
//  Clima
//
//  Created by Анастасия Рыбакова on 07.09.2023.
//

import Foundation

// 2.7 -> 2.8
// Модель данных для декодирования JSON - ответа из сети
// Decodable = A type that can decode itself from an external representation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}
