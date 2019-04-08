//
//  PeripheralsViewController.swift
//  SpiderBot
//
//  Created by Paul Ossenbruggen on 3/30/19.
//  Copyright © 2019 Paul Ossenbruggen. All rights reserved.
//

import UIKit

class PeripheralsViewController: UITableViewController {
    var adaptor: TableViewAdaptor!
    let central = CentralManager(queue: nil)
    var perhipherals = [Peripheral]()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        central.peripheralsUpdated = { [unowned self] in
            self.perhipherals = Array(self.central.peripherals.values).sorted(by:
                { $0.peripheral.name ?? "Unknown" < $1.peripheral.name ?? "Unknown" })
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bluetooth LE"
        central.stateChange = { [unowned self] state in
            switch state {
            case .poweredOn:
                print("poweredOn")
                self.central.scanForPeripherals(withServices: nil)
            case .unknown:
                print("unknown")
            case .resetting:
                print("resetting")
            case .unsupported:
                print("unsupported")
            case .unauthorized:
                print("unauthorized")
            case .poweredOff:
                print("poweredOff")
            @unknown default:
                print("default")
            }
        }
        let peripheralSection = TableViewAdaptorSection<PeripheralCell>(
            cellReuseIdentifier: "PeripheralCell",
            title: "Devices",
            count: { self.perhipherals.count },
            select: nil
        ) { (cell, index) in
            cell.model = self.perhipherals[index]
        }

        adaptor = TableViewAdaptor(tableView: tableView, sections: [peripheralSection])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PeripheralDetailViewController {
            destination.central = central
            if let cell = sender as? PeripheralCell {
                destination.peripheral = cell.model
            }
        }
    }
}

