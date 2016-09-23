//
//  ViewController.swift
//  HealthKitHelper
//
//  Created by Finn Gaida on 23.09.16.
//  Copyright © 2016 Finn Gaida. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    typealias HKDict = Dictionary<HKSampleType, Array<HKSample>>
    
    let store = HKHealthStore()
    var data: HKDict = HKDict()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func file() -> String {
        let manager = FileManager.default
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/data.healthexport")
        
        if !manager.fileExists(atPath: path) {
            manager.createFile(atPath: path, contents: nil, attributes: nil)
        }
        
        return path
    }
    
    func importData(_ data: Data) {
        
        let unarchive = NSKeyedUnarchiver.unarchiveObject(with: data)
        
        guard let cast = unarchive as? HKDict else { print("cast failed"); return }
        
        store.requestAuthorization(toShare: Helper.sharedHelper.dataTypes(forReading: false), read: nil) { (success, error) in
            if let e = error {
                print("there was an error : \(e)")
            } else {
                print("success")
                
                cast.forEach({ (key: HKSampleType, value: Array<HKSample>) in
                    print("saving \(key)")
                    self.store.save(value, withCompletion: { (success, error) in
                        if let e = error { print("couldn't save: \(e)") }
                    })
                })
            }
        }
    }
    
    @IBAction func export(_ sender: AnyObject) {
        
        if HKHealthStore.isHealthDataAvailable() {
            store.requestAuthorization(toShare: nil, read: Helper.sharedHelper.dataTypes(forReading: true), completion: { (success, error) in
                if let e = error {
                    print("there was an error : \(e)")
                } else {
                    print("success")
                    
                    let arrays: Array<[HKSampleType]> = [Helper.sharedHelper.quantityTypes, Helper.sharedHelper.categoryTypes, Helper.sharedHelper.correlationTypes, Helper.sharedHelper.workoutTypes]
                    for (_, types) in arrays.enumerated() {
                        
                        for (_, type) in types.enumerated() {
                            
                            let start = NSDate.distantPast
                            let end = NSDate.distantFuture
                            let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: [])
                            
                            self.store.execute(HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil, resultsHandler: { (query, samples, error) in
                                
                                if let samples = samples as? [HKQuantitySample] {
                                    
                                    self.data[type] = samples
                                }
                            }))
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { 
                        
                        let archive = NSKeyedArchiver.archivedData(withRootObject: self.data)
                        
                        do {
                            
                            let path = self.file()
                            try archive.write(to: URL(fileURLWithPath: path), options: Data.WritingOptions.atomicWrite)
                            
                            let vc = UIActivityViewController(activityItems: [URL(fileURLWithPath: path)], applicationActivities: nil)
                            self.present(vc, animated: true, completion: nil)
                        } catch {
                            
                        }
                    })
                    
                }
            })
        } else {
            
            let alert = UIAlertController(title: "Oops", message: "Looks like you don't have any data in your health app. Please make sure you have enough data available and granted all neccessary permissions to HealthPad in order to sync your Data.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

