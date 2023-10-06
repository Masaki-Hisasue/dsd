//
//  Breeds.swift
//  DogViewApp_School
//
//  Created by user on 2023/09/12.
//

import UIKit

class BreedsData {

    let dogBreeds: String
    let subBreeds: [String]
    
    init (dobBreeds: String, subBreeds:[String]) {
        self.dogBreeds = dobBreeds
        self.subBreeds = subBreeds
    }
    
    func hasSubBreeds() -> Bool {
        if self.subBreeds.count == 0 {
            return false
        } else {
            return true
        }
    }
    
}
