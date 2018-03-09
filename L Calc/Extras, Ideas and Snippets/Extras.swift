//
//  Extras.swift
//  L Calc
//
//  Created by Igor Malyarov on 22.01.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

// COMMENTED IN CODE AND MOVED HERE


//MARK: - TODO Scale Font
//        if let font = UIFont(name: "Trebuchet MS", size: 17) {
//            monthlyPaymentCommentLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
//        }
//
//        if let font = UIFont(name: "Trebuchet MS", size: 62) {
//            monthlyPayment.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: font)
//        }




//MARK: - is it a better way to call user defaults for string using enum?
//let t = defaults.string(forKey: "InterestType") ?? "Annuity"
//type = (InterestType(rawValue: t)?.rawValue)!



//MARK: - notifications and observers
//NotificationCenter.default.addObserver(
//    forName: .decimalsUsageChanged,
//    object: .none,
//    queue: OperationQueue.main) { [weak self] _ in
//        self?.changeNumFormat()
//        self?.tableView.reloadData()
//}
//
//NotificationCenter.default.addObserver(
//    forName: .loanChanged,
//    object: .none,
//    queue: OperationQueue.main) { [weak self] _ in
//        self?.amount = UserDefaults.standard.double(
//            forKey: "Principal")
//        self?.rate = UserDefaults.standard.double(
//            forKey: "Rate")
//        self?.term = UserDefaults.standard.double(
//            forKey: "Term")
//        print(self?.term as Any)
//        // FIXME: forKey: "AnnuitySegment"
//        // ????
//
//        self?.tableView.reloadData()
//}


