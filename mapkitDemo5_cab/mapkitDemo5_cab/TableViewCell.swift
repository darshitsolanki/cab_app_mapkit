//
//  TableViewCell.swift
//  mapkitDemo3_localsearch_completor
//
//  Created by Third Rock Techkno on 18/03/20.
//  Copyright © 2020 Third Rock Techkno. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
}
