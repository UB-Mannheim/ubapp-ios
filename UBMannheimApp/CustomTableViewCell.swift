//
//  CustomTableViewCell.swift
//  SelfSizingDemo
//
//  Created by Simon Ng on 4/9/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//
//  Last modified on 23.03.2016 by Alexander Wagner
//
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel:UILabel!
    @IBOutlet var addressLabel:UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
