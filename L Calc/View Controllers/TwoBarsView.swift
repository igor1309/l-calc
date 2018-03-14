//
//  TwoBarsView.swift
//  L Calc
//
//  Created by Igor Malyarov on 11.03.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

@IBDesignable class TwoBarsView: UIView {
    
    var interestColor = UIColor.white
    var principalColor = UIColor.cyan
    
    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 14.0,
                                             height: 14.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 3.0
    }
    
    // the properties for the gradient
    @IBInspectable var coolHueIndex: Int = 32
    @IBInspectable var startColor: UIColor = UIColor(rgb: 0xce9ffc)
    @IBInspectable var endColor: UIColor = UIColor(rgb: 0x7367f0)
    
    //    var graphPoints1: [Int]?
//    var graphPoints2: [Int]?

    // sample data
    //    var graphPoints: [Int] = [4, 7, 8, 9, 5]
    var principalPoints: [Int] = [104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765]
    var interestPoints: [Int] = [65598, 66112, 66630, 67152, 67678, 68208, 68742, 69281, 69823, 70370, 70921, 71477, 72037, 72601, 73170, 73743, 74321, 74903, 75490, 76081, 76677, 77278, 77883, 78493, 79108, 79728, 80352, 80982, 81616, 82255, 82900, 83549, 84203, 84863, 85528, 86198, 86873, 87554, 88239, 88931, 89627, 90329, 91037, 91750, 92469, 93193, 93923, 94659, 95400, 96148, 96901, 97660, 98425, 99196, 99973, 100756, 101545, 102341, 103142, 103950]
//    var graphPoints1: [Int] = [2, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 1, 1, 7, 8, 10, 8, 7, 10, 9, 6, 9, 7, 8, 6, 9, 8, 9]
//    var graphPoints2: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9, 1, 3, 1, 3, 1, 1, 2, 2, 2, 1, 3, 2, 2, 3, 2, 5]

    // [104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765]
    // [65598, 66112, 66630, 67152, 67678, 68208, 68742, 69281, 69823, 70370, 70921, 71477, 72037, 72601, 73170, 73743, 74321, 74903, 75490, 76081, 76677, 77278, 77883, 78493, 79108, 79728, 80352, 80982, 81616, 82255, 82900, 83549, 84203, 84863, 85528, 86198, 86873, 87554, 88239, 88931, 89627, 90329, 91037, 91750, 92469, 93193, 93923, 94659, 95400, 96148, 96901, 97660, 98425, 99196, 99973, 100756, 101545, 102341, 103142, 103950]
    
    fileprivate func simpleAnimation() {
        //FIXME: need a better animation
        self.alpha = 0.1
        UIView.animate(withDuration: 0.75) {
            self.alpha = 1.0
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        if coolHueIndex > -1 && coolHueIndex < 60 {
            startColor = UIColor(hexString: coolHue.colorData[coolHueIndex][0])
            endColor = UIColor(hexString: coolHue.colorData[coolHueIndex][1])
        }
        
        let width = rect.width
        let height = rect.height
        
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: UIRectCorner.allCorners,
            cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        let context = UIGraphicsGetCurrentContext()!
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: colors as CFArray,
                                  locations: colorLocations)!
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: self.bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: CGGradientDrawingOptions(rawValue: 0))
        
        //calculate the x point
        let margin = Constants.margin
        let columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            let spacer = (width - margin * 2 - 4) / CGFloat((self.principalPoints.count - 1))
            var x: CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        // calculate the y point
        let topBorder: CGFloat = Constants.topBorder
        let bottomBorder: CGFloat = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder

        func maxOf2Sum(a: [Int], b: [Int]) -> Int {
            var maxSum = 0
            for i in 0...a.count - 1 {
                if maxSum < a[i] + b[i] {
                    maxSum = a[i] + b[i]
                }
            }
            return maxSum
        }
        let maxValue = maxOf2Sum(a: principalPoints, b: interestPoints)
        
        let columnYPoint = { (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
        
        // calculate the height
        let columnYHeight = { (graphPoint:Int) -> CGFloat in
            let y:CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return y
        }
        
        // draw the line graph
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        
        let bars1 = UIBezierPath()
        let bars2 = UIBezierPath()
        // Draw stacked bar diagram
        for i in 0..<principalPoints.count {
            
            //FIXME: сделать вычисление/выбор ширины столбика в зависимости от количества точек
            
            var point1 = CGPoint(x: columnXPoint(i),
                                 y: columnYPoint(principalPoints[i]))
            point1.x -= Constants.circleDiameter / 2
            point1.y += Constants.circleDiameter
            
            bars1.move(to: point1)
            let bar1 = UIBezierPath(
                roundedRect: CGRect(origin: point1,
                                    size: CGSize(width: Constants.circleDiameter,
                                                 height: columnYHeight(principalPoints[i]) - Constants.circleDiameter)),
                cornerRadius: Constants.circleDiameter / 3)
            bars1.append(bar1)
            
            var point2 = CGPoint(x: columnXPoint(i),
                                 y: columnYPoint(principalPoints[i]))
            point2.x -= Constants.circleDiameter / 2
            point2.y -=  columnYHeight(interestPoints[i]) - Constants.circleDiameter * 2
            bars2.move(to: point2)
            let bar2 = UIBezierPath(
                roundedRect: CGRect(origin: point2,
                                    size: CGSize(width: Constants.circleDiameter,
                                                 height: columnYHeight(interestPoints[i]) - Constants.circleDiameter )),
                cornerRadius: Constants.circleDiameter / 3)
            
            bars2.append(bar2)
        }
        principalColor.setFill()
        bars1.fill()
        interestColor.setFill()
        bars2.fill()
        
        simpleAnimation()
        
        
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
        linePath.move(to: CGPoint(x:margin,
                                  y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin,
                                     y:topBorder))
        
        //center line
        linePath.move(to: CGPoint(x:margin,
                                  y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x:width - margin,
                                     y:graphHeight/2 + topBorder))
        
        //bottom line
        linePath.move(to: CGPoint(x:margin,
                                  y:height - bottomBorder))
        linePath.addLine(to: CGPoint(x:width - margin,
                                     y:height - bottomBorder))
        let color = UIColor(white: 1.0,
                            alpha: Constants.colorAlpha)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
    
}


