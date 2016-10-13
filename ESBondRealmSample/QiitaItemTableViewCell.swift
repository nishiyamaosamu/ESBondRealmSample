//
//  QiitaItemTableViewCell.swift
//  ESBondRealmSample
//
//  Created by Osamu Nishiyama on 2016/09/26.
//  Copyright © 2016年 ever sense. All rights reserved.
//

import UIKit

class QiitaItemTableViewCell: UITableViewCell {
 
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var favoritedMark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // ここでは、qiitaItemTableViewCellVMのアトリビュートが変化したことを検知して、cellの表示に反映する
    func setCell(item: QiitaItemTableViewCellVM){
        item.fetchImageIfNeeded()

        item.title.bindTo(title!.bnd_text).disposeIn(bnd_bag)
        item.userId.bindTo(userId!.bnd_text).disposeIn(bnd_bag)
        item.isNotFavorited.bindTo(favoritedMark.bnd_hidden).disposeIn(bnd_bag)
        item.userImage.bindTo(userImageView.bnd_image).disposeIn(bnd_bag)
    }
    
    // 使い終わったら監視ははずす
    override func prepareForReuse() {
        super.prepareForReuse()
        bnd_bag.dispose()
    }
}
