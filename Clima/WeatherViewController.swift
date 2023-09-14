//
//  ViewController.swift
//  Clima
//
//  Created by Анастасия Рыбакова on 07.09.2023.
//

import UIKit
import SnapKit

// 4.1 -> 4.2 Импортируем менеджер положений
import CoreLocation

class WeatherViewController: UIViewController {
    
// MARK: - User Unterface
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Constants.background)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var mainStackView = UIStackView(
        axis: .vertical,
        distribution: .fill,
        alignment: .trailing,
        spacing: 10)

    private lazy var headerStackView = UIStackView(
        axis: .horizontal,
        distribution: .fill,
        alignment: .fill,
        spacing: 10)
    
    private lazy var geoButton: UIButton = {
        let button = UIButton(backgroundImage: Constants.geoButtonImage)
        button.addTarget(self, action: #selector(currentLocationPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.accessibilityLanguage = "en"
        textField.returnKeyType = .go
        textField.autocapitalizationType = .words
        textField.textAlignment = .right
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemFill
        textField.font = .systemFont(ofSize: 25)
        textField.placeholder = Constants.serchPlaceholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(backgroundImage: Constants.searchButtonImage)
        button.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)
        return button
    }()
    
    
    private var conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Constants.conditionImage)
        imageView.tintColor = UIColor(named: Constants.weatherColor)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private lazy var tempStackView = UIStackView(
        axis: .horizontal,
        distribution: .fill,
        alignment: .fill,
        spacing: 0)
    
    private lazy var tempLabel = UILabel(text: "21", size: 80, weight: .black)
    private lazy var tempTypeLabel = UILabel(text: Constants.celsius, size: 100, weight: .light)
    private lazy var cityLabel = UILabel(text: "London", size: 30, weight: .light)
    private lazy var emptyView = UIView()
    
    
// MARK: - private propetries
    
    // 2.3 -> 2.4
    // Через данный объект соединяем VC и WeatherManager, где выполняется запрос в сеть
    // Тут будем использовать название города
    private var weatherManager = WeatherManager()
    
    // 4.2 -> 4.3
    // Аналогично пункту 2.3, только используем геопозицию
    // Через данный объект соединяем VC и WeatherManager, где выполняется запрос в сеть
    // По умолчанию используем CLLocationManager для определения текущей геопозиции
    private let locationManager = CLLocationManager()
    

// MARK: - Life sycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraints()
        self.setDelegates()
        self.setupLocationSettings()
    }

    
// MARK: - Private methodes
    
    private func setDelegates() {
        //1.1 -> 1.2
        // Устанавливаем VC делегатом для работы с методами textField (встроенный функционал)
        searchTextField.delegate = self
        
        // 3.4 -> 3.5
        // Устанавливаем делегатами VC, чтобы он выполнял методы протокола WeatherManagerDelegate
        weatherManager.delegate = self
    
        // 4.3 -> 4.4
        // Устанавливаем делегатом VC, чтобы он определял текущую геопозицию (встроенные методы)
        locationManager.delegate = self
    }
    
    private func setupLocationSettings() {
        // 4.4 -> 4.5
        // Запрашиваем у пользователя разрешение на определение текущей геопозиции
        // В info.plist прописываем соотв ключ словаря "Privacy - Location when In Use Usage Description
        locationManager.requestWhenInUseAuthorization()
        // Определяем текущую геопозицию 1 раз
        locationManager.requestLocation()
//        locationManager.startUpdatingLocation() // Обновляет положение
    }
    
    
// MARK: - Actions
    // При нажатии на кнопку вызываем метод hideKeyboard, в нем будем фиксировать название города
    @objc private func searchPressed(_sender: UIButton) {
        print("Search button pressed")
        self.hideKeyboard()
    }
    
    // 4.7  При нажатии на кнопку обновляем геопозицию и отображаем поготу по местоположению
    @objc private func currentLocationPressed(_ sender: UIButton) {
        print("Current Location button pressed")
        locationManager.requestLocation()
    }
    
    @objc private func hideKeyboard() {
        searchTextField.endEditing(true)
    }
    

}


// MARK: - WeatherManagerDelegate

    // 3.5
    // Подписываем VC под протокол WeatherManagerDelegate, чтобы он в качестве делегата мог выполнять два метода протокола
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeatherUI(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        // Реализуем метод обновления UI на главном потоке
        DispatchQueue.main.async {
            self.tempLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }

    }
    
    // Реализуем метод обработки ошибки
    func didFailWithError(error: Error) {
        print(error)
    }
}



// MARK: - UITextFieldDelegate

// 1.2
// To manage the editing and validation of text in a text field object
extension WeatherViewController: UITextFieldDelegate {
    
    // Нужно ли обрабатывать нажатие кнопки return на клавиатуре
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Нажали кнопку GO на клавиатуре")
        print(searchTextField.text ?? "no text")
        self.hideKeyboard()
        return true
    }
    
    // Когда пользователь ничего не вводит в поле и нажимает любую кнопку, ставим запрет на окончание редактироания поля (false)
    // (deselect the textField)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type city's name in English"
            return false
        }
    }
    
    
    // 2.4 -> 2.5
    // Зафиксировали имя города и вызываем метод fetchWeather = направляем запроc в сеть, чтобы получить данные о погоде по названию города
    // Метод срабатывает, когда текст закончили редактировать
    // Этот метод вызываетcz встроенныv методjv textField.endEditing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            print("Ввели название города = ", city)
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
        textField.placeholder = Constants.serchPlaceholder
    }

}



// MARK: - CLLocationManagerDelegate

    // 4.5 -> 4.6
    // Эти методы запускает locationManager.requestLocation()
    // Они уже встроены, в них прописываем свою логику
extension WeatherViewController: CLLocationManagerDelegate {
    
    // Эти методы запускает locationManager.requestLocation()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("CLLocationManagerDelegate")
        
        // получаем текущее местоположение
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()  // Останавливаем процесс, чтобы можно было вызвать метод повторно через время
        
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        print(lat, lon)
        
        // Вызываем запрос в сеть, созданный в пункет 4.6 (в структуре WeatherManager)
        self.weatherManager.fetchWeather(latitude: lat, longitude: lon)
    }
    
    // второй обязательный метод делегата
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}






// MARK: - setUp View, set Constraints

extension WeatherViewController {
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(backgroundImageView)
        view.addSubview(mainStackView)
    
        mainStackView.addArrangedSubview(headerStackView)
        
        headerStackView.addArrangedSubview(geoButton)
        headerStackView.addArrangedSubview(searchTextField)
        headerStackView.addArrangedSubview(searchButton)
        
        mainStackView.addArrangedSubview(conditionImageView)
        mainStackView.addArrangedSubview(tempStackView)
        
        tempStackView.addArrangedSubview(tempLabel)
        tempStackView.addArrangedSubview(tempTypeLabel)
        
        mainStackView.addArrangedSubview(cityLabel)
        mainStackView.addArrangedSubview(emptyView)
        
    }
    
    
    private func setupConstraints() {
        
        backgroundImageView.snp.makeConstraints { make in
//            make.top.leading.trailing.bottom.equalTo(view)
//            make.top.leading.trailing.bottom.equalToSuperview()
            make.edges.equalToSuperview()
        }

        mainStackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        headerStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        geoButton.snp.makeConstraints {
            $0.height.width.equalTo(40)
        }
        
        searchButton.snp.makeConstraints {
            $0.height.width.equalTo(40)
        }
        
        conditionImageView.snp.makeConstraints {
            $0.height.width.equalTo(120)
        }
        

//        let constraint: [NSLayoutConstraint] = [
//            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
//            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
//            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
//            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
//            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
//
//            headerStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
//
//            geoButton.heightAnchor.constraint(equalToConstant: 40),
//            geoButton.widthAnchor.constraint(equalToConstant: 40),
//
//            searchButton.heightAnchor.constraint(equalToConstant: 40),
//            searchButton.widthAnchor.constraint(equalToConstant: 40),
//
//            conditionImageView.heightAnchor.constraint(equalToConstant: 120),
//            conditionImageView.widthAnchor.constraint(equalToConstant: 120),
//
//        ]
//        NSLayoutConstraint.activate(constraint)
        
    }
}
