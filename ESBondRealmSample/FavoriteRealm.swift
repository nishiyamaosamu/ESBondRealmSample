//
//  Favorite.swift
//  ESBondRealmSample
//
//  Created by Osamu Nishiyama on 2016/09/23.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteRealm: Object {
    dynamic var id = ""
    dynamic var qiitaItem : QiitaItemRealm?
    dynamic var createdAt = NSDate()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}