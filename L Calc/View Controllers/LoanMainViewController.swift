//
//  LoanMainViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 04.03.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

class LoanMainViewController: UIViewController {
    
    //MARK: - Constants
    let isVerticalPanning = true
    let panningTint = UIColor.orange
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
    private var prevCoordinate: CGPoint!
    private var ratePreviousX: CGPoint!
    private var termPreviousX: CGPoint!
    
    // MARK: - prepare Feedback Generators
    private let change = UISelectionFeedbackGenerator()
    private let impact = UIImpactFeedbackGenerator()
    
    
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
        
        //FIXME: три типа кредитов (в конце срока, аннуитет, равными частями тело — в этом случае не ежемесячный платеж, а первый(?))
        if loan.type == .decliningBalance {
            loanTypeSegment.selectedSegmentIndex = 1
        } else {
            loanTypeSegment.selectedSegmentIndex = 0
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
    
    // MARK: - @IBActions
    @IBAction func loanTypeSegmentChanged(
        _ sender: UISegmentedControl) {
        
        //FIXME: три типа кредитов (в конце срока, аннуитет, равными частями тело — в этом случае не ежемесячный платеж, а первый(?))

        if loanTypeSegment.selectedSegmentIndex == 0 {
            loan.type = .fixedFlat
        } else {
            loan.type = .decliningBalance
        }
        
        showLoanData()
    }
    
    //FIXME: use this for new Show Payment Schedule button!!
    //    @IBAction func showGraphButtonTouched(_ sender: UIButton) {
    ////        notification.notificationOccurred(.error)
    //        impact.impactOccurred()
    //    }
    
    // MARK: - changing label values by panning gestures
    @IBAction func loanPanDetected1(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        //  Pan Gesture Recognizer with 1 finger
        changeValueByPan(gestureRecognizer, with: 1)
    }
    
    @IBAction func loanPanDetected2(
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
        
        switch gestureRecognizer.state {
            
        case .began:
            prevCoordinate = .zero
            amountLabel.textColor = panningTint
            amountSubLabel.textColor = panningTint
            
        case .changed:
            var coordinate = CGFloat(0)
            var distance = CGFloat(0)
            if isVerticalPanning {
                distance = prevCoordinate.x - coordinate
                coordinate = gestureRecognizer.translation(in: self.view).y
                prevCoordinate.y = coordinate
            } else {
                distance = coordinate - prevCoordinate.x
                coordinate = gestureRecognizer.translation(in: self.view).x
                prevCoordinate.x = coordinate
            }

            // для снижения скорости изменения берется значение > 0
            // если пан двумя пальцами, то скорость выше, если одним,
            // то чувствительность снижаем, повышая threshold
            if touches == 1 {
                threshold = CGFloat(3.5)
            } else if touches == 2 {
                threshold = CGFloat(0)
            }
            
            if abs(distance) > threshold {
                
                if distance > 0 {
                    loan.amount = stepUp(loan.amount)
                } else if distance < 0 {
                    loan.amount = stepDown(loan.amount)
                }
                

                showLoanData()
            }
            
        case .ended:
            change.selectionChanged()
            amountLabel.textColor = loanParamsTint
            amountSubLabel.textColor = loanParamsTint
            
        default:
            print("smth else")
        }
    }
    
    
    @IBAction func ratePanDetected(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
            
        case .began:
            ratePreviousX = .zero
            rateLabel.textColor = panningTint
            rateSubLabel.textColor = panningTint
            
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
            rateLabel.textColor = loanParamsTint
            rateSubLabel.textColor = loanParamsTint
            
        default:
            print("smth else")
        }
    }
    
    @IBAction func termPanDetected(
        _ gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            termPreviousX = .zero
            termLabel.textColor = panningTint
            termSubLabel.textColor = panningTint
            
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
            termLabel.textColor = loanParamsTint
            termSubLabel.textColor = loanParamsTint
            
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
            // MARK: выдать предупреждение, что это предельное значение(?)
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
            // MARK: выдать предупреждение, что это предельное значение(?)
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

