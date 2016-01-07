//
//  User.swift
//  TheWalkingDead
//
//  Created by User on 07/01/16.
//  Copyright © 2016 Mario Baumgartner. All rights reserved.
//

import Foundation

class User {
    var id = Int()
    var physicalActivityRating = Int()
    var stepLength = Int()
    var age = Int()
    var name = String()
    var weight = Int()
    var height = Int()
    var sex = Int()
    var session = String()
    
    init(id: Int, physicalActivityRating: Int, stepLength: Int, age: Int, name: String, weight: Int, height: Int, sex: Int, session: String) {
        self.id = id
        self.physicalActivityRating = physicalActivityRating
        self.stepLength = stepLength
        self.age = age
        self.name = name
        self.weight = weight
        self.height = height
        self.sex = sex
        self.session = session
    }
}