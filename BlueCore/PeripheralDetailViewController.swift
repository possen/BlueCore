//
//  PeripheralDetailViewController.swift
//  SpiderBot
//
//  Created by Paul Ossenbruggen on 4/2/19.
//  Copyright © 2019 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class PeripheralDetailViewController: UITableViewController {
    var adaptor: TableViewAdaptor!
    var central: CentralManager! = nil
    var peripheral: Peripheral! = nil

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        central.peripheralsUpdated = { [unowned self] in
            self.tableView.reloadData()
        }
        title = peripheral.peripheral.name
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let servicesSection = TableViewAdaptorSection<ServiceCell>(
            cellReuseIdentifier: "ServiceCell",
            title: "Services",
            count: { self.peripheral?.services.count ?? 0 },
            select: nil)
        { (cell, index) in
            cell.model = self.peripheral?.services[index]
        }
        adaptor = TableViewAdaptor(tableView: tableView, sections: [servicesSection])
        central.connect(peripheral: peripheral)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ServiceViewController {
            destination.central = central
            destination.peripheral = peripheral
            if let cell = sender as? ServiceCell {
                if let service = cell.model {
                    peripheral?.discoverCharacteristics(for: service)
                    destination.service = cell.model
                }
            }
        }
    }
}
