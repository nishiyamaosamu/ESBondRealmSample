//
//  News.swift
//  ESBondRealmSample
//
//  Created by Osamu Nishiyama on 2016/09/26.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift

// APIでの返り値はQiitaItemに入れるので、付随情報はこのテーブルにいれる
class NewsRealm: Object {
    dynamic var id = ""
    dynamic var qiitaItem : QiitaItemRealm?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}