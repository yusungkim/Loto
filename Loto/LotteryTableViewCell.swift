//
//  LotteryTableViewCell.swift
//  Loto
//
//  Created by KimYusung on 7/30/17.
//  Copyright © 2017 yusungkim. All rights reserved.
//

import UIKit

class LotteryTableViewCell: UITableViewCell {

    @IBOutlet weak var roundNoLabel: UILabel!
    @IBOutlet weak var pickupDateLabel: UILabel!
    @IBOutlet weak var bonusNumberLabel: UILabel!
    @IBOutlet weak var numbersLabel: UILabel!
    
    var lottery: Lottery? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        roundNoLabel.text = lottery?.roundNo
        pickupDateLabel.text = lottery?.pickupDate
        bonusNumberLabel.text = lottery?.bonusNumber.description
        numbersLabel.text = lottery?.numbers.description
    }
}
