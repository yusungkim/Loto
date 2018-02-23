//
//  Lottery.swift
//  Loto
//
//  Created by KimYusung on 7/30/17.
//  Copyright © 2017 yusungkim. All rights reserved.
//

import Foundation

struct Lottery {
    var roundNo: String = ""// 回別 : 第1193回
    var pickupDate: String = ""// 抽せん日 : 2017年7月20日
    
    var numbers: [Int] = []// 本数字
    var bonusNumber: Int = 0// ボーナス数字 : (28)
    
    // １等 : 該当なし : 該当なし
    // 2等 : 5口 : 15,062,800円
    //var winners = [String:String]()
}
