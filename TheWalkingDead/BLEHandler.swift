//
//  BLEHandler.swift
//  TheWalkingDead
//
//  Created by User on 10/12/15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import CoreBluetooth
import UIKit

protocol HeartRateDelegate {
    func updateHeartReate(bpm: Int)
}

class BLEHandler: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var heartRateDelegate: HeartRateDelegate?
    
    private var centralManager: CBCentralManager?
    private var peripheralList = [CBPeripheral]()
    var connectionStatus = [String: Bool]()
    
    private var startScanTimestamp = NSDate()
    
    let devices = ["TICKR RUN 381D"]
    //let devices = ["RHYTHM+"]
    //let devices = ["Wahoo HRM V1.7"]
    
    let heartRateServiceUUID: [CBUUID] = [CBUUID(string: "2A37")]
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let CENTRAL_MANAGER_RESTORE_KEY = "myCentralManagerIdentifier"

    override init() {
        super.init()
        
        // restore key for background tracking
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: CENTRAL_MANAGER_RESTORE_KEY])
        
        
    }
    
    
    /** centralManagerDidUpdateState is a required protocol method.
     *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
     *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
     *  the Central is ready to be used.
     */
    func centralManagerDidUpdateState(central: CBCentralManager) {
        //print("didUpdateState")
        
        switch (central.state) {
        case .Unsupported:
            print("BLE is unsupported")
        case .Unauthorized:
            print("BLE is unauthorized")
        case .Unknown:
            print("BLE is unknown")
        case .Resetting:
            print("BLE is resetting")
        case .PoweredOff:
            print("BLE is powered off")
        case .PoweredOn:
            print("BLE is powered on")
            print("Start Scanning")
            
            
            centralManager!.scanForPeripheralsWithServices(nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(bool: true)])
            
            /*
            if !peripheralList.isEmpty {
                // if there are already peripherals stored, conntect to them
                for p in peripheralList {
                    centralManager!.connectPeripheral(p, options: [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(bool: true)])
                }
            } else {
                // there are no peripherals stored, search for all devices (for 8 seconds) and pick the right ones
                print("scan for all ...")
                startScanTimestamp = NSDate()
                centralManager!.scanForPeripheralsWithServices(nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(bool: true)])
            }
            */
        default:
            print("BLE default")
        }
    }
    
    /** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
     *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
     *  we start the connection process
     */
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
    
        //print("didDiscoverPeripheral \(String(peripheral.name))")
        
        //if startScanTimestamp.timeIntervalSinceNow > -3 {
        if peripheral.name != nil && devices.contains(String(peripheral.name!)) {
                peripheralList.append(peripheral)
                centralManager?.connectPeripheral(peripheral, options: nil)
                centralManager?.stopScan()
                print("scan stopped ...")
            }
        //}

        /*
        if startScanTimestamp.timeIntervalSinceNow > -8 {
            if !peripheralList.contains(peripheral) {
                if peripheral.name != nil && devices.contains(peripheral.name!) {
                    peripheralList.append(peripheral)
                    centralManager?.connectPeripheral(peripheral, options: nil)
                }
            }
        } else {
            centralManager?.stopScan()
            print("scan stopped ...")
        }*/
    }
    
    /** If the connection fails for whatever reason, we need to deal with it.
     */
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Failed to connect to \(peripheral). (\(error!.localizedDescription))")
        
    }
    
    func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject]) {
        print("willRestoreState")
    }
    
    /** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
     */
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Peripheral Connected to \(peripheral.name)")
        
        peripheral.delegate = self
        //peripheral.discoverServices(batteryService) // discover only the battery service
        peripheral.discoverServices(nil)
    }
    
    /** The Transfer Service was discovered
     */
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("didDiscoverServices")
        
        print(peripheral.services)
        
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        // Loop through the newly filled peripheral.services array, just in case there's more than one.
        for service in peripheral.services! as [CBService] {
            peripheral.discoverCharacteristics(nil, forService: service) // discover all characteristics
        }
    }
    
    /** The Transfer characteristic was discovered.
     *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
     */
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("didDiscoverCharacteristicsForService")
        
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        // Again, we loop through the array, just in case.
        for characteristic in service.characteristics! as [CBCharacteristic] {
            //storeBattery(peripheral.name, battery: characteristic.value)
            //peripheral.readRSSI()
            peripheral.setNotifyValue(true, forCharacteristic: characteristic)
        }
        // Once this is complete, we just need to wait for the data to come in.
    }
    
    /** The peripheral letting us know whether our subscribe/unsubscribe happened or not
     */
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("didUpdateNotificationStateForCharacteristic")
        //print("Error changing notification state: \(error?.localizedDescription)")
        
        if (characteristic.value != nil) {
            //storeBattery(peripheral.name, battery: characteristic.value)
        }
        peripheral.readRSSI()
    }
    
    /** This callback lets us know more data has arrived via notification on the characteristic
     */
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        //print("didUpdateValueForCharacteristic")
        
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        //print(characteristic.value)
        
        if let stringFromData = NSString(data: characteristic.value!, encoding: NSUTF8StringEncoding) {
            
            //print(characteristic.value)
            
            let data = characteristic.value
            var values = [UInt8](count:data!.length, repeatedValue:0)
            data!.getBytes(&values, length:data!.length)
            
            if values.count >= 2 && values[1] != 0 {
                //print("\(values[1]) -> \(values)")
                heartRateDelegate?.updateHeartReate(Int(values[1]))
            }
            
            
            /*
            const uint8_t *reportData = [data bytes];
            int bpm = 0;
            
            // only get the value for the heart rate
            if ((reportData[0] & 0x01) == 0)
            {
                bpm = reportData[1];
            }
            else
            {
                bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));
            }
            */
            /*
            let string = characteristic.value!.description.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "<>"))
            let value = strtoul(string, nil, 8)
            print(value)
            */
            //storeBattery(peripheral.name, battery: characteristic.value)
            //peripheral.readRSSI()
        }
        
    }
    
    /** Once the disconnection happens, we need to clean up our local copy of the peripheral
     */
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
       
        print("Peripheral Disconnected")
        /*
        for b in beaconData {
            if b.name == peripheral.name {
                if connectionStatus[b.name] == true {
                    home.beaconUpdate(peripheral.name, radius: "far")
                    if UIApplication.sharedApplication().applicationState != UIApplicationState.Active {
                        NotificationHandler().connectionLostBackground(b.name)
                    } else {
                        NotificationHandler().connectionLostForeground(b.name)
                    }
                    appDelegate.beaconHandler?.beaconConnectionStatus[b.name] = 1
                    NSNotificationCenter.defaultCenter().postNotificationName(BeaconHandler().STATE_CHANGED, object: nil, userInfo: [b.name : false])
                }
                connectionStatus[b.name] = false
            }
        }
        */
        
        // We're disconnected, so start scanning again
        print("Start Scanning again")
        for p in peripheralList {
            // try to connect to peripherals
            centralManager!.connectPeripheral(p, options: [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(bool: true)])
        }
    }
}