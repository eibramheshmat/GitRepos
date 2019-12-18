//
//  RepoTableViewCell.swift
//  GitRepo
//
//  Created by Ibram on 12/13/19.
//  Copyright © 2019 Ibram. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDescrip: UILabel!
    @IBOutlet weak var repoOwner: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.borderWidth = 1
        mainView.layer.cornerRadius = 10
        mainView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
