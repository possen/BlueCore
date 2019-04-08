//
//  CharacteristicViewController.swift
//  SpiderBot
//
//  Created by Paul Ossenbruggen on 4/7/19.
//  Copyright © 2019 Paul Ossenbruggen. All rights reserved.
//

import UIKit


class CharacteristicViewController: UITableViewController {
    var adaptor: TableViewAdaptor!
    var central: CentralManager! = nil
    var peripheral: Peripheral? = nil
    var characteristics: Characteristic? = nil

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        central.peripheralsUpdated = { [unowned self] in
            self.tableView.reloadData()
        }
        title = characteristics?.characteristic.uuid.description
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let descriptorsSection = TableViewAdaptorSection<DescriptorCell>(
            cellReuseIdentifier: "DescriptorCell",
            title: "Descriptors",
            count: { self.peripheral?.descriptors.count ?? 0 },
            select: nil)
        { (cell, index) in
            cell.model = self.peripheral?.descriptors[index]
        }
        adaptor = TableViewAdaptor(tableView: tableView, sections: [descriptorsSection])
        if let peripheral = peripheral {
            central.connect(peripheral: peripheral)
        }
    }
}
