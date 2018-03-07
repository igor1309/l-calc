//
//  GraphView.swift
//  L Calc
//
//  Created by Igor Malyarov on 24.02.2018.
//  Copyright © 2018 Igor Malyarov. All rights reserved.
//
// https://www.raywenderlich.com/162313/core-graphics-tutorial-part-2-gradients-contexts

import UIKit

@IBDesignable class GraphView2: UIView {

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
    @IBInspectable var coolHueIndex: Int = 55   //32
    @IBInspectable var startColor: UIColor = UIColor(rgb: 0xce9ffc)
    @IBInspectable var endColor: UIColor = UIColor(rgb: 0x7367f0)
    
    var gPoints1: [Int]?
    var gPoints2: [Int]?
    // sample data
//    var graphPoints2: [Int]?
    /*
     [39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810, 39810]
    var graphPoints1: [Int] = [4, 7, 6, 8, 5]
    var graphPoints2: [Int] = [9, 11, 16, 13, 12]

     */

    override func draw(_ rect: CGRect) {
        
        guard let graphPoints1 = gPoints1 else {
            return
        }
        
        guard let graphPoints2 = gPoints2 else {
            return
        }
        
        if coolHueIndex > -1 && coolHueIndex < 60 {
            startColor =
                UIColor(hexString: coolHue.colorData[coolHueIndex][0])
            endColor =
                UIColor(hexString: coolHue.colorData[coolHueIndex][1])
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
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: 0, y: self.bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: CGGradientDrawingOptions(rawValue: 0))
        
        //calculate the x point
        let margin = Constants.margin
        let columnXPoint = { (column:Int) -> CGFloat in
            //Calculate gap between points
            let spacer = (width - margin * 2 - 4) / CGFloat((graphPoints1.count - 1))
            var x: CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        // calculate the y point
        let topBorder: CGFloat = Constants.topBorder
        let bottomBorder: CGFloat = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = max(graphPoints1.max()!, graphPoints2.max()!)
        let columnYPoint = { (graphPoint:Int) -> CGFloat in
            var y:CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }
        
        // draw the line graph
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        //set up the points line
        let graphPath = UIBezierPath()
        //go to start of line
        graphPath.move(to: CGPoint(x:columnXPoint(0),
                                   y:columnYPoint(graphPoints1[0])))
        
        //add points for each item in the graphPoints1 array
        //at the correct (x, y) for the point
        for i in 1..<graphPoints1.count {
            let nextPoint = CGPoint(x:columnXPoint(i),
                                    y:columnYPoint(graphPoints1[i]))
            graphPath.addLine(to: nextPoint)
        }

        //Create the clipping path for the graph gradient
        
        //1 - save the state of the context
//        context.saveGState()
        
        //2 - make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //3 - add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints1.count - 1),
                                         y: columnYPoint(graphPoints2[graphPoints2.count - 1])))

        //set up the points line
        let graphPath2 = UIBezierPath()
        //go to start of line
        graphPath2.move(to: CGPoint(x:columnXPoint(graphPoints2.count - 1),
                                   y:columnYPoint(graphPoints2[graphPoints2.count - 1])))
        
        //add points for each item in the graphPoints2 array
        //at the correct (x, y) for the point
        for i in (0..<graphPoints2.count - 1).reversed() {
            let nextPoint = CGPoint(x:columnXPoint(i),
                                    y:columnYPoint(graphPoints2[i]))
            graphPath2.addLine(to: nextPoint)
        }
        
        
        animateOutline(graphPath,
                       with: .cyan,
                       lineWidth: 2.0,
                       duration: 3)
        animateOutline(graphPath2.reversing(),
                       with: .cyan,
                       lineWidth: 2.0,
                       duration: 3)

        
        graphPath.append(graphPath2)
        context.saveGState()
        
        
        
//        animateOutline(graphPath,
//                       with: .cyan,
//                       lineWidth: 2.0,
//                       duration: 3)

        

        
        clippingPath.append(graphPath2)
        clippingPath.addLine(to: CGPoint(x:columnXPoint(0),
                                         y:columnYPoint(graphPoints1[0])))
        clippingPath.close()
        
        //4 - add the clipping path to the context
        clippingPath.addClip()
        
        let highestYPoint = columnYPoint(maxValue)
        startPoint = CGPoint(x:margin,
                             y: highestYPoint)
        endPoint = CGPoint(x:margin,
                           y:self.bounds.height)
        
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: CGGradientDrawingOptions(rawValue: 0))
        context.restoreGState()
        
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()

        
        
        
        drawGraphCircles(columnXPoint,
                         columnYPoint,
                         diameter: Constants.circleDiameter,
                         for: graphPoints1)
        drawGraphCircles(columnXPoint,
                         columnYPoint,
                         diameter: Constants.circleDiameter,
                         for: graphPoints2)

        
        
        
        
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
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            shapeLayer.strokeColor = UIColor.clear.cgColor
        }
    }
    
    
    fileprivate func drawGraphCircles(_ columnXPoint: (Int) -> CGFloat,
                                      _ columnYPoint: (Int) -> CGFloat,
                                      diameter: CGFloat,
                                      for array: [Int]) {
        // не рисовать точки, если их много
        if array.count > 25 {
            return
        }
        
        //Draw the circles on top of graph stroke
        for i in 0..<array.count {
            var point = CGPoint(x:columnXPoint(i),
                                y:columnYPoint(array[i]))
            point.x -= diameter / 2
            point.y -= diameter / 2
            
            let circle = UIBezierPath(
                ovalIn: CGRect(origin: point,
                               size: CGSize(width: diameter,
                                            height: diameter)))
            circle.fill()
        }
    }
    
}
