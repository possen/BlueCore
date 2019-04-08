//
//  CharacteristicCell.swift
//  SpiderBot
//
//  Created by Paul Ossenbruggen on 4/2/19.
//  Copyright © 2019 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class CharacteristicCell: UITableViewCell {

    override func prepareForReuse() {
        textLabel?.text = nil
    }

    var model: Characteristic? = nil {
        didSet(newValue) {
            self.textLabel?.text = model?.characteristic.uuid.description
        }
    }
}
