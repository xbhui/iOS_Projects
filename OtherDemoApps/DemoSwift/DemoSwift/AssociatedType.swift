//
//  AssociatedType.swift
//  DemoSwift
//
//  Created by huixiubao on 8/14/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

import Foundation

protocol Food{
}

protocol Animal {
    func eat(food: Food)
}

class Grass: Food {
    
}

protocol AnFood {
    associatedtype MyFood:Food
    func eat(food:MyFood)
}

//protocol EatFood {
//    func eat(food: MyFood)
//}
//func eat(food: MyFood) {
//
//}

class Cow: Animal {
    func eat(food: Food) {
        
    }
}
