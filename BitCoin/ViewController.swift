//
//  ViewController.swift
//  BitCoin
//
//  Created by Анастасия Рыбакова on 12.09.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
// MARK: - User Interface
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.text = "BitCoin"
        label.font = .systemFont(ofSize: 50, weight: .thin)
        label.textColor = UIColor(named: "Title Color")
        return label
    }()
    
    private lazy var coinView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiaryLabel
        view.layer.cornerRadius = 40
        return view
    }()
    
    private lazy var coinStackView: UIStackView = {
        let stack = UIStackView()
//        stack.backgroundColor = .purple.withAlphaComponent(0.5)
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        stack.alignment = .center
        return stack
    }()
    
    private lazy var bitCionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bitcoinsign.circle.fill")
        imageView.tintColor = UIColor(named: "Icon Color")
        return imageView
    }()
    
    private lazy var bitCoinLabel: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.textColor = .white
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "USD"
        label.textColor = .white
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var currencyPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.contentMode = .scaleAspectFill
//        picker.backgroundColor = .purple.withAlphaComponent(0.5)
        return picker
    }()
    
    
    // 1.1 -> 1.2
    // Создаем объект coinManager, через который будем делать запрос API
    private var coinManager = CoinManager()
    
    
// MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraints()
        self.setupDelegates()
        
        
    }
    
// MARK: - Private methodes
    
    // 1.2 -> 1.3
    // устанавливаем VC делегатом и источником данных у currencyPicker
    private func setupDelegates() {
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        // 3.1 -> 3.2
        // Устанавливаем VC делегатом CoinManager, чтобы она мог выполнять 2 метода
        coinManager.delegate = self
    }

    private func setupView() {
        view.backgroundColor = UIColor(named: "Background Color")
        view.addSubview(topLabel)
        view.addSubview(currencyPicker)
        
        view.addSubview(coinView)
        coinView.addSubview(coinStackView)
        
        coinStackView.addArrangedSubview(bitCionImageView)
        coinStackView.addArrangedSubview(bitCoinLabel)
        coinStackView.addArrangedSubview(currencyLabel)
    }
    
}

// MARK: - CoinManagerDelegate

// 3.2 -> 3.3
// Реализация протокола CoinManagerDelegate, чтобы VC выполнянл необходимые методы по обновлению экрана

extension ViewController: CoinManagerProtocol {
    
    // 3.3 -> 3.4
    // Обновляем UI на главном потоке
    func didUpdateCoinValueUI(_ coinManager: CoinManager, price: Double) {
        let priceString = String(format: "%.2f", price)
        print("Передала цену битконта во вьюконторллер", priceString)
        
        DispatchQueue.main.async {
            self.bitCoinLabel.text = priceString.addSpace()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}


// MARK: - delegates for UIPicker

// 1.3 -> 1.4
// Подписываем VC под релизацию необходимого протокола для UIPicker (источник данных)
extension ViewController: UIPickerViewDataSource {
    
    // Количество столбцов
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Количество строк
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

// 1.4 -> 1.5
// делегат обработки взаимодействия c пикером
extension ViewController: UIPickerViewDelegate {
    
    // Устанавливаем заголовок для строки пикера
    // Когда загрузится пикет, он запросит у делегата загоkовок строки и вызовет этот метод по одному разу для каждой строки (первая строка = 0
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    // 1.5 -> 1.6
    // Метод срабатывает при выборе строки (=значение) пикера
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Обновляем значение лейбла с названием валюты
        let selectedCurrency = coinManager.currencyArray[row]
        print("You selected currency \(selectedCurrency)")
        currencyLabel.text = selectedCurrency
        
        // Вызываем запрос API в сеть, чтобы получить цену монеты в валюте
        coinManager.getCoinPrice(for: selectedCurrency)
        
    }
}


// MARK: - extension set up constraints

extension ViewController {
    
    private func setupConstraints() {
        
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.centerX.equalToSuperview()
        }

        coinView.snp.makeConstraints {
            $0.top.equalTo(topLabel.snp_bottomMargin).offset(25)
            $0.centerX.equalToSuperview()
        }
        
        coinStackView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.trailing.equalTo(coinView.snp_trailingMargin).inset(10)
        }
        
        bitCionImageView.snp.makeConstraints {
            $0.height.width.equalTo(80)
        }
        
    
        currencyPicker.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(216)
        }
        
  
    }
    
}
