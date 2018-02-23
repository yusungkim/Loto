//
//  LotteryTableViewController.swift
//  Loto
//
//  Created by KimYusung on 7/30/17.
//  Copyright © 2017 yusungkim. All rights reserved.
//

import UIKit

class LotteryTableViewController: UITableViewController {
    
    var lotteryURL: URL? {
        didSet {
            if lotteryURL != nil {
                loadLotteryInfo(from: lotteryURL!)
            }
        }
    }
    
    
    
    var lotteries: [Lottery] = []
    var isEnteredLotteryTable: Bool = false
    var whereAmI: String = ""
    var roundNo = String()
    var pickupDate = String()
    var numbers: [Int] = []
    var bonusNumber: Int = 0
    
    private func saveNinit() {
        
        if roundNo != "" {
            let lottery = Lottery(roundNo: roundNo, pickupDate: pickupDate, numbers: numbers, bonusNumber: bonusNumber)
            lotteries.append(lottery)
            
            roundNo = ""
            pickupDate = ""
            numbers = []
            bonusNumber = 0
        }
    }
    
    private func loadLotteryInfo(from url: URL) {
        // Loto6
        // https://www.mizuhobank.co.jp/takarakuji/loto/loto6/index.html
        // Back Numbers
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/index.html
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/lt6-201706.html
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/lt6-201706.html
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/lt6-201704.html
        // https://www.mizuhobank.co.jp/takarakuji/loto/backnumber/lt6-201612.html
        
        if let data = try? Data(contentsOf: url) {
            let doc = HTML(html: data, encoding: String.Encoding.utf8)
            
            // extract lotterydata from <th> and <td> tag.
            //<th colspan="6" class="alnCenter bgf7f7f7">第1189回</th>
            if let node = doc?.body?.xpath("//th | //td") {
                //if let node = doc?.body?.xpath("table[@class='typeTK']") {
                //print(node.first!.content!)
                //print(node.text)
                for str in node {
                    print("X\(String(describing: str.text))")
                    if let classValue = str["class"] {
                        //print("class = \(classValue)")
                        let catchedText = str.text ?? ""
                        switch classValue {
                        case "alnCenter bgf7f7f7": //第1189回
                            roundNo = catchedText
                        case "alnCenter":   //2017年7月6日"
                            pickupDate = catchedText
                        case "alnCenter extension": //08
                            numbers.append(Int(catchedText) ?? 0)
                        case "alnCenter extension green": //(03) bonus
                            let numberString = catchedText.replacingOccurrences(of: "\\D", with: "", options: .regularExpression, range: nil)
                            bonusNumber = Int(numberString) ?? 0
                        case "alnRight": // save and init
                            saveNinit()
                        default:
                            break
                        }
                    }
                }
            }
        }
        print(lotteries)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lotteryURL = URL(string: "https://www.mizuhobank.co.jp/takarakuji/loto/loto6/index.html")
        //print(lotteries)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lotteries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let lottery = lotteries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "lotteryTableViewCell", for: indexPath)
        if let lotteryTableViewCell = cell as? LotteryTableViewCell {
            lotteryTableViewCell.lottery = lottery
        }
        return cell
    }
}
