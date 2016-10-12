//
//  Favorite.swift
//  ESBondRealmSample
//
//  Created by 江上真人 on 2016/10/12.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift

class Favorite: NSObject {
    
    static func initializeObject(item: QiitaItemRealm) -> FavoriteRealm {
        let favorite = FavoriteRealm()
        favorite.id = item.id
        favorite.qiitaItem = item
        return favorite
    }
    
    static func getAll() -> Results<FavoriteRealm> {
        let realm = try! Realm()
        return realm.objects(FavoriteRealm.self).sorted("createdAt")
    }
    
    static func deleteByQiitaItemId(qiitaItemId: String?) {
        guard let itemId = qiitaItemId else {
            return
        }
        
        let realm = try! Realm()
        let qiitaItem = realm.objects(QiitaItemRealm.self).filter("id = \(itemId)").first
        deleteByQiitaItem(qiitaItem)
    }
    
    
    static func toggleByItemId(qiitaItemId: String?){
        guard let itemId = qiitaItemId else {
            return
        }

        let realm = try! Realm()
        let qiitaItem = realm.objects(QiitaItemRealm.self).filter("id = \(itemId)").first
        if let _ = qiitaItem?.favorite.first {
            deleteByQiitaItem(qiitaItem)
        } else {
            createByQiitaItem(qiitaItem)
        }
    }
    
    private static func deleteByQiitaItem(qiitaItem: QiitaItemRealm?) {
        guard let qI = qiitaItem else {
            return
        }
        
        let realm = try! Realm()
        if let favorite = qI.favorite.first {
            try! realm.write {
                realm.delete(favorite)
            }
        }
    }
    
    private static func createByQiitaItem(qiitaItem: QiitaItemRealm?){
        guard let qI = qiitaItem else {
            return
        }
        
        let realm = try! Realm()
        
        if qI.favorite.first == nil {
            let favorite = self.initializeObject(qI)
            try! realm.write {
                realm.add(favorite)
            }
        }
    }

}