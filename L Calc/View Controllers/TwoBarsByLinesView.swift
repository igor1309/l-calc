//
//  TwoBarsByLinesView.swift
//  L Calc
//
//  Created by Igor Malyarov on 11.03.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

@IBDesignable class TwoBarsByLinesView: UIView {
    
    var interestColor = UIColor.white
    var principalColor = UIColor.cyan
    
    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 14.0,
                                             height: 14.0)
        static let margin: CGFloat = 12.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let barWidth: CGFloat = 8.0
    }
    
    // the properties for the gradient
    @IBInspectable var coolHueIndex: Int = 32
    @IBInspectable var startColor: UIColor = UIColor(rgb: 0xce9ffc) // UIColor(rgb: 0xce9ffc)
    @IBInspectable var endColor: UIColor = UIColor(rgb: 0x7367f0)   // UIColor(rgb: 0x7367f0)
    
    // sample data
//        var graphPoints1: [Int] = [4, 7, 8, 9, 5]
//    var graphPoints1: [Int] = [104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765, 104765]
//    var graphPoints2: [Int] = [65598, 66112, 66630, 67152, 67678, 68208, 68742, 69281, 69823, 70370, 70921, 71477, 72037, 72601, 73170, 73743, 74321, 74903, 75490, 76081, 76677, 77278, 77883, 78493, 79108, 79728, 80352, 80982, 81616, 82255, 82900, 83549, 84203, 84863, 85528, 86198, 86873, 87554, 88239, 88931, 89627, 90329, 91037, 91750, 92469, 93193, 93923, 94659, 95400, 96148, 96901, 97660, 98425, 99196, 99973, 100756, 101545, 102341, 103142, 103950]
    var principalPoints: [Int] = [1, 0, 6]
    var interestPoints: [Int] = [5, 6, 5]
//    var principalPoints: [Int] = [1, 0, 6, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10, 1]
//    var interestPoints: [Int] = [5, 6, 5, 0, 0, 5, 5, 5, 6, 4, 0, 0, 0, 0]

    
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
        let spacer = (width - margin * 2) / CGFloat(principalPoints.count + 1)
        let columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            var x: CGFloat = CGFloat(column + 1) * spacer
            x += margin
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
        
        
        
        // draw diagram with animation
        let principalPath = UIBezierPath()
        // вычисление ширины столбика в зависимости от количества точек
        let barWidth = spacer / 2
//        if principalPoints.count - 1 < 8 { barWidth = 15 }
        principalPath.lineWidth = barWidth
        let interestPath = UIBezierPath()
        interestPath.lineWidth = barWidth
        // Draw stacked bar diagram
        for i in 0..<principalPoints.count {
            
            
            let point1 = CGPoint(x: columnXPoint(i),
                                 y: columnYPoint(principalPoints[i]))
            
            let nextPoint1 = CGPoint(x: point1.x,
                                     y: point1.y + columnYHeight(principalPoints[i]))
            principalPath.move(to: nextPoint1)
            principalPath.addLine(to: point1)


            var point2 = CGPoint(x: columnXPoint(i),
                                 y: columnYPoint(principalPoints[i]))
            point2.y -= columnYHeight(interestPoints[i])
           
            let nextPoint2 = CGPoint(x: point2.x,
                                     y: point2.y + columnYHeight(interestPoints[i]))
            interestPath.move(to: nextPoint2)
            interestPath.addLine(to: point2)
        }


        let duration: CFTimeInterval = 2
        animateOutline(principalPath,
                       with: principalColor,
                       lineWidth: barWidth,
                       duration: duration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7 * duration) {
            // 0.7 * duration — начать анимацию чуть раньше, чем закончится предудущая
            self.animateOutline(interestPath,
                                with: self.interestColor,
                                lineWidth: barWidth,
                                duration: duration)
        }

        
//        interestColor.setStroke()
//        interestPath.stroke()
//        principalColor.setStroke()
//        principalPath.stroke()
//        simpleAnimation()
        
        
        
        
        //Draw horizontal graph lines on the top of everything
        let linePath = UIBezierPath()
        
        //top line
        linePath.move(to: CGPoint(x: margin + spacer / 2,
                                  y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin - spacer / 2,
                                     y:topBorder))
        
        //center line
        linePath.move(to: CGPoint(x: margin + spacer / 2,
                                  y: graphHeight/2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin - spacer / 2,
                                     y:graphHeight/2 + topBorder))
        
        //bottom line
        linePath.move(to: CGPoint(x: margin + spacer / 2,
                                  y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: width - margin - spacer / 2,
                                     y: height - bottomBorder))
        
        let color = UIColor(white: 1.0,
                            alpha: Constants.colorAlpha)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
    
    
    fileprivate func animateOutline(_ path: UIBezierPath,
                                    with color: UIColor,
                                    lineWidth: CGFloat,
                                    duration: CFTimeInterval) {
        //MARK: animation via https://stackoverflow.com/questions/26578023/animate-drawing-of-a-circle
        
        // Setup the CAShapeLayer with the path, colors, and line width
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = lineWidth;
        // Don't draw the circle initially
        shapeLayer.strokeEnd = 0.0
        
        // Add the shapeLayer to the view's layer's sublayers
        layer.addSublayer(shapeLayer)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        shapeLayer.strokeEnd = 1.0
        // Do animation with selected pacing
        animation.timingFunction = CAMediaTimingFunction(
            name: kCAMediaTimingFunctionEaseInEaseOut)
        
        // Do the actual animation
        shapeLayer.add(animation, forKey: "strokeEnd")
        
        // Clear animation trace
//        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
//            shapeLayer.strokeColor = UIColor.clear.cgColor
//        }
    }
    
    fileprivate func simpleAnimation() {
        //FIXME: need a better animation
        self.alpha = 0.1
        UIView.animate(withDuration: 0.75) {
            self.alpha = 1.0
        }
    }
}
