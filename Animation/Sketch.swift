//
//  Sketch.swift
//  Animation
//
//  Created by Russell Gordon on 2015-12-05.
//  Copyright © 2015 Royal St. George's College. All rights reserved.
//

import Foundation
import Darwin

// NOTE: The Sketch class will define the methods required by the ORSSerialPortDelegate protocol
//
// “A protocol defines a blueprint of methods, properties, and other requirements that suit a 
// particular task or piece of functionality.”
//
// Excerpt From: Apple Inc. “The Swift Programming Language (Swift 2).” iBooks. https://itun.es/ca/jEUH0.l
//
// In this case, the Sketch class implements methods that allow us to read and use the serial port, via
// the ORSSerialPort library.
class Sketch : NSObject, ORSSerialPortDelegate {

    // NOTE: Every sketch must contain an object of type Canvas named 'canvas'
    //       Therefore, the line immediately below must always be present.
    let canvas : Canvas
    
    // Declare any properties you need for your sketch below this comment, but before init()
    var serialPort : ORSSerialPort?       // Object required to read serial port
    var serialBuffer : String = ""
    var x = 0   // Horizontal position for the circle appearing on screen
    var y = 0   // Vertical position for the circle appearing on screen
    var r = 300 // Radius
    var s = 1 // Horizontal position changer
    var width = 250
    

    // This runs once, equivalent to setup() in Processing
    override init() {
        
        // Create canvas object – specify size
        canvas = Canvas(width: 500, height: 650)
        
        // The frame rate can be adjusted; the default is 60 fps
        canvas.framesPerSecond = 60

        // Call superclass initializer
        super.init()
        
        // Find and list available ports
        var availablePorts = ORSSerialPortManager.sharedSerialPortManager().availablePorts
        if availablePorts.count == 0 {
            
            // Show error message if no ports found
            print("No connected serial ports found. Please connect your USB to serial adapter(s) and run the program again.\n")
            exit(EXIT_SUCCESS)
            
        } else {
            
            // List available ports in debug window (view this and adjust
            print("Available ports are...")
            for (i, port) in availablePorts.enumerate() {
                print("\(i). \(port.name)")
            }
            
            // Open the desired port
            serialPort = availablePorts[0]  // selecting first item in list of available ports
            serialPort!.baudRate = 9600
            serialPort!.delegate = self
            serialPort!.open()
            
        }
        
        
        
    }
    
    // Runs repeatedly, equivalent to draw() in Processing
    func draw() {
        
        canvas.drawShapesWithBorders = false
        canvas.fillColor = Color(hue: 0, saturation: 0, brightness: 100, alpha: 90)
        canvas.drawRectangle(bottomRightX: 0, bottomRightY: 0, width: canvas.width, height: canvas.height)
        
        //Larger Trapezoid
        canvas.drawShapesWithBorders = false
        canvas.fillColor = Color(hue: 50, saturation: 80, brightness: 90, alpha: 100)
        canvas.drawLine(fromX: 25, fromY: 25, toX: canvas.width-25, toY: 25)
        canvas.drawLine(fromX: 25, fromY: 25, toX: 100, toY: canvas.height - 25)
        canvas.drawLine(fromX: canvas.width - 25, fromY: 25, toX: canvas.width-100, toY: canvas.height - 25)
        canvas.drawLine(fromX: canvas.width-100, fromY: canvas.height - 25, toX: 100, toY: canvas.height - 25)
        
        //Smaller Trapezoid
        canvas.drawShapesWithBorders = false
        canvas.drawLine(fromX: 50, fromY: 50, toX: canvas.width-50, toY: 50)
        canvas.drawLine(fromX: 50, fromY: 50, toX: 125, toY: canvas.height - 50)
        canvas.drawLine(fromX: canvas.width - 50, fromY: 50, toX: canvas.width-125, toY: canvas.height - 50)
        canvas.drawLine(fromX: canvas.width-125, fromY: canvas.height - 50, toX: 125  , toY: canvas.height - 50)
        
        //Filled Trapezoid
        canvas.drawShapesWithBorders = false
        canvas.fillColor = Color(hue: 50, saturation: 80, brightness: 90, alpha: 100)
        canvas.drawLine(fromX: 50, fromY: 50, toX: canvas.width-50, toY: 50)
        canvas.drawLine(fromX: 50, fromY: 50, toX: 73, toY: 208)
        canvas.drawLine(fromX: canvas.width - 50, fromY: 50, toX: canvas.width-73, toY: 208)
        canvas.drawLine(fromX: canvas.width - 75, fromY: 208, toX: 75  , toY: 208)
        
        width = width + s*20
    
        if (width >= canvas.width/2 + x || width <= canvas.width/2 - x) {
            s *= -1
            canvas.fillColor = Color(hue: 135, saturation: 100, brightness: 100, alpha: 100)
            canvas.drawRectangle(bottomRightX: 25, bottomRightY: 550, width: 50, height: 50, borderWidth: 10)
        }
        
        var arccos = acos(Float((width-(canvas.width/2))/r))
        var y = Float(r)*sin(arccos*Float(180/M_PI))
    
        canvas.drawLine(fromX: canvas.width/2, fromY: 208, toX:  width  , toY: Int(y) + 208)
        
    }
    
    // ORSSerialPortDelegate
    // These four methods are required to conform to the ORSSerialPort protocol
    // (Basically, the methods will be invoked when serial port events happen)
    func serialPort(serialPort: ORSSerialPort, didReceiveData data: NSData) {
        
        // Print whatever we receive off the serial port to the console
        if let string = String(data: data, encoding: NSUTF8StringEncoding) {

            // Iterate over all the characters received from the serial port this time
            for chr in string.characters {
                
                // Check for delimiter
                if chr == "|" {
                    
                    // Entire value sent from Arduino board received, assign to
                    // variable that controls the vertical position of the circle on screen
                    x = Int(serialBuffer)!
                    
                    // Reset the string that is the buffer for data received from serial port
                    serialBuffer = ""
                    
                } else {
                    
                    // Have not received all the data yet, append what was received to buffer
                    serialBuffer += String(chr)
                }
                
            }

            // DEBUG: Print what's coming over the serial port
            print("\(string)", terminator: "")
            
        }
        
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    
    func serialPort(serialPort: ORSSerialPort, didEncounterError error: NSError) {
        print("Serial port (\(serialPort)) encountered error: \(error)")
    }
    
    func serialPortWasOpened(serialPort: ORSSerialPort) {
        print("Serial port \(serialPort) was opened")
    }
    
}