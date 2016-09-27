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

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bnd_bag.dispose()
    }    
}
