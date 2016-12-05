//
//  Article.swift
//  ESBondRealmSample
//
//  Created by Osamu Nishiyama on 2016/09/23.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift

class QiitaItemRealm: Object {
    dynamic var id = ""
    dynamic var title = ""
    dynamic var url  = ""
    dynamic var created_at = ""
    dynamic var user : QiitaUserRealm?
    let favorite = LinkingObjects(fromType: FavoriteRealm.self, property: "qiitaItem")
    
    override static func primaryKey() -> String? {
        return "id"
    }
}