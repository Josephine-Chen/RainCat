//
//  FoodSprite.swift
//  RainCat
//
//  Created by Josephine Chen on 1/7/18.
//  Copyright © 2018 Thirteen23. All rights reserved.
//

import SpriteKit

public class FoodSprite : SKSpriteNode {
    public static func newInstance() -> FoodSprite {
        let foodDish = FoodSprite(imageNamed: "food_dish")
        
        foodDish.physicsBody = SKPhysicsBody(rectangleOf: foodDish.size)
        foodDish.physicsBody?.categoryBitMask = FoodCategory
        foodDish.physicsBody?.contactTestBitMask = WorldCategory | RainDropCategory | CatCategory
        foodDish.zPosition = 5
        //Same zPosition as cat so they never overlap
        
        return foodDish
    }
}
