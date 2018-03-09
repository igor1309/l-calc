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
        case up, down, none
    }
    
    private enum Axis {
        case x, y
    }
    
    //MARK: - Constants
    let changingTint = UIColor(hexString: "FFCD07")
    let loanParamsTint = UIColor(hexString: "D1D1D1")
    
    //FIXME: проверку диапазона убрать в определение переменной класса
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

    //MARK: - vars
    private var loan = Loan()
    
    // FIXME: all things Locale
    //    var loc = Locale.current
    private var loc = Locale(identifier: "en_US")
    
    // FIXME: должно ли это быть здесь или переменные должны быть спрятаны в методы?
    private var axis: Axis?
    private var prevPoint: CGPoint!
    
    //MARK: - prepare Feedback Generators
    private let feedbackChange = UISelectionFeedbackGenerator()
    private let feedbackImpact = UIImpactFeedbackGenerator()
    
    func outOfRangeFeedback() {
        let notification = UINotificationFeedbackGenerator()
        notification.notificationOccurred(.warning)
    }

    //MARK: - View
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
    
    //MARK: - Show Loan
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
            loanTypeSegment.selectedSegmentIndex = 0
            monthlyPaymentCommentLabel.text = "ПЕРВЫЙ ПЛАТЕЖ"
            
        case .fixedPrincipal:
            loanTypeSegment.selectedSegmentIndex = 1
            monthlyPaymentCommentLabel.text = "ПЕРВЫЙ ПЛАТЕЖ"
            
        case .fixedPayment:
            loanTypeSegment.selectedSegmentIndex = 2
            monthlyPaymentCommentLabel.text = "ЕЖЕМЕСЯЧНЫЙ ПЛАТЕЖ"
        }
        loanTypeComment.text = loan.interestTypeComment[loan.type]

        //  provide haptic feedback
        feedbackChange.selectionChanged()
    }
    
    //MARK: - @IBActions
    @IBAction func loanTypeSegmentChanged(_ sender: UISegmentedControl) {
        
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
    
    //MARK: - @IBActions: amount tapping and panning
    @IBAction func amountTapDetected(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let direction = directionForTap(sender, in: amountStack) else { return }
            
            loan.amount =  changeNumber(loan.amount,
                                direction: direction)
            showLoanData()
        }
    }

    @IBAction func amountPanDetected1(_ sender: UIPanGestureRecognizer) {
        //  Pan Gesture Recognizer with 1 finger
        guard let newValue = changeByPan(sender,
                                         number: loan.amount,
                                         label: amountLabel,
                                         subLabel: amountSubLabel,
                                         threshold: 0.35)  else { return }
        loan.amount = newValue
        showLoanData()
    }
    
    @IBAction func amountPanDetected2(_ sender: UIPanGestureRecognizer) {
        //  Pan Gesture Recognizer with 2 fingers
        guard let newValue = changeByPan(sender,
                                         number: loan.amount,
                                         label: amountLabel,
                                         subLabel: amountSubLabel,
                                         threshold: 0)  else { return }
        loan.amount = newValue
        showLoanData()
    }
    
    //MARK: - Gesture Recognizer отключен в IB
    @IBAction func amountLongPressDetected(_ sender: UILongPressGestureRecognizer) {

        switch sender.state {
        case .began:
            dimResultsAndColorChange(amountLabel,
                                     amountSubLabel)
        case .changed:
            loan.amount = changeNumber(loan.amount,
                                       direction: .up)
            showLoanData()
            
        case .ended:
            restoreResultsAndColor(amountLabel, amountSubLabel)
        default:
            print("smth else")
        }
    }

    //MARK: - @IBActions: rate tapping and panning
    @IBAction func ratePanDetected(
        _ sender: UIPanGestureRecognizer) {
        
        guard let newValue = changeByPan(sender,
                                         number: loan.rate,
                                         label: rateLabel,
                                         subLabel: rateSubLabel,
                                         threshold: 4,
                                         useDecimal: true)  else { return }
        
        loan.rate = newValue
        showLoanData()
    }
    
    @IBAction func rateTapDetected(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let direction = directionForTap(sender, in: rateStack) else { return }
            
            loan.rate =  changeNumber(loan.rate,
                                      direction: direction,
                                      useDecimal: true)
            
            //FIXME: проверку диапазона убрать в определение переменной класса
            if loan.rate <= minRate {
                loan.rate = minRate
            }
            if loan.rate >= maxRate {
                loan.rate = maxRate
            }
            showLoanData()
        }
    }
    
    //MARK: - Gesture Recognizer отключен в IB
    @IBAction func rateDoubleTapDetected(_ sender: UITapGestureRecognizer) {
        
        guard let direction = directionForTap(sender, in: rateStack) else { return }
        
        loan.rate =  changeNumber(loan.rate * 10,
                                  direction: direction) / 10
        
        //FIXME: проверку диапазона убрать в определение переменной класса
        if loan.rate <= minRate {
            loan.rate = minRate
        }
        if loan.rate >= maxRate {
            loan.rate = maxRate
        }
        showLoanData()
    }
    
    //MARK: - Gesture Recognizer отключен в IB
    @IBAction func rateLongPressDetected(_ sender: UILongPressGestureRecognizer) {

        switch sender.state {
        case .began:
            dimResultsAndColorChange(rateLabel, rateSubLabel)
            
        case .changed:
            guard let direction = directionForTap(sender, in: rateStack) else { return }
            
            loan.rate = changeNumber(loan.rate, direction: direction)

            //FIXME: проверку диапазона убрать в определение переменной класса
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
    
    //MARK: - @IBActions: term tapping and panning

    @IBAction func termPanDetected(
        _ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            dimResultsAndColorChange(termLabel, termSubLabel)
            prevPoint = .zero
            
        case .changed:
            //FIXME: оптимизировать функцию с учетом уже имеющихся
            // нужно изменить имеющиеся служебные???
            let x = sender.translation(in: self.view).x
            let distanceX = x - prevPoint.x
            // для снижения скорости изменения берется значение > 0
            let threshold = CGFloat(7)
            if abs(distanceX) < threshold {
                return
            }
            if abs(distanceX) > threshold {
                
                if distanceX > 0 {
                    loan.term += 1
                } else if distanceX < 0 {
                    if loan.term > 1 {
                        loan.term -= 1
                    }
                }

                //FIXME: сохранение убрать в определение переменной класса
                termLabel.text = String(format: "%.0f", loan.term)
                UserDefaults.standard.set(loan.term, forKey: "Term")
                
                prevPoint.x = x
                
                showLoanData()
            }
        case .ended:
//            feedbackChange.selectionChanged()
            restoreResultsAndColor(termLabel, termSubLabel)
        default:
            print("smth else")
        }
    }
    
    @IBAction func termTapDetected(_ sender: UITapGestureRecognizer) {
        
        guard let direction = directionForTap(sender, in: termStack) else { return }
        
        loan.term =  changeNumber(loan.term,
                                  direction: direction)
        
        //FIXME: проверку диапазона убрать в определение переменной класса

        showLoanData()

    }
    
    //MARK: - Visual settigs for change
    fileprivate func dimResultsAndColorChange(_ label: UILabel,
                                              _ subLabel: UILabel) {
        UIView.animate(withDuration: 0.5) {
            self.loanResultsView.alpha = 0.7
        }
        label.textColor = changingTint
        subLabel.textColor = changingTint
    }
    
    fileprivate func restoreResultsAndColor(_ label: UILabel,
                                            _ subLabel: UILabel) {
        UIView.animate(withDuration: 0.5) {
            self.loanResultsView.alpha = 1.0
        }
        label.textColor = loanParamsTint
        subLabel.textColor = loanParamsTint
    }
    
    //MARK: - Change number functions
    private func changeNumber(_ number: Double,
                              direction: Direction) -> Double {
        
        var plusMinus: Double
        
        switch direction {
        case .up: plusMinus = 1
        default: plusMinus = -1
        }
        
        let orderOfMagnitude = String(Int(number)).count - 1
        let magnitude = Double(truncating: pow(10, orderOfMagnitude) as NSNumber)
        var approx = (number / magnitude + plusMinus * 0.055) * 10
        approx = approx.rounded()
        approx = approx * magnitude / 10
        return approx
    }
    
    private func changeNumber (_ number: Double,
                               direction: Direction,
                               useDecimal: Bool) -> Double {
        var plusMinus: Double
        
        switch direction {
        case .up: plusMinus = 1
        default: plusMinus = -1
        }
        
        if useDecimal {
            var approx = (number * 10 + plusMinus)
            approx = approx.rounded()
            approx = approx / 10
            return approx
        } else {
            return changeNumber(number, direction: direction)
        }
    }
    
    //MARK: - Tap functions
    private func directionForTap(_ sender: UIGestureRecognizer, in view: UIView) -> Direction? {
        let x = sender.location(in: view).x
        let center = view.frame.width / 2
        if x == center { return nil }
        
        var direction: Direction
        if x > center {
            direction = .up
        } else {
            direction = .down
        }
        return direction
    }
    
    //MARK: - Change by Pan functions
    func changeByPan(_ sender: UIPanGestureRecognizer,
                     number: Double,
                     label: UILabel,
                     subLabel: UILabel,
                     threshold: CGFloat,
                     useDecimal: Bool) -> Double? {
        switch sender.state {
            
        case .began:
            prevPoint = .zero
            dimResultsAndColorChange(label, subLabel)
            return nil
            
        case .changed:
            let x = sender.translation(in: self.view).x
            let distanceX = x - prevPoint.x
            if abs(distanceX) < threshold { return nil }
            
            var direction: Direction
            if distanceX > 0 {
                direction = .up
            } else {
                direction = .down
            }
            prevPoint.x = x
            
            return changeNumber(number,
                                direction: direction,
                                useDecimal: useDecimal)
        case .ended:
            restoreResultsAndColor(label, subLabel)
            return nil
        default:
            print("smth else")
            return nil
        }
    }
    
    func changeByPan(_ sender: UIPanGestureRecognizer,
                     number: Double,
                     label: UILabel,
                     subLabel: UILabel,
                     threshold: CGFloat) -> Double? {
        // вариант этого функционала без параметра useDecimal
        
        return changeByPan(sender,
                           number: number,
                           label: label,
                           subLabel: subLabel,
                           threshold: threshold,
                           useDecimal: false)
    }
    
    //MARK: - Nice string formatting
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
    
    // FIXME: Make String extension instead of function inside this class??
    func numberAsNiceString(_ number: Double) -> String {
        let formatter = NumberFormatter()
        // FIXME: use decimals setting!!
        formatter.usesGroupingSeparator = true
        //        formatter.groupingSeparator = " "
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.locale = loc
        
        return String(describing: formatter.string(for: number)!)
    }
    
    
    // FIXME: Make String extension instead of function inside this class
    func percentageAsNiceString(_ number: Double) -> String {
        return String(format: "%.2f",
                      locale: loc,
                      number) + "%"
    }
    
}
