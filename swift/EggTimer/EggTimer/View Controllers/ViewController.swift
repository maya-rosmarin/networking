//
//  ViewController.swift
//  EggTimer
//
//  Created by Maya Rosmarin on 6/23/21.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var timeLeftField: NSTextField!
    @IBOutlet var eggImageView: NSImageView!
    @IBOutlet var startButton: NSButton!
    @IBOutlet var stopButton: NSButton!
    @IBOutlet var resetButton: NSButton!
    @IBAction func startButtonClicked(_ sender: Any) {
        if eggTimer.isPaused {
            eggTimer.resumeTimer()
        } else {
            eggTimer.duration = 360
            eggTimer.startTimer()
        }
        
        configureButtonsAndMenus()
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        eggTimer.stopTimer()
        
        configureButtonsAndMenus()
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        eggTimer.resetTimer()
        updateDisplay(for: 360)
        
        configureButtonsAndMenus()
    }
    
    @IBAction func startTimerMenuItemSelected(_ sender: Any) {
        startButtonClicked(sender)
    }
    @IBAction func stopTimerMenuItemSelected(_ sender: Any) {
        stopButtonClicked(sender)
    }
    @IBAction func resetTimerMenuItemSelected(_ sender: Any) {
        resetButtonClicked(sender)
    }
    
    var eggTimer = EggTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eggTimer.delegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension ViewController: EggTimerProtocol {
    func timeRemainingOnTimer(_ timer: EggTimer, timeRemaining: TimeInterval) {
        updateDisplay(for: timeRemaining)
    }
    
    func timerHasFinished(_ timer: EggTimer) {
        updateDisplay(for: 0)
        
        configureButtonsAndMenus()
    }
}

extension ViewController {
    func updateDisplay(for timeRemaining: TimeInterval) {
        timeLeftField.stringValue = textToDisplay(for: timeRemaining)
        eggImageView.image = imageToDisplay(for: timeRemaining)
    }
    
    private func textToDisplay(for timeRemaining: TimeInterval) -> String {
        if timeRemaining == 0 {
            return "Done!"
        }
        
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    
    private func imageToDisplay(for timeRemaining: TimeInterval) -> NSImage? {
        let percentageComplete = 100 - (timeRemaining / 360 * 100)
        
        if eggTimer.isStopped {
            let stoppedImageName = (timeRemaining == 0) ? "100" : "stopped"
            return NSImage(named: stoppedImageName)
        }
        
        let imageName: String
        switch percentageComplete {
        case 0 ..< 25:
            imageName = "0"
        case 25 ..< 50:
            imageName = "25"
        case 50 ..< 75:
            imageName = "50"
        case 75 ..< 100:
            imageName = "75"
        default:
            imageName = "100"
        }
        
        return NSImage(named: imageName)
    }
    
    func configureButtonsAndMenus() {
        let enableStart: Bool
        let enableStop: Bool
        let enableReset: Bool
        
        if eggTimer.isStopped {
            enableStart = true
            enableStop = false
            enableReset = false
        } else if eggTimer.isPaused {
            enableStart = true
            enableStop = false
            enableReset = true
        } else {
            enableStart = false
            enableStop = true
            enableReset = false
        }
        
        startButton.isEnabled = enableStart
        stopButton.isEnabled = enableStop
        resetButton.isEnabled = enableReset
        
        if let appDel = NSApplication.shared.delegate as? AppDelegate {
            appDel.enableMenus(start: enableStart, stop: enableStop, reset: enableReset)
        }
    }
}
