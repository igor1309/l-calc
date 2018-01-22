//
//  ViewController.swift
//  L Calc
//
//  Created by Igor Malyarov on 26.12.2017.
//  Copyright © 2017 Igor Malyarov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: @IBOutlets
    // Trebuchet MS 56.0
    
    @IBOutlet weak var monthlyPayment: UILabel!
    @IBOutlet weak var monthlyPaymentCommentLabel: UILabel!
    @IBOutlet weak var totalInterest: UILabel!
    @IBOutlet weak var totalPayment: UILabel!
    @IBOutlet weak var annuitySegment: UISegmentedControl!
    
    @IBOutlet weak var sumLabel: UILabel!
    @IBOutlet weak var sumSubLabel: UILabel!
    @IBOutlet weak var sumStack: UIStackView!

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateSubLabel: UILabel!
    @IBOutlet weak var rateStack: UIStackView!
    
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var termSubLabel: UILabel!
    @IBOutlet weak var termStack: UIStackView!
    
    // MARK: vars
    //    var loc = Locale.current
    var loc = Locale(identifier: "en_US")
    
    var previousX: CGPoint!
    var ratePreviousX: CGPoint!
    var termPreviousX: CGPoint!
    
    var sum = UserDefaults.standard.double(forKey: "Principal")
    var rate = UserDefaults.standard.double(forKey: "Rate")
    var term = UserDefaults.standard.double(forKey: "Term")
    // FIXME: initialize annuitySegment
    
    let loan = Loan(UserDefaults.standard.double(forKey: "Principal"),
                    UserDefaults.standard.double(forKey: "Rate"),
                    UserDefaults.standard.double(forKey: "Term"),
                    // FIXME: допилить: определить и использовать loan type as property of class
                    .decliningBalance)

    
    // Feedback Generators
    let change = UISelectionFeedbackGenerator()
    let impact = UIImpactFeedbackGenerator()

    
    // MARK: @IBActions
    @IBAction func annuitySegmentChanged(
        _ sender: UISegmentedControl) {
        UserDefaults.standard.set(annuitySegment.selectedSegmentIndex,
                                  forKey: "AnnuitySegment")
//        print("selected: \(annuitySegment.selectedSegmentIndex)")
//        print("written: \(UserDefaults.standard.integer(forKey: "AnnuitySegment"))")
        
//        change.selectionChanged()
//        перенесено в calculateLoan()
        
        calculateLoan()
    }
    
    @IBAction func showGraphButtonTouched(_ sender: UIButton) {
//        notification.notificationOccurred(.error)
        impact.impactOccurred()
    }
    
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
                    sum = stepUp(sum)
                } else if distanceX < 0 {
                    sum = stepDown(sum)
                }
               
                sumLabel.text = numberAsNiceString(sum)
                UserDefaults.standard.set(sum, forKey: "Principal")
                
                previousX.x = x
                
                calculateLoan()
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
                    rate = rateUp(rate)
                } else if distanceX < 0 {
                    rate = rateDown(rate)
                }
                rateLabel.text = percentageAsNiceString(rate)
                UserDefaults.standard.set(rate, forKey: "Rate")
                
                ratePreviousX.x = x
                
                calculateLoan()
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
                    term += 1
                } else if distanceX < 0 {
                    if term > 1 {
                        term -= 1
                    }
                }
                termLabel.text = String(format: "%.0f", term)
                UserDefaults.standard.set(term, forKey: "Term")
                
                termSubLabel.text = termSubLabelText(for: term)
                termPreviousX.x = x
                
                calculateLoan()
            }
            
        case .ended:
            change.selectionChanged()
            termLabel.textColor = normalLabelColor
            termSubLabel.textColor = normalLabelColor

        default:
            print("smth else")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard

        
        // FIXME: move to Data Model
        annuitySegment.selectedSegmentIndex = defaults.integer(
            forKey: "AnnuitySegment")
        
        // FIXME: move to Data Model
        sum = defaults.double(forKey: "Principal")
        if sum == 0 {
            sum = 1000000.0
        }
        sumLabel.text = numberAsNiceString(sum)
        
        // FIXME: move to Data Model
        rate = defaults.double(forKey: "Rate")
        if rate == 0 {
            rate = 9.0
        }
        rateLabel.text = percentageAsNiceString(rate)

        // FIXME: move to Data Model
        term = defaults.double(forKey: "Term")
        if term == 0 {
            term = 12
        }
        termLabel.text = String(format: "%.0f", term)
        termSubLabel.text = termSubLabelText(for: term)

        calculateLoan()
    }

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if let destinationViewController = segue.destination as? PaymentsTableViewController {
            destinationViewController.loan = loan
        }
    }
    

    func stepUp(_ number: Double) -> Double {
        
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
        
        let max = 199.0
        if number > max {
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
        
        if number < 0.0200 {
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
    
    // FIXME: make String extension instead of function inside this class??
    func numberAsNiceString(_ number: Double) -> String {
        let formatter = NumberFormatter()
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
    
    func calculateLoan() {
        // MARK: TODO вычисления по кредиту
        let r = rate / 100 / 12    // monthly interest rate
        if annuitySegment.selectedSegmentIndex == 1 {
            //  выбран аннуитет
            //  http://financeformulas.net/Annuity_Payment_Formula.html
            let p = pow(1 + r, 0 - term)
            let mp = sum / ((1 - p) / r)
            monthlyPayment.text = String(format: "%.0f",
                                         locale: loc,
                                         mp)
            totalInterest.text = String(format: "%.0f",
                                        locale: loc,
                                        mp * term - sum)
            totalPayment.text = String(format: "%.0f",
                                       locale: loc,
                                       mp * term)
        } else {
            monthlyPayment.text = String(format: "%.0f",
                                         locale: loc,
                                         sum * r)
            totalInterest.text = String(format: "%.0f",
                                        locale: loc,
                                        sum * r * term)
            totalPayment.text = String(format: "%.0f",
                                        locale: loc,
                                        sum * (1 + r * term))
        }

        //  provide haptic feedback
        change.selectionChanged()
        
        // sync user defaults
        UserDefaults.standard.synchronize()
        
        // notify that load has beed changed
        NotificationCenter.default.post(
            Notification(name: .loanChanged))


    }
}
