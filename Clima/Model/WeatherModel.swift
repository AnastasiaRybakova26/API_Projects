//
//  WeatherModel.swift
//  Clima
//
//  Created by Анастасия Рыбакова on 07.09.2023.
//

import Foundation

// 2.8 -> 3.1
// Модель данных для объекта Погода со свойствами, которые быдем передавать на экран

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    
    // computed property (always var)
    var temperatureString: String {
        String(format: "%.1f", temperature)
    }
    
    // computed property (always var)
    // В зависимости от полученного 
    var conditionName: String {
        switch conditionID {
        case 200...232: return "cloud.bolt"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"
        case 600...622: return "cloud.snow"
        case 701...781: return "cloud.fog"
        case 800: return "sun.max"
        case 801...804: return "cloud"
        default: return "cloud"
        }
    }
    
    // Инициализатор по умолчанию
//    init(conditionID: Int, cityName: String, temperature: Double) {
//        self.conditionID = conditionID
//        self.cityName = cityName
//        self.temperature = temperature
//    }
    
    // Инициализатор на основе WeatherData
    //Работает только один из двух, оба одновременно не работают
//    init(weatherData: WeatherData) {
//        self.conditionID = weatherData.weather[0].id
//        self.cityName = weatherData.name
//        self.temperature = weatherData.main.temp
//    }
    
}
