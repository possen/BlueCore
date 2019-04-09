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
        let advertisementSection = TableViewAdaptorSection<AdvertisementCell>(
            cellReuseIdentifier: "AdvertisementCell",
            title: "Advertisement",
            count: { Advertisement.advertisementKeys.count },
            select: nil
        ) { (cell, index) in
            let key = Advertisement.advertisementKeys[index]
            if let peripheral = self.peripheral {
                cell.model = Advertisement(key: key, value: peripheral.advertisementData[key] ?? "no value")
            } else {
                cell.model = Advertisement(key: key, value: "no value")
            }
        }
        adaptor = TableViewAdaptor(tableView: tableView, sections: [servicesSection, advertisementSection])
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
