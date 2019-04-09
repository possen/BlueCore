//
//  ServiceViewController.swift
//  SpiderBot
//
//  Created by Paul Ossenbruggen on 4/7/19.
//  Copyright © 2019 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class ServiceViewController: UITableViewController {
    var adaptor: TableViewAdaptor!
    var central: CentralManager! = nil
    var peripheral: Peripheral? = nil
    var service: Service? = nil

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        central.peripheralsUpdated = { [unowned self] in
            self.tableView.reloadData()
        }
        title = service?.service.uuid.description
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let characteristicsSection = TableViewAdaptorSection<CharacteristicCell>(
            cellReuseIdentifier: "CharacteristicCell",
            title: "Characteristics",
            count: { self.peripheral?.characteristics.count ?? 0 },
            select: nil)
        { (cell, index) in
            cell.model = self.peripheral?.characteristics[index]
        }
        adaptor = TableViewAdaptor(tableView: tableView, sections: [characteristicsSection])
        if let peripheral = peripheral {
            central.connect(peripheral: peripheral)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CharacteristicViewController {
            destination.central = central
            destination.peripheral = peripheral
            if let cell = sender as? CharacteristicCell {
                if let characteristic = cell.model {
                    peripheral?.discoverDescriptors(for: characteristic)
                    destination.characteristics = characteristic
                }
            }
        }
    }
}
