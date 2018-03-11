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
    
    // sample data
    var graphPoints: [Int] = [4, 7, 8, 9, 5]
    //    var graphPoints: [Int] = [4, 7, 6, 8, 5, 9, 7, 8, 10, 8, 7, 10, 9, 6, 9, 7, 8, 6, 7, 8, 10, 8, 7, 10, 9, 6, 9, 7, 8, 6, 9, 8, 9, 5]
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: UIRectCorner.allCorners,
            cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        
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
        
        // draw the line graph
        UIColor.black.setFill()
        UIColor.blue.setStroke()
        
        /*
         //set up the points line
         let graphPath = UIBezierPath()
         //go to start of line
         graphPath.move(to: CGPoint(x:columnXPoint(0),
         y:columnYPoint(graphPoints[0])))
         
         //add points for each item in the graphPoints array
         //at the correct (x, y) for the point
         for i in 1..<graphPoints.count {
         let nextPoint = CGPoint(x:columnXPoint(i),
         y:columnYPoint(graphPoints[i]))
         graphPath.addLine(to: nextPoint)
         }
         
         //Create the clipping path for the graph gradient
         
         //1 - save the state of the context
         context.saveGState()
         
         //2 - make a copy of the path
         let clippingPath = graphPath.copy() as! UIBezierPath
         
         //3 - add lines to the copied path to complete the clip area
         clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1),
         y:height))
         clippingPath.addLine(to: CGPoint(x:columnXPoint(0),
         y:height))
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
         */
        
        //Draw the rectangulars on top of graph stroke
        // [4, 7, 8, 9, 5]
        for i in 0..<graphPoints.count {
            var point = CGPoint(x:columnXPoint(i),
                                y:columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            
            let rect = UIBezierPath(
                rect: CGRect(origin: point,
                             size: CGSize(width: Constants.circleDiameter,
                                          height: point.y - bottomBorder )))
            print("height: \(point.y - bottomBorder)")
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


