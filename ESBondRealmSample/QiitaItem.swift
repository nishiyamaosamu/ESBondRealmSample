//
//  QiitaItem.swift
//  ESBondRealmSample
//
//  Created by 江上真人 on 2016/10/12.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift

class QiitaItem: NSObject {
    static func initializeObject(id: String, title: String, url: String) -> QiitaItemRealm{
        let item = QiitaItemRealm()
        item.id = id
        item.title = title
        item.url = url
        return item;
    }
}