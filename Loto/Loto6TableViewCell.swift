//
//  Loto6TableViewCell.swift
//  Loto
//
//  Created by KimYusung on 8/5/17.
//  Copyright © 2017 yusungkim. All rights reserved.
//

import UIKit

class Loto6TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var loto6: Loto6? {
        didSet {
            roundNo.text = loto6?.roundNo.description
            pickupDate.text = loto6?.pickupDate.description
            numbers.text = loto6?.numbers.description
            bonusNumber.text = loto6?.bonusNumber.description
        }
    }
    
    @IBOutlet weak var roundNo: UILabel!
    @IBOutlet weak var pickupDate: UILabel!
    @IBOutlet weak var numbers: UILabel!
    @IBOutlet weak var bonusNumber: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
