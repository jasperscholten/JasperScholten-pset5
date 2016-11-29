//
//  todoTableViewCell.swift
//  JasperScholten-pset5
//
//  Created by Jasper Scholten on 29-11-16.
//  Copyright © 2016 Jasper Scholten. All rights reserved.
//

import UIKit

class todoTableViewCell: UITableViewCell {

    @IBOutlet weak var todoItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
