//
//  QiitaUser.swift
//  ESBondRealmSample
//
//  Created by 江上真人 on 2016/10/12.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import Foundation
import RealmSwift

class QiitaUser: NSObject {
    static func initializeObject(id: String, profile_image_url: String) -> QiitaUserRealm{
        let user = QiitaUserRealm()
        user.id = id
        user.profile_image_url = profile_image_url
        return user;
    }
}