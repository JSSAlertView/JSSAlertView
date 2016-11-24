//
//  JSSAlertView+Timer.swift
//  Pods
//
//  Created by Alexey Kuznetsov on 17.11.16.
//
//

import Foundation

extension JSSAlertView {
    
    
    /// Configures and starts timer
    func configureTimer() {
        guard let dateUInt = timeLeft else {
            return
        }
        self.timerLabel.text = stringFromUInt(number: dateUInt)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
    }
    
    ///Updates the timer label every second and close alert when time exceeds
    func updateTimerLabel() {
        guard let timeLeftExists = timeLeft else {
            return
        }
        
        if(timeLeftExists > 0) {
            self.timeLeft! -= 1
            self.timerLabel.text = stringFromUInt(number: timeLeft!)
        } else {
            closeView(false)
        }
    }
    
    //returns the time in readable format
    
    /// Converts UInt to String for displaying it on JSSAlertView
    ///
    /// - Parameter number: time left
    /// - Returns: string to display
    func stringFromUInt(number: UInt) -> String {
    
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"

        let dateComp = NSDateComponents()
        dateComp.second = Int(number)
        
        let date = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)?.date(from: dateComp as DateComponents)
        
        let str = formatter.string(from: date!)
        
        return str
        
    }
}

