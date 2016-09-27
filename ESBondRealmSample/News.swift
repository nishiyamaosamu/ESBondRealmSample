//
//  News.swift
//  ESBondRealmSample
//
//  Created by Osamu Nishiyama on 2016/09/26.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift

class News : Object {
    dynamic var id = ""
    dynamic var qiitaItem : QiitaItem?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    

}