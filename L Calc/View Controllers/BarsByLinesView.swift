//
//  BarsByLinesView.swift
//  L Calc
//
//  Created by Igor Malyarov on 17.03.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

@IBDesignable class BarsByLinesView: UIView {
    
    var dataColor = UIColor(hexString: "D6D6D6")
    
    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 14.0,
                                             height: 14.0)
        static let margin: CGFloat = 0.0
        static let topBorder: CGFloat = 6
        static let bottomBorder: CGFloat = 4
        static let colorAlpha: CGFloat = 0.3
        static let barWidth: CGFloat = 8.0
    }
    
    // the properties for the gradient
//    @IBInspectable var coolHueIndex: Int = -1
//    @IBInspectable var startColor = UIColor.clear   // UIColor(rgb: 0xce9ffc)
//    @IBInspectable var endColor = UIColor.clear // UIColor(rgb: 0x7367f0)
    
//        var dataPoints: [Int] = [1, 0, 6]
    var dataPoints: [Int] = [1, 0, 6, 4, 5, 6, 7, 8, 9, 10, 0, 6, 4, 5, 6, 7, 10, 10, 1]
    
    
    override func draw(_ rect: CGRect) {
        
//        if coolHueIndex > -1 && coolHueIndex < 60 {
//            startColor = UIColor.clear
//            endColor = UIColor.clear
//        }
//
        let width = rect.width
        let height = rect.height
//
//        let path = UIBezierPath(
//            roundedRect: rect,
//            byRoundingCorners: UIRectCorner.allCorners,
//            cornerRadii: Constants.cornerRadiusSize)
//        path.addClip()
//
//        let context = UIGraphicsGetCurrentContext()!
//        let colors = [startColor.cgColor, endColor.cgColor]
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let colorLocations: [CGFloat] = [0.0, 1.0]
//
//        let gradient = CGGradient(colorsSpace: colorSpace,
//                                  colors: colors as CFArray,
//                                  locations: colorLocations)!
//
//        let startPoint = CGPoint.zero
//        let endPoint = CGPoint(x: 0, y: self.bounds.height)
//        context.drawLinearGradient(gradient,
//                                   start: startPoint,
//                                   end: endPoint,
//                                   options: CGGradientDrawingOptions(rawValue: 0))
        
        //calculate the x point
        let margin = Constants.margin
        let spacer = (width - margin * 2) / CGFloat(dataPoints.count + 1)
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
        
        let maxValue = dataPoints.max()!
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
        
        
        // ширина столбика зависит от количества точек
        var barWidth = spacer * 2 / 3
        if spacer < 9 { barWidth = spacer / 2}
        
        // Draw stacked bar diagram
        let dataPath = UIBezierPath()
        dataPath.lineWidth = barWidth
        let interestPath = UIBezierPath()
        interestPath.lineWidth = barWidth
        for i in 0..<dataPoints.count {
            
            let point1 = CGPoint(x: columnXPoint(i),
                                 y: columnYPoint(dataPoints[i]))
            
            let nextPoint1 = CGPoint(x: point1.x,
                                     y: point1.y + columnYHeight(dataPoints[i]))
            dataPath.move(to: nextPoint1)
            dataPath.addLine(to: point1)
            
        }
        
        dataColor.setStroke()
        dataPath.stroke()
        
        
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
}

