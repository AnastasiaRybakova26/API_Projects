//
//  WetherManager.swift
//  Clima
//
//  Created by Анастасия Рыбакова on 07.09.2023.
//

import Foundation
import CoreLocation

// 3.1 -> 3.2
// Создаем протокол, в котором указываем методы, которые будет реализовывать делегат WeatherManager. Делегат будет обрабновлять UI данными из объекта типа WeatherModel и обрабатывать ошибку
protocol WeatherManagerDelegate {
    func didUpdateWeatherUI(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


// 2.0 -> 2.1
// Создаем структуру, которая будет выполнять запрос API в сеть
struct WeatherManager {
    
    // https://openweathermap.org
    
    // 3.2 -> 3.3
    // Создаем делегата (он потом будет VC), который будет связывать WeatherManager и WeatherViewController для обновления данных о погоде
    var delegate: WeatherManagerDelegate?
    
    
    // 2.1 -> 2.2
    // Ссылка на запрос в формате String
    private let wearherURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(Constants.id)&units=metric"
    
    // 2.2 -> 2.3
    // Этот метод вызываем на VC через экземпляр weatherManager
    // Метод создает url с указанием города и выполняет запрос API в интернет
    func fetchWeather(cityName: String) {
        let urlString = "\(wearherURL)&q=\(cityName)"  // Создаем urlString с учетом города
//        print(urlString)  // for check
        performRequest(with: urlString) // выполняем запрос в сеть по URL
    }
    
    // 4.6 -> 4.7
    // Аналогичный метод, который создает URL на основе текущих координат и также выполняет запрос API
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(wearherURL)&lat=\(latitude)&lon=\(longitude)"  // по геопозиции
        performRequest(with: urlString)
    }
    
    
    // 2.5 -> 2.6
    // Выполняем запрос API
    private func performRequest(with urlString: String) {
        
        // 1) Create a URL
        guard let url = URL(string: urlString) else {
            print("Wrong URL")
            return
        }
        
        // 2) Create URLSession
        let session = URLSession(configuration: .default)
        
        // 3) Give the session a task = получение данных с сервера по созданному URL
        // = метод .dataTask(with: url) и completionHandler
        // В ответ от сервера получаем 3 параметра: data, response, error
        // completionHandler обрабатывает ответ с сервера (он приходит не сразу), это клоужер
        // Два метода будет выполнять делегат (= ViewController)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            // Убираем опционал с полученной data
            guard let safeData = data else { return }
//            let safeDataString = String(data: safeData, encoding: .utf8)
//            print(safeDataString)  // print for check
            
            // Создаем объект weather типа WeatherModel, декодируем данные мотодом parseJSON (шаг 2.6)
            // Также разворачиваем опционал через guard
            guard let weather = self.parseJSON(safeData) else { return }
            
            
            // 3.3 -> 3.4
            // Объект weather необходимо направить во VC, чтобы отобразить там данные
            // Делегат реализует метод didUpdateWeather
            // В метод передаем только что созданный объект weather типа WeatherModel
            // Сама реализация здесь не важна, ее пропишем в делегате (=VC)
            delegate?.didUpdateWeatherUI(self, weather: weather)

        }
        
        
        // 4) Start the task (resume = возобновить, задачи создаются в приостановленном виде)
        // Выполняется асинхронно, тк запрос передается и получает данные не мгновенно
        task.resume()
        
    }
    
    
    
    // 2.6 -> 2.7 
    // Декодирование JSON ответа из сети, принимаем данные типа Data
    // результат = объект weather типа WeatherModel (см шаг 2.8), с ним будет работать делегат (=VC)
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            // Печать полученных данных из API для проверки успеха запроса
            print("wetherData: \(weatherData) ")
            if let jsonResponse = String(data: weatherData, encoding: .utf8) {
                print("Response: \(jsonResponse)")
            }
            
            
            // Метод decode выбрасывает (throws) ошибку, поэтому пишем его в блоке do-catch
            // Указываем тип, в который будем преобразовывать полученные данные = WeatherData.self (см шаг 2.7)
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
//            print(decodedData.name)  // print for check
            
            // Получили структуру WeatherData и сохраняем из нее нужные данные
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city = decodedData.name
            
            // создаем объект weather типа WeatherModel (шаг 2.8) и заполняем его полученными из сети данными
            let weather = WeatherModel(
                conditionID: id,
                cityName: city,
                temperature: temp)
            
            // Создать объект weather типа WeatherModel можно и через второй инициализатор, принимющий WeatherData
//            let wether = WeatherModel(weatherData: decodedData)

            return weather
            
            // Если ошибка при расшифровке данных, то ее обрабатывает делегат (реализация метода прописана в VC, кот является делегатом)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
}
