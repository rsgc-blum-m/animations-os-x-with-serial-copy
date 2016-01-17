//
//  ViewController.swift
//  Animation
//
//  Created by Russell Gordon on 2015-12-05.
//  Copyright © 2015 Royal St. George's College. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var timer = NSTimer()
    var sketch = Sketch()
    
    @IBOutlet var myView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tell OS that we want a layer to display an image on
        self.view.wantsLayer = true
        
        // Initialize the timer used to drive the sketch
        timer = NSTimer.scheduledTimerWithTimeInterval(1/Double(sketch.canvas.framesPerSecond), target: self, selector: Selector("timedDraw"), userInfo: nil, repeats: true)
        
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        
        // Before the view appears, resize to match the size of the canvas we are painting on
        // See: http://stackoverflow.com/questions/27578085/resizing-window-to-view-controller-size-in-storyboard
        preferredContentSize = NSSize(width: sketch.canvas.width, height: sketch.canvas.height)
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func timedDraw() {
        
        // Call the draw() method on the Sketch object
        sketch.draw()
        
        // Increment the frame count for the current canvas of the sketch
        sketch.canvas.frameCount += 1
        
        // Get a Core Graphics representation of the current image on the canvas
        // and set it to the backing layer of the NSView object tied to the
        // view controller
        var imageRect : NSRect = NSMakeRect(0, 0, CGFloat(sketch.canvas.width), CGFloat(sketch.canvas.height))
        self.view.layer!.contents = sketch.canvas.imageView.image?.CGImageForProposedRect(&imageRect, context: NSGraphicsContext.currentContext(), hints: nil)
        
        
    }
    
    
}

