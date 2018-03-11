//
//  GistView.swift
//  L Calc
//
//  Created by Igor Malyarov on 11.03.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//

import UIKit

@IBDesignable class GistView: UIView {

    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 14.0,
                                             height: 14.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 6.0
    }
    
    // the properties for the gradient
    @IBInspectable var coolHueIndex: Int = 32
    @IBInspectable var startColor: UIColor = UIColor(rgb: 0xce9ffc)
    @IBInspectable var endColor: UIColor = UIColor(rgb: 0x7367f0)
    
    // sample data
//    var graphPoints: [Int] = [4, 7, 8, 9, 5]
    var graphPoints: [Int] = [4, 7, 6, 8, 5, 9, 7, 8, 10, 8, 7, 10, 9, 6, 9, 7, 8, 6, 7, 8, 10, 8, 7, 10, 9, 6, 9, 7, 8, 6, 9, 8, 9, 5]

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
            let spacer = (width - margin * 2 - 4) / CGFloat((self.graphPoints.count - 1))
            var x: CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        // calculate the y point
        let topBorder: CGFloat = Constants.topBorder
        let bottomBorder: CGFloat = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()!
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
        
        //Draw the rectangulars on top of graph stroke
        // [4, 7, 8, 9, 5]
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i),
                                y: columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            
            let rect = UIBezierPath(
                roundedRect: CGRect(origin: point,
                                    size: CGSize(width: Constants.circleDiameter,
                                                 height: columnYHeight(graphPoints[i]) )),
                cornerRadius: Constants.circleDiameter / 3)
            
            rect.fill()
        }
        
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

