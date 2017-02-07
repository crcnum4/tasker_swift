//
//  MyTableCell.swift
//  tasker
//
//  Created by Cliff Choiniere on 1/26/17.
//  Copyright © 2017 Cliff Choiniere. All rights reserved.
//

import UIKit

class MyTableCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var taskID = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
