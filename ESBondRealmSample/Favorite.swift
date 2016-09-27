//
//  Favorite.swift
//  ESBondRealmSample
//
//  Created by Osamu Nishiyama on 2016/09/23.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift

class Favorite: Object {
    dynamic var id = ""
    dynamic var qiitaItem : QiitaItem?
    dynamic var createdAt = NSDate()
    
    override static func primaryKey() -> String? {
        return "id"
    }

}