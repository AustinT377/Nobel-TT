//
//  LaureateTableViewCell.swift
//  Nobel TT
//
//  Created by Austin Turner on 10/22/20.
//

import UIKit

class LaureateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var bornYearLabel: UILabel!
    @IBOutlet weak var diedYearLabel: UILabel!
    @IBOutlet weak var bornCityLabel: UILabel!
    @IBOutlet weak var diedCityLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
