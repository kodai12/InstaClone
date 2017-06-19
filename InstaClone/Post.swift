//
//  Post.swift
//  InstaClone
//
//  Created by 迫地康大 on 2017/06/16.
//  Copyright © 2017年 sakochi. All rights reserved.
//

import Foundation

struct Post {
    let userName: String
    let profileImageURL: String
    let postedImageURL: String
    let comment: String
    var userDidLike: Bool
    var numberOfDidLikes: Int
    
    init(userName:String, profileImageURL:String, postedImageURL:String, comment:String, userDidLike:Bool, numberOfDidLikes:Int) {
        self.userName = userName
        self.profileImageURL = profileImageURL
        self.postedImageURL = postedImageURL
        self.comment = comment
        self.userDidLike = userDidLike
        self.numberOfDidLikes = numberOfDidLikes
    }
}
