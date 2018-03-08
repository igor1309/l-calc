//
//  LoanMainViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 04.03.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class LoanMainViewController: UIViewController {
    
    private enum Direction {
        case up, down
    }
    
    private enum Axis {
        case x, y
    }
    
    //MARK: - Constants
    let isVerticalPanning = true
    let changingTint = UIColor(hexString: "FFCD07")
    let loanParamsTint = UIColor(hexString: "D1D1D1")
    let maxRate = 199.0
    let minRate = 0.02

    //MARK: - @IBOutlets
    @IBOutlet weak var monthlyPayment: UILabel!
    @IBOutlet weak var monthlyPaymentCommentLabel: UILabel!
    @IBOutlet weak var totalInterest: UILabel!
    @IBOutlet weak var totalPayment: UILabel!
    @IBOutlet weak var loanResultsView: UIView!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountSubLabel: UILabel!
    @IBOutlet weak var amountStack: UIStackView!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateSubLabel: UILabel!
    @IBOutlet weak var rateStack: UIStackView!
    
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var termSubLabel: UILabel!
    @IBOutlet weak var termStack: UIStackView!
    
    @IBOutlet weak var loanTypeComment: UILabel!
    
    @IBOutlet weak var loanTypeSegment: UISegmentedControl!

    // MARK: - vars
    private var loan = Loan()
    
    // FIXME: all things Locale
    //    var loc = Locale.current
    private var loc = Locale(identifier: "en_US")
    
    // FIXME: должно ли это быть здесь или переменные должны быть спрятаны в методы?
    private var direction: Direction?
    private var axis: Axis?
    private var prevPoint: CGPoint!
    private var ratePreviousX: CGPoint!
    private var termPreviousX: CGPoint!
    
    // MARK: - prepare Feedback Generators
    private let feedbackChange = UISelectionFeedbackGenerator()
    private let feedbackImpact = UIImpactFeedbackGenerator()
    
    
    // MARK: -
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        self.view.applyGradient()
        
        //FIXME: TODO: нужно разобраться, как отменять эти изменения
        // чтобы navigationController в последующих VC не портить
        if let navBar = self.navigationController?.navigationBar {
            navBar.setBackgroundImage(UIImage(), for: .default)
            navBar.shadowImage = UIImage()
            navBar.isTranslucent = true
            navBar.tintColor = loanParamsTint
        }
    }
    
    func outOfRangeFeedback() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.warning)
    }
    
    func showLoanData() {
        amountLabel.text = numberAsNiceString(loan.amount)
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
        
        switch loan.type {
        case .interestOnly:
            // Проценты выплачиваются ежемесячно, а тело в конце срока
            loanTypeSegment.selectedSegmentIndex = 0
            monthlyPaymentCommentLabel.text = "ПЕРВЫЙ ПЛАТЕЖ"
        case .fixedPrincipal:
            // Тело кредита погашается ежемесячно равными суммами
            loanTypeSegment.selectedSegmentIndex = 1
            monthlyPaymentCommentLabel.text = "ПЕРВЫЙ ПЛАТЕЖ"
        case .fixedPayment:
            // аннуитет: Ежемесячные выплаты равными суммами, включающими проценты и тело кредита
            loanTypeSegment.selectedSegmentIndex = 2
            monthlyPaymentCommentLabel.text = "ЕЖЕМЕСЯЧНЫЙ ПЛАТЕЖ"
        }
        loanTypeComment.text = loan.interestTypeComment[loan.type]

        //  provide haptic feedback
        feedbackChange.selectionChanged()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if let destinationViewController = segue.destination as? PaymentsTableViewController {
            //            destinationViewController.loan = loan
            destinationViewController.payments =
                Payments(for: loan)
        }

        if let destinationViewController = segue.destination as? Graph2ViewController {
            destinationViewController.loan = loan
        }
        
    }
    
    // MARK: - @IBActions
    @IBAction func loanTypeSegmentChanged(
        _ sender: UISegmentedControl) {
        
        switch loanTypeSegment.selectedSegmentIndex {
        case 0:
            loan.type = .interestOnly
        case 1:
            loan.type = .fixedPrincipal
        case 2:
            loan.type = .fixedPayment
        default:
            print("other")
        }
        showLoanData()
    }
    
    // MARK: - changing label values by tapping and panning gestures
    
    private func directionForTap(_ sender: UIGestureRecognizer,
                                 in view: UIView) -> Direction? {
        let x = sender.location(in: view).x
        let center = view.frame.width / 2
        if x == center {
            return nil
        }
        
        var direction: Direction
        if x > center {
            direction = .up
        } else {
            direction = .down
        }
        return direction
    }
    
    @IBAction func amountTapDetected(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let direction = directionForTap(sender, in: amountStack) else { return }
            
            loan.amount =  step(loan.amount,
                                direction: direction)
            showLoanData()
        }
    }
    
    @IBAction func amountPanDetected1(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        //  Pan Gesture Recognizer with 1 finger
        changeValueByPan(gestureRecognizer, with: 1)
    }
    
    @IBAction func amountPanDetected2(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        //  Pan Gesture Recognizer with 2 fingers
        changeValueByPan(gestureRecognizer, with: 2)
    }
    
    @IBAction func loanLongPressDetected(_ sender: UILongPressGestureRecognizer) {
        //FIXME: add another long press area for lowering the amount
        //FIXME: not working with hidden view

        //FIXME: handle long press operation
        
        switch sender.state {
            
        case .began:
            dimResultsAndColorChange(amountLabel, amountSubLabel)

        case .changed:
            loan.amount = step(loan.amount,
                               direction: .up)
            showLoanData()
            
        case .ended:
//            feedbackChange.selectionChanged()
            restoreResultsAndColor(amountLabel, amountSubLabel)
        default:
            print("smth else")
        }
    }
    
    func changeValueByPan(
        _ gestureRecognizer: UIPanGestureRecognizer,
        with touches: Int) {
        // движение (pan, panning) может идти по обеим осям, но направление — ось — определяется в начале
        
        // https://stackoverflow.com/questions/25503537/swift-uigesturerecogniser-follow-finger
        // https://github.com/codepath/ios_guides/wiki/Using-Gesture-Recognizers
        
        
        switch gestureRecognizer.state {
        case .began:
            dimResultsAndColorChange(amountLabel, amountSubLabel)
            
            prevPoint = .zero
            let newPoint = gestureRecognizer.translation(in: self.view)
            let distanceX = newPoint.x - prevPoint.x
            let distanceY = prevPoint.y - newPoint.y
            // определить, по какой оси пошло движение
            if abs(distanceX) < abs(distanceY) {
                axis = .y
            } else {
                axis = .x
            }
        case .changed:
            
            let newPoint = gestureRecognizer.translation(in: self.view)
            var distance = CGFloat(0)
            if let axis = self.axis {
                if axis == .y {
                    //MARK: перемещение по вертикали не меняет значение
                    break
//                    distance = prevPoint.y - newPoint.y
                } else {
                    distance = newPoint.x - prevPoint.x
                }
            }

            prevPoint = newPoint
            
            // если пан двумя пальцами, то скорость выше
            // если одним, то чувствительность снижаем, повышая threshold
            var threshold = CGFloat(0.35)
            if touches == 2 {
                threshold = CGFloat(0)
            }
            if distance > 0 {
                direction = .up
            } else if distance < 0{
                direction = .down
            } else {
                direction = .none
            }
            if abs(distance) > threshold {
                loan.amount = step(loan.amount,
                                   direction: direction!)
                showLoanData()
            }
            
        case .ended:
//            feedbackChange.selectionChanged()
            restoreResultsAndColor(amountLabel, amountSubLabel)
            
        default:
            print("smth else")
        }
    }
    
    
    @IBAction func ratePanDetected(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
            
        case .began:
            ratePreviousX = .zero
            dimResultsAndColorChange(rateLabel, rateSubLabel)
            
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
            restoreResultsAndColor(rateLabel, rateSubLabel)
            
        default:
            print("smth else")
        }
    }
    
    @IBAction func rateTapDetected(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            let x = sender.location(in: rateStack).x
            let center = rateStack.frame.width / 2
            if x == center {
                return
            }
            
            var k: Double
            if x > center { k = 1 } else { k = -1 }
            
            var number = loan.rate
            number = (number * 10).rounded(.towardZero)
            number += k
            loan.rate = number / 10
            if loan.rate <= minRate {
                loan.rate = minRate
            }
            if loan.rate >= maxRate {
                loan.rate = maxRate
            }
            showLoanData()
        }
    }
    
    @IBAction func rateDoubleTapDetected(_ sender: UITapGestureRecognizer) {

        if sender.state == .ended {
            let x = sender.location(in: rateStack).x
            let center = rateStack.frame.width / 2
            if x == center {
                return
            }
            
            var k: Double
            var number = loan.rate
            if x > center {
                k = 1
                number = (number * 1).rounded(.towardZero)
            } else {
                k = -1
                number = (number * 1).rounded(.toNearestOrAwayFromZero)
            }
            
            number += k
            loan.rate = number / 1
            if loan.rate <= minRate {
                loan.rate = minRate
            }
            if loan.rate >= maxRate {
                loan.rate = maxRate
            }
            showLoanData()
        }
    }
    
    
    
    fileprivate func dimResultsAndColorChange(_ label: UILabel,
                                              _ subLabel: UILabel) {
        loanResultsView.alpha = 0.7
        label.textColor = changingTint
        subLabel.textColor = changingTint
    }
    
    fileprivate func restoreResultsAndColor(_ label: UILabel,
                                              _ subLabel: UILabel) {
        loanResultsView.alpha = 1.0
        label.textColor = loanParamsTint
        subLabel.textColor = loanParamsTint
    }
    
    @IBAction func rateLongPressDetected(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
            
        case .began:
            dimResultsAndColorChange(rateLabel, rateSubLabel)
            
        case .changed:
            let x = sender.location(in: rateStack).x
            let center = rateStack.frame.width / 2
            if x == center {
                return
            }
            
            var k: Double
            var number = loan.rate
            if x > center {
                k = 1
                number = (number * 10).rounded(.towardZero)
            } else {
                k = -1
                number = (number * 10).rounded(.toNearestOrAwayFromZero)
            }
            
            number += k
            loan.rate = number / 10
            if loan.rate <= minRate {
                loan.rate = minRate
            }
            if loan.rate >= maxRate {
                loan.rate = maxRate
            }
            showLoanData()
            
        case .ended:
            restoreResultsAndColor(rateLabel, rateSubLabel)
        default:
            print("smth else")
        }
    }
    
    @IBAction func termPanDetected(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            dimResultsAndColorChange(termLabel, termSubLabel)
            termPreviousX = .zero
            
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
//            feedbackChange.selectionChanged()
            restoreResultsAndColor(termLabel, termSubLabel)
            
        default:
            print("smth else")
        }
    }
    
    private func step(_ number: Double, direction: Direction) -> Double {
        
        var plusMinus: Double
        
        switch direction {
        case .up:
            plusMinus = 1
        default:
            plusMinus = -1
        }
        
        let max = Double(truncating: pow(10, 11) as NSNumber)
        if number > max {
            //FIXME: выдать предупреждение, что это предельное значение(?)
            return max
        } else if number < 101 {
            //FIXME: выдать предупреждение, что это предельное значение(?)
            return 101
        } else {
            // take 2 leftmost digits of number before decimal point as a number
            // increase or decrease it, round
            // then multuply and return
            // https://en.wikipedia.org/wiki/Order_of_magnitude
            let orderOfMagnitude = String(Int(number)).count - 1
            let magnitude = Double(truncating: pow(10, orderOfMagnitude) as NSNumber)
            var approx = (number / magnitude + plusMinus * 0.055) * 10
            approx = approx.rounded()
            approx = approx * magnitude / 10
            return approx
        }
    }
    
    func rateUp(_ number: Double) -> Double {
        if number > maxRate {
            // MARK: выдать предупреждение, что это предельное значение(?)
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
        if number < minRate {
            // MARK: выдать предупреждение, что это предельное значение(?)
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
    
    
    // MARK: - nice string formatting
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

