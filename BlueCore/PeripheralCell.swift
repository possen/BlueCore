//
//  PeripheralCell.swift
//  SpiderBot
//
//  Created by Paul Ossenbruggen on 3/31/19.
//  Copyright © 2019 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class PeripheralCell: UITableViewCell {

    override func prepareForReuse() {
        textLabel?.text = nil
         self.accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    }
    
    var model: Peripheral? = nil {
        didSet(newValue) {
            self.textLabel?.text = newValue?.peripheral.name ?? "Unknown"
            if let state = newValue?.connectState() {
                let result: UIColor
                switch state {
                case .connected: result = UIColor.green
                case .connecting: result = UIColor.blue
                case .disconnected: result = UIColor.red
                case .disconnecting: result = UIColor.purple
                @unknown default:
                    fatalError()
                }
                self.accessoryView?.backgroundColor = result
            }
        }
    }
}
