//
//  QiitaUser.swift
//  ESBondRealmSample
//
//  Created by Osamu Nishiyama on 2016/09/23.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift

class QiitaUser: Object {
    dynamic var id = ""
    dynamic var profile_image_url  = "https://qiita-image-store.s3.amazonaws.com/0/88/profile-images/1473684075"
    
    override static func primaryKey() -> String? {
        return "id"
    }

}