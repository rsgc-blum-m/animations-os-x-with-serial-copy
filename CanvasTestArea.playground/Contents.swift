//: Playground - noun: a place where people can play

import Cocoa

/*:

Use this Playground to experiment with the Canvas class.

Have fun!

*/

// Create a new canvas
let canvas = Canvas(width: 500, height: 500)

// Draw a circle at the origin with radius of 50 pixels
canvas.drawEllipse(centreX: 0, centreY: 0, width: 50, height: 50)

// View the current state of the canvas
canvas

// Draw an ellipse no fill in the middle of the canvas
canvas.drawShapesWithFill = false
canvas.drawEllipse(centreX: canvas.width/2, centreY: canvas.height/2, width: 50, height: 100)

// View the current state of the canvas
canvas

// Draw a rectangle with red fill and thick green border in bottom left corner of canvas
canvas.fillColor = Color(hue: 0, saturation: 80, brightness: 90, alpha: 100)
canvas.drawShapesWithFill = true
canvas.borderColor = Color(hue: 120, saturation: 80, brightness: 40, alpha: 100)
canvas.drawShapesWithBorders = true
canvas.drawRectangle(bottomRightX: canvas.width - 55, bottomRightY: 5, width: 50, height: 50, borderWidth: 5)

// View the current state of the canvas
canvas

// Draw a horizontal line at the top of the canvas
canvas.drawLine(fromX: 100, fromY: 400, toX: canvas.width - 100, toY: 400)

// View the current state of the canvas
canvas

// Draw a "fan" of lines with increasing thickness across bottom of canvas
for i in -5...5 {
    
    // Change hue to traverse spectrum
    let hue : Float = (Float(i) + 5) * (360 / 10)
    
    // Set line color
    canvas.lineColor = Color(hue: hue, saturation: 80, brightness: 90, alpha: 100)
    
    // Draw the line
    canvas.drawLine(fromX: canvas.width / 2, fromY: 50, toX: canvas.width / 2 + i*50, toY: 150, lineWidth: i)
}

// View the current state of the canvas
canvas


