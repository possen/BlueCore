//
//  AdvertisementCell
//  BlueCore
//
//  Created by Paul Ossenbruggen on 4/7/19.
//  Copyright © 2019 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class AdvertisementCell: UITableViewCell {

    override func prepareForReuse() {
        textLabel?.text = nil
    }

    func displayValueString(value: Any?) -> String {
        return "\(value ?? "none")"
    }

    func displayKeyString(key: String) -> String {
        return Advertisement.advertisementDiscriptionKeys[key] ?? "no key"
    }

    var model: Advertisement? = nil {
        didSet(newValue) {
            textLabel?.text = displayKeyString(key: newValue?.key ?? "none")
                + ": " + displayValueString(value: newValue?.value)
        }
    }
}
