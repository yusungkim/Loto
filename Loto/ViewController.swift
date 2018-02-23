//
//  ViewController.swift
//  Loto
//
//  Created by KimYusung on 7/18/17.
//  Copyright © 2017 yusungkim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    // final random numbers are stored in this.
    private var result: [Int]? {
        didSet {
            display?.text = result?.description
        }
    }
    
    // for internal clac.
    private var randomNumbers: [Int]?
    
    @IBAction func touchLotoButton(_ sender: UIButton) {
        pickLoto(type: sender.currentTitle)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationController = segue.destination.contents
        
        if let lotteryTableViewController = destinationController as? LotteryTableViewController {
            lotteryTableViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
        if let loto6TableViewController = destinationController as? Loto6TableViewController {
            loto6TableViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
        if segue.identifier == "previousHit" {
            
        } else if segue.identifier == "allLoto6" {
            
        }
    }
    
    private func pickLoto(type: String?) {
        // clear previous calc. & result
        randomNumbers = nil
        result = nil
        
        // pick new randomNumbers
        if let lotoType = type {
            switch lotoType {
            case "Loto6":
                pickRandomNumbersRecursivly(howMany: Loto.loto6NumberOfPicks,
                                            from: Loto.loto6NumberOfFrom,
                                            to: Loto.loto6NumberOfTo)
                
            case "Loto7":
                pickRandomNumbersRecursivly(howMany: Loto.loto7NumberOfPicks,
                                            from: Loto.loto7NumberOfFrom,
                                            to: Loto.loto7NumberOfTo)
            default:
                break
            }
        }
        
        // set result to display
        result = randomNumbers?.sorted()
    }
    
    private struct Loto {
        static let loto6NumberOfPicks = 6
        static let loto6NumberOfFrom = 1
        static let loto6NumberOfTo = 43
        
        static let loto7NumberOfPicks = 7
        static let loto7NumberOfFrom = 1
        static let loto7NumberOfTo = 37
        
        static let probabilityAdjustmentForCalendricNumbers = 0.1 // reduce pick ratio by 10% for calendricNumber (1~31:days, 1~12:months)
    }
    
    //　重複あり
    /*
     private func pickRandomNumbers(howMany repeats: Int, from min: Int, to max: Int) -> [Int]? {
     var numbers = [Int]()
     
     if min <= max, repeats > 0 {
     for _ in (0..<repeats) {
     let random = randomNumber(between: min, and: max)
     numbers.append(random)
     }
     return numbers
     }
     return nil
     }
     */
    
    // 再帰を使って、重複なしの数選び
    private func pickRandomNumbersRecursivly(howMany repeats: Int, from min: Int, to max: Int) {
        
        // stop conditions
        if repeats == 0 || max <= min {
            return
        }
        
        //let random = randomNumber(between: min, and: max)
        let random = randomNumber(between: min,
                                  and: max,
                                  withCalendricAdjustment: true)
        
        // creat randomNumbers array
        if randomNumbers == nil {
            randomNumbers = [random]
            pickRandomNumbersRecursivly(howMany: repeats-1, from: min, to: max)
        
        // add new random number
        } else {
            
            // if there is same number already, pick another random number
            if randomNumbers!.contains(random) {
                pickRandomNumbersRecursivly(howMany: repeats, from: min, to: max)
            
            // add new random number
            } else {
                randomNumbers!.append(random)
                pickRandomNumbersRecursivly(howMany: repeats-1, from: min, to: max)
            }
        }
    }
    
    private func randomNumber(between min: Int, and max: Int) -> Int {
        let range = max - min + 1
        
        //print("\(arc4random()) \(RAND_MAX) \(Double(arc4random()) / 0xFFFFFFFF)")
        
        return Int(arc4random_uniform(UInt32(range))) + min
        
    }
    
    private func randomNumber(between min: Int, and max: Int, withCalendricAdjustment: Bool) -> Int {
        
        if withCalendricAdjustment == false {
            return randomNumber(between: min, and: max)
        }
        
        let sizeOfDays = 31
        let sizeOfMonths = 12
        let sizeOfPickNumberRange = max - min + 1
        
        // ランダム数字の範囲が、カレンダーの日数31より小さい場合は、均一なランダム抽出を行う
        if max <= sizeOfDays || max <= sizeOfMonths {
            print ("wrong size of max")
            return randomNumber(between: min, and: max)
        }
        
        // adjust probability
        // 決められたバイアスを与える。カレンダー上の数字は、誕生日等により多くの人がより多く選択するようになる。そのため、期待値が低くなるので、カレンダー上の数字以外の数字をより選ぶようにバイアスを与える
        // pDayNumbers + pNonCalendric = 1.0
        // probability of 13~31
        var pDayNumbers = Double(sizeOfDays) / Double(sizeOfPickNumberRange)
        pDayNumbers *= (1.0-Loto.probabilityAdjustmentForCalendricNumbers) // adjust
        
        // probability of 1~12 against pDayNumbers
        var pMonthNumbers = pDayNumbers * Double(sizeOfMonths) / Double(sizeOfDays)
        pMonthNumbers *= (1.0-Loto.probabilityAdjustmentForCalendricNumbers) // adjust
        
        
        
        /*
        // probability of 32~max
        let pNonCalendric = 1.0 - pDayNumbers
        let sizeOfNonCalendric = max - sizeOfDays
        
        let p1S = pMonthNumbers / Double(sizeOfMonths)
        let p2S = (pDayNumbers - pMonthNumbers) / Double(sizeOfDays - sizeOfMonths)
        let p3S = pNonCalendric / Double(sizeOfNonCalendric)
        print ("p1s: \(p1S), p2S: \(p2S), p3S:\(p3S)")
        // check calc.
        print ("pMonth:\(pMonthNumbers) pDays:\(pDayNumbers) pNonCalendric:\(pNonCalendric)")
        print ("pM+pD+pNC=\(pMonthNumbers + pDayNumbers + pNonCalendric)")
        print ("pD+pNC=\(pDayNumbers + pNonCalendric)") */
        
        
        // select whether pick calendric number or nonCalendric number
        // 0..<1の範囲でランダム数字を選び、領域の境界の確率と比べ、
        // どの領域から選ぶかを決め、
        // その領域からランダム数値を抽出
        let numberFieldChoice = Double(arc4random()) / 0xFFFFFFFF // (0..<1)
        if numberFieldChoice < pMonthNumbers {
            print ("criteria: \(numberFieldChoice), Month number(1-12) selected")
            return randomNumber(between: min, and: sizeOfMonths)
        } else if numberFieldChoice < pDayNumbers {
            print ("criteria: \(numberFieldChoice), Day number(13-31) selected")
            return randomNumber(between: sizeOfMonths+1, and: sizeOfDays)
        } else {
            print ("criteria: \(numberFieldChoice), Non-calendric number(32-\(max)) selected")
            return randomNumber(between: sizeOfDays+1, and: max)
        }
    }
}

extension UIViewController {
    var contents: UIViewController? {
        get {
            if let navcon = self as? UINavigationController {
                return navcon.visibleViewController
            } else {
                return self
            }
        }
    }
}


