//
//  String+extension.swift
//  BitCoin
//
//  Created by Анастасия Рыбакова on 14.09.2023.
//

import Foundation

extension String {
    
    func addSpace() -> String {
        let array = self.components(separatedBy: ".")
        var firstPart = array[0]
        let secondPart = array[1]
        
        let numberOfSpace = firstPart.count / 3
        
        for i in 0..<numberOfSpace {
            let offSet = -3 * (numberOfSpace - i)
            firstPart.insert(" ", at: firstPart.index(firstPart.endIndex, offsetBy: offSet))
        }
        
        return "\(firstPart).\(secondPart)"
    }
}
