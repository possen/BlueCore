//
//  ServiceCell.swift
//  SpiderBot
//
//  Created by Paul Ossenbruggen on 4/7/19.
//  Copyright © 2019 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class ServiceCell: UITableViewCell {

    override func prepareForReuse() {
        textLabel?.text = nil
    }

    var model: Service? = nil {
        didSet(newValue) {
            self.textLabel?.text = model?.service.uuid.description
        }
    }
}
