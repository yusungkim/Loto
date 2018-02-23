//
//  Loto.swift
//  Loto
//
//  Created by KimYusung on 8/5/17.
//  Copyright © 2017 yusungkim. All rights reserved.
//

import Foundation

class Loto {
    
    var loto6s: [Loto6] = [] // 過去データも格納できるスタック
    
    private var roundNo: Int = 0// 回別 : 第1193回
    private var pickupDate: String = ""// 抽せん日 : 2017年7月20日
    private var numbers: [Int] = []// 本数字
    private var bonusNumber: Int = 0// ボーナス数字 : (28)
    
    public func getAllPreviousLoto() {
        // Loto6
        // https://www.mizuhobank.co.jp/takarakuji/loto/loto6/index.html
        
        // Back Numbers
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/index.html
        
        // Backnumber 2017. 01 ~
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/lt6-201706.html
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/lt6-201706.html
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/lt6-201704.html
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/lt6-201612.html
        
        // Back number 1 ~ 1092 round
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/loto60001.html
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/loto60021.html
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/loto61081.html
        
        var backnumber = 1
        while backnumber <= 21{ //1081 {
            
            var backnumberString: String
            
            // 0001, 0021, ... ,0081
            if backnumber < 100 {
                backnumberString = "00\(backnumber)"
                
                // 0101, 0121, ... ,0181, ... ,0981
            } else if backnumber < 1000 {
                backnumberString = "0\(backnumber)"
                
                // 1001, 1021, ... ,1081
            } else {
                backnumberString = "\(backnumber)"
            }
            
            print(backnumberString)
            
            let urlString = "https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/loto6\(backnumberString).html"
            
            if let url = URL(string: urlString) {
                getPreviousLoto(fromBacknumber: url)
            } else {
                print("URL ERROR in Loto.getAllPreviousLoto()")
            }
            
            // for next loading
            backnumber += 20
        }
    }
    
    private func getPreviousLoto(fromBacknumber url: URL) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                let doc = HTML(html: data, encoding: String.Encoding.utf8)
                
                // extract data in <th> and <td> tag.
                if let node = doc?.body?.xpath("//th | //td") {
                    //if let node = doc?.body?.xpath("table[@class='typeTK']") {
                    //print(node.first!.content!)
                    //print(node.string ?? "NoData")
                    for string in node {
                        print("StringInNode: \(String(describing: string.text))")
                        
                        let classValue = string["class"] ?? "MaybeNumbers"
                        let catchedText = string.text ?? "NoText"
                        switch classValue {
                        case "bgf7f7f7": //第1189回
                            let numberString =
                                catchedText.replacingOccurrences(
                                    of: "\\D",
                                    with: "",
                                    options: .regularExpression,
                                    range: nil)
                            self?.roundNo = Int(numberString) ?? 0
                        case "alnRight":   //2017年7月6日"
                            self?.pickupDate = catchedText
                        case "MaybeNumbers": //08
                            if self?.roundNo != 0, self?.bonusNumber == 0 { // if roundNo is set. & roundNumber is not set.
                                self?.numbers.append(Int(catchedText) ?? 0)
                            }
                        case "alnCenter green": //03 bonus
                            let numberString =
                                catchedText.replacingOccurrences(
                                    of: "\\D",
                                    with: "",
                                    options: .regularExpression,
                                    range: nil)
                            self?.bonusNumber = Int(numberString) ?? 0
                            
                            // save and init
                            self?.saveAndInitForNextLoading()
                        default:
                            break
                        }
                    }
                }
            }
        }
        print(loto6s)
    }
    
    private func saveAndInitForNextLoading() {
        
        if roundNo != 0 {
            let loto6 = Loto6(roundNo: roundNo, pickupDate: pickupDate, numbers: numbers, bonusNumber: bonusNumber)
            
            loto6s.append(loto6)
            
            // init for loading next loto6
            roundNo = 0
            pickupDate = ""
            numbers = []
            bonusNumber = 0
        }
    }
}
