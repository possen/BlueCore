//
//  DescriptorCell.swift
//  SpiderBot
//
//  Created by Paul Ossenbruggen on 4/6/19.
//  Copyright © 2019 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class DescriptorCell: UITableViewCell {

    override func prepareForReuse() {
        textLabel?.text = nil
    }

    var model: Descriptor? = nil {
        didSet(newValue) {
            self.textLabel?.text = model?.descriptor.uuid.description
        }
    }
}
