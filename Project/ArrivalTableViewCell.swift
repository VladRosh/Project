//
//  ArrivalTableViewCell.swift
//  Project
//
//  Created by VLAD on 4/13/16.
//  Copyright © 2016 Vlad. All rights reserved.
//

import UIKit

class ArrivalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
