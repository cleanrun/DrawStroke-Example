//
//  DrawingView.swift
//  DrawStroke-Example
//
//  Created by cleanmac on 10/02/23.
//

import UIKit

final class DrawingView: UIView {
    private var lastPoint: CGPoint!
    private var currentColor: CGColor = UIColor.black.cgColor
    private var strokes = [Stroke]()
    private var lastStrokes = [Stroke]()
    private var lineWidth: CGFloat = 10.0
    private var isDrawing = false
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineCap(.round)
        for stroke in strokes {
            if let lineWidth = stroke.lineWidth {
                context?.setLineWidth(lineWidth)
            }
            context?.beginPath()
            context?.move(to: stroke.startPoint)
            context?.addLine(to: stroke.endPoint)
            context?.setStrokeColor(stroke.color)
            context?.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isDrawing else { return }
        isDrawing = true
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        lastPoint = currentPoint
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawing, let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        if lastPoint == nil {
            return
        }
        
        var stroke = Stroke(startPoint: lastPoint,
                            endPoint: currentPoint,
                            color: currentColor)
        stroke.lineWidth = lineWidth
        strokes.append(stroke)
        lastPoint = currentPoint
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawing else { return }
        isDrawing = false
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        if lastPoint == nil {
            return
        }
        
        let stroke = Stroke(startPoint: lastPoint,
                            endPoint: currentPoint,
                            color: currentColor)
        strokes.append(stroke)
        lastPoint = nil
        setNeedsDisplay()
    }

}
