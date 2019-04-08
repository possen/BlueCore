//
//  BlueCore.swift
//  SpiderBot
//
//  Created by Paul Ossenbruggen on 3/30/19.
//  Copyright © 2019 Paul Ossenbruggen. All rights reserved.
//

import Foundation
import CoreBluetooth

public class CentralManager: NSObject, CBCentralManagerDelegate {
    private let manager: CBCentralManager
    public var stateChange: ((CBManagerState) -> Void)? = nil
    public var peripheralsUpdated: (() -> Void)? = nil

    public var peripherals: [UUID: Peripheral] = [:] {
        didSet {
            peripheralsUpdated?()
        }
    }

    public init(queue: DispatchQueue? = nil) {
        manager = CBCentralManager(delegate: nil, queue: queue)
        super.init()
        manager.delegate = self
    }

    public func scanForPeripherals(
        withServices services: [CBUUID]?,
        options: [String: Any]? = nil
    ) {
        manager.scanForPeripherals(withServices: services, options: options)
    }

    public func connect(peripheral: Peripheral, options: [String: Any]? = nil) {
        manager.connect(peripheral.peripheral, options: options)
        peripheralsUpdated?()
    }

    public func cancel(peripheral: Peripheral) {
        manager.cancelPeripheralConnection(peripheral.peripheral)
    }

    public func centralManager(
        _ central: CBCentralManager,
        didFailToConnect peripheral: CBPeripheral,
        error: Error?
    ) {
        let peripheral = peripherals[peripheral.identifier]
        print(peripheral ?? "peripheral not found", error ?? "no error")
    }

    public func centralManager(
        _ central: CBCentralManager,
        didConnect peripheral: CBPeripheral
    ) {
        if let peripheral = peripherals[peripheral.identifier] {
            peripheralsUpdated?()
            peripheral.discoverServices()
            peripheral.peripheralsUpdated = {
                self.peripheralsUpdated?()
            }
        }
    }

    public func centralManager(
        _ central: CBCentralManager,
        didDisconnectPeripheral peripheral: CBPeripheral,
        error: Error?
    ) {
        peripheralsUpdated?()
    }

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        stateChange?(central.state)
    }

    public func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String: Any],
        rssi RSSI: NSNumber
    ) {
        peripherals[peripheral.identifier] = Peripheral(
            peripheral: peripheral,
            advertisementData: advertisementData,
            RSSI: RSSI.intValue
        )
    }
}

public class Peripheral: NSObject, CBPeripheralDelegate {
    let peripheral: CBPeripheral
    var characteristics: [Characteristic] = []
    var descriptors: [Descriptor] = []
    var services: [Service] = []
    var peripheralsUpdated: (() -> Void)? = nil
    let advertisementData: [String: Any]
    let RSSI: Int

    init(
        peripheral: CBPeripheral,
        advertisementData: [String: Any],
        RSSI: Int
    ) {
        self.peripheral = peripheral
        self.advertisementData = advertisementData
        self.RSSI = RSSI
        super.init()
        peripheral.delegate = self
    }

    func connectState() -> CBPeripheralState {
        return peripheral.state
    }

    func discoverServices() {
        peripheral.discoverServices(nil)
    }

    func discoverCharacteristics(for service: Service) {
        peripheral.discoverCharacteristics(nil, for: service.service)
    }

    func discoverDescriptors(for characteristics: Characteristic) {
        peripheral.discoverDescriptors(for: characteristics.characteristic)
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print(peripheral, error ?? "success")
        services = peripheral.services?.map { Service(service: $0 )} ?? []
        peripheralsUpdated?()
    }

    public func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverDescriptorsFor characteristic: CBCharacteristic,
        error: Error?
    ) {
        descriptors = characteristic.descriptors?.map { Descriptor(descriptor: $0) } ?? []
        print("descriptors", characteristic.descriptors?.map { $0.uuid.description } ?? "no descriptor")
        peripheralsUpdated?()
    }

    public func peripheral(
        _ peripheral: CBPeripheral,
        didDiscoverCharacteristicsFor service: CBService,
        error: Error?
    ) {
        characteristics = service.characteristics?.map { Characteristic(characteristic: $0) } ?? []
        print("characteristic", service.characteristics?.map { $0.uuid.description } ?? "no characteristic")
        peripheralsUpdated?()
    }
}

class Service: NSObject {
    let service: CBService

    init(service: CBService) {
        self.service = service
    }
}

class Characteristic: NSObject {
    let characteristic: CBCharacteristic

    init(characteristic: CBCharacteristic) {
        self.characteristic = characteristic
    }
}

class Descriptor: NSObject {
    let descriptor: CBDescriptor

    init(descriptor: CBDescriptor) {
        self.descriptor = descriptor
    }
}
