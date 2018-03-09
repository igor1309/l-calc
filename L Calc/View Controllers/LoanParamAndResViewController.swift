//
//  ViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 26.12.2017.
//  Copyright © 2017 Igor Malyarov. All rights reserved.
//

import UIKit

class LoanParamAndResViewController: UIViewController {
    
    //MARK: - @IBOutlets
    // Trebuchet MS 56.0
    
    @IBOutlet weak var monthlyPayment: UILabel!
    @IBOutlet weak var monthlyPaymentCommentLabel: UILabel!
    @IBOutlet weak var totalInterest: UILabel!
    @IBOutlet weak var totalPayment: UILabel!
    @IBOutlet weak var annuitySegment: UISegmentedControl!
    @IBOutlet weak var loanView: UIView!
    
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var sumSubLabel: UILabel!
    @IBOutlet weak var sumStack: UIStackView!

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateSubLabel: UILabel!
    @IBOutlet weak var rateStack: UIStackView!
    
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var termSubLabel: UILabel!
    @IBOutlet weak var termStack: UIStackView!
    
    //MARK: - vars
    //    var loc = Locale.current
    var loc = Locale(identifier: "en_US")
    
    var loan = Loan()
    
    // FIXME: должно ли это быть здесь или переменные должны быть спрятаны в методы?
    var previousX: CGPoint!
    var ratePreviousX: CGPoint!
    var termPreviousX: CGPoint!
    
    
    //MARK: - prepare Feedback Generators
    let change = UISelectionFeedbackGenerator()
    let impact = UIImpactFeedbackGenerator()

    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            forName: .outOfRange,
            object: .none,
            queue: OperationQueue.main) { [weak self] _ in
                self?.outOfRangeFeedback()
        }
        
        showLoanData()
        
    }
    
    func outOfRangeFeedback() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.warning)
    }
    
    func showLoanData() {
        sumLabel.text = numberAsNiceString(loan.amount)
        rateLabel.text = percentageAsNiceString(loan.rate)
        termLabel.text = numberAsNiceString(loan.term)
        termSubLabel.text = termSubLabelText(for: loan.term)
        
        monthlyPayment.text = String(format: "%.0f",
                                     locale: loc,
                                     loan.monthlyPayment)
        totalInterest.text = String(format: "%.0f",
                                    locale: loc,
                                    loan.totalInterest)
        totalPayment.text = String(format: "%.0f",
                                   locale: loc,
                                   loan.totalPayments)
        
        if loan.type == .fixedPayment {
            annuitySegment.selectedSegmentIndex = 1
        } else {
            annuitySegment.selectedSegmentIndex = 0
        }
        
        //  provide haptic feedback
        change.selectionChanged()
    }
    

    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if let destinationViewController = segue.destination as? PaymentsTableViewController {
//            destinationViewController.loan = loan
            destinationViewController.payments =
                Payments(for: loan)
        }
    }
    
    //MARK: - @IBActions
    @IBAction func annuitySegmentChanged(
        _ sender: UISegmentedControl) {

        if annuitySegment.selectedSegmentIndex == 0 {
            loan.type = .interestOnly
        } else {
            loan.type = .fixedPayment
        }
        
        showLoanData()
    }
    
    //FIXME: use this for new Show Payment Schedule button!!
//    @IBAction func showGraphButtonTouched(_ sender: UIButton) {
////        notification.notificationOccurred(.error)
//        impact.impactOccurred()
//    }

    //MARK: - changing label values by panning gestures
    @IBAction func panDetected1(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        //  Pan Gesture Recognizer with 1 finger
        changeValueByPan(gestureRecognizer, with: 1)
    }
    
    @IBAction func panDetected2(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        //  Pan Gesture Recognizer with 2 fingers
        changeValueByPan(gestureRecognizer, with: 2)
    }
    
    func changeValueByPan(
        _ gestureRecognizer: UIPanGestureRecognizer,
        with touches: Int) {
        
        // https://stackoverflow.com/questions/25503537/swift-uigesturerecogniser-follow-finger
        // https://github.com/codepath/ios_guides/wiki/Using-Gesture-Recognizers
        
        var threshold = CGFloat(3)
        var normalLabelColor: UIColor = .iron
        
        switch gestureRecognizer.state {

        case .began:
            previousX = .zero
            normalLabelColor = sumLabel.textColor
            sumLabel.textColor = .orange
            sumSubLabel.textColor = .orange

        case .changed:
            let x = gestureRecognizer.translation(in: self.view).x
            let distanceX = x - previousX.x
            
            // для снижения скорости изменения берется значение > 0
            // если пан двумя пальцами, то скорость выше, если одним,
            // то чувствительность снижаем, повышая threshold
            if touches == 1 {
                threshold = CGFloat(3)
            } else if touches == 2 {
                threshold = CGFloat(0)
            }
            
            if abs(distanceX) > threshold {
                
                if distanceX > 0 {
                    loan.amount = stepUp(loan.amount)
                } else if distanceX < 0 {
                    loan.amount = stepDown(loan.amount)
                }
                
                previousX.x = x
                
                showLoanData()
            }
        
        case .ended:
            change.selectionChanged()
            sumLabel.textColor = normalLabelColor
            sumSubLabel.textColor = normalLabelColor

        default:
            print("smth else")
        }
    }

    
    @IBAction func ratePanDetected(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        
        var normalLabelColor: UIColor = .iron
        
        switch gestureRecognizer.state {
    
        case .began:
            ratePreviousX = .zero
            normalLabelColor = rateLabel.textColor
            rateLabel.textColor = .orange
            rateSubLabel.textColor = .orange

        case .changed:
            let x = gestureRecognizer.translation(in: self.view).x
            let distanceX = x - ratePreviousX.x
            // для снижения скорости изменения берется значение > 0
            let threshold = CGFloat(4)
            if abs(distanceX) > threshold {
                
                if distanceX > 0 {
                    loan.rate = rateUp(loan.rate)
                } else if distanceX < 0 {
                    loan.rate = rateDown(loan.rate)
                }
                
                ratePreviousX.x = x
                
                showLoanData()
            }
      
        case .ended:
            change.selectionChanged()
            rateLabel.textColor = normalLabelColor
            rateSubLabel.textColor = normalLabelColor

        default:
            print("smth else")
        }
    }
    
    @IBAction func termPanDetected(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        
        var normalLabelColor: UIColor = .iron

        switch gestureRecognizer.state {
        case .began:
            termPreviousX = .zero
            normalLabelColor = termLabel.textColor
            termLabel.textColor = .orange
            termSubLabel.textColor = .orange

        case .changed:
            let x = gestureRecognizer.translation(in: self.view).x
            let distanceX = x - termPreviousX.x
            // для снижения скорости изменения берется значение > 0
            let threshold = CGFloat(7)
            if abs(distanceX) > threshold {
                
                if distanceX > 0 {
                    loan.term += 1
                } else if distanceX < 0 {
                    if loan.term > 1 {
                        loan.term -= 1
                    }
                }
                termLabel.text = String(format: "%.0f", loan.term)
                UserDefaults.standard.set(loan.term, forKey: "Term")
                
                termPreviousX.x = x
                
                showLoanData()
            }
            
        case .ended:
            change.selectionChanged()
            termLabel.textColor = normalLabelColor
            termSubLabel.textColor = normalLabelColor

        default:
            print("smth else")
        }
    }
    

    func stepUp(_ number: Double) -> Double {
        
        // FIXME:
        // вставить код проверки? is number = nil?
        // а нужен ли Double? Может достаточно Int?
        
        // take 2 leftmost digits of number before decimal as a number and increase it
        // https://en.wikipedia.org/wiki/Order_of_magnitude
        
        let max = Double(truncating: pow(10, 11) as NSNumber)
        if number > max {
            //MARK: выдать предупреждение, что это предельное значение(?)
            return number
        } else {
            let orderOfMagnitude = String(Int(number)).count - 1
            let magnitude = Double(truncating: pow(10, orderOfMagnitude) as NSNumber)
            var approx = (number / magnitude + 0.055) * 10
            approx = approx.rounded()
            approx = approx * magnitude / 10
            return approx
        }
    }
    
    func stepDown(_ number: Double) -> Double {
        
        // вставить код проверки? is number = nil?
        // а нужен ли Double? Может достаточно Int?
        
        // take 2 leftmost digits of number before decimal as a number and increase it
        // https://en.wikipedia.org/wiki/Order_of_magnitude
        if number < 101 {
            //MARK: выдать предупреждение, что это предельное значение(?)
            return number
        } else {
            let orderOfMagnitude = String(Int(number)).count - 1
            let magnitude = Double(truncating: pow(10, orderOfMagnitude) as NSNumber)
            var approx = (number / magnitude - 0.055) * 10
            approx = approx.rounded()
            approx = approx * magnitude / 10
            return approx
        }
    }
    
    func rateUp(_ number: Double) -> Double {
        
        let max = 199.0
        if number > max {
            //MARK: выдать предупреждение, что это предельное значение(?)
            return number
        } else {
            let orderOfMagnitude = String(Int(number)).count - 1
            let magnitude = Double(truncating: pow(10, orderOfMagnitude) as NSNumber)
            var approx = (number / magnitude + 0.0055) * 100
            approx = approx.rounded()
            approx = approx * magnitude / 100
            return approx
        }
    }
    
    func rateDown(_ number: Double) -> Double {
        
        if number < 0.0200 {
            //MARK: выдать предупреждение, что это предельное значение(?)
            return number
        } else {
            let orderOfMagnitude = String(Int(number)).count - 1
            let magnitude = Double(truncating: pow(10, orderOfMagnitude) as NSNumber)
            var approx = (number / magnitude - 0.0055) * 100
            approx = approx.rounded()
            approx = approx * magnitude / 100
            return approx
        }
    }
    
    
    //MARK: - nice string formatting
    func termSubLabelText(for term: Double) -> String {
        var yearsString = String(format: "%.1f", term/12)  + " YEARS)"
        
        // FIXME: localization: if loc == Locale(identifier: "ru_RU") {
        
        let yearsInTerm = term/12
        //MARK: 1 год, 1.1, 1.2 и далее 2 — 4: «года», а 5 и далее — «лет»
        if yearsInTerm == 1 {
            yearsString = "1 ГОД)"
        } else if yearsInTerm < 5 {
            if yearsInTerm.truncatingRemainder(dividingBy: 1.0) == 0 {
                yearsString = String(format: "%.0f", term/12)  + " ГОДА)"
            } else {
                yearsString = String(format: "%.1f", term/12)  + " ГОДА)"
            }
        } else {
            yearsString = String(format: "%.1f", term/12)  + " ЛЕТ)"
        }
        
        return "СРОК КРЕДИТА, МЕСЯЦЕВ (" + yearsString
    }
    
    // FIXME: make String extension instead of function inside this class??
    func numberAsNiceString(_ number: Double) -> String {
        let formatter = NumberFormatter()
        // FIXME: use decimals setting!!
        formatter.usesGroupingSeparator = true
        //        formatter.groupingSeparator = " "
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.locale = loc
        
        return String(describing: formatter.string(for: number)!)
    }
    
    
    // FIXME: make String extension instead of function inside this class
    func percentageAsNiceString(_ number: Double) -> String {
        return String(format: "%.2f",
                      locale: loc,
                      number) + "%"
    }

}
