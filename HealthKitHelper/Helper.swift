//
//  Helper.swift
//  HealthPad Companion
//
//  Created by Finn Gaida on 16.03.16.
//  Copyright © 2016 Finn Gaida. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

public class Helper: NSObject {
    
    public static let sharedHelper = Helper()
    public var latestData:Dictionary<String,Array<Day>> = Dictionary()
    
    public let typeSelectedNotification = "typeSelectedNotification"
    public let showLineChartSegue = "showLineChart"
    public let showStepsSegue = "showSteps"
    public let showWeightSegue = "showWeight"
    public let showSleepSegue = "showSleep"
    public let showHeartRateSegue = "showHeartRate"
    public let showBloodPressureSegue = "showBloodPressure"
    
    public override init() {
        super.init()
        
    }
    
    public func dataTypes(forReading: Bool) -> Set<HKSampleType> {
        
        var readset:Set<HKSampleType> = Set()
        
        quantityTypes.forEach { (type) -> () in
            readset.insert(type)
        }
        
        categoryTypes.forEach { (type) -> () in
            readset.insert(type)
        }
        
//        characteristicTypes.forEach { (type) -> () in
//            readset.insert(type)
//        }
        
//        correlationTypes.forEach { (type) -> () in
//            readset.insert(type)
//        }
        
        workoutTypes.forEach { (type) -> () in
            readset.insert(type)
        }
        
        if #available(iOS 10, *) {
            readset.insert(HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.pushCount)!)
            readset.insert(HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceSwimming)!)
            readset.insert(HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.swimmingStrokeCount)!)
            readset.insert(HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWheelchair)!)
            readset.insert(HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.mindfulSession)!)
        }
        
        if forReading {
            readset.insert(HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.nikeFuel)!)
            readset.insert(HKSampleType.categoryType(forIdentifier: HKCategoryTypeIdentifier.appleStandHour)!)
        }
        
        return readset
        
    }
    
    public let quantityTypes:[HKQuantityType] = [HKQuantityTypeIdentifier.bodyMassIndex, HKQuantityTypeIdentifier.bodyFatPercentage, HKQuantityTypeIdentifier.height, HKQuantityTypeIdentifier.bodyMass, HKQuantityTypeIdentifier.leanBodyMass, HKQuantityTypeIdentifier.stepCount, HKQuantityTypeIdentifier.distanceWalkingRunning, HKQuantityTypeIdentifier.distanceCycling, HKQuantityTypeIdentifier.basalEnergyBurned, HKQuantityTypeIdentifier.activeEnergyBurned, HKQuantityTypeIdentifier.flightsClimbed/*, HKQuantityTypeIdentifier.nikeFuel*/, HKQuantityTypeIdentifier.heartRate, HKQuantityTypeIdentifier.bodyTemperature, HKQuantityTypeIdentifier.basalBodyTemperature, HKQuantityTypeIdentifier.bloodPressureSystolic, HKQuantityTypeIdentifier.bloodPressureDiastolic, HKQuantityTypeIdentifier.respiratoryRate, HKQuantityTypeIdentifier.oxygenSaturation, HKQuantityTypeIdentifier.peripheralPerfusionIndex, HKQuantityTypeIdentifier.bloodGlucose, HKQuantityTypeIdentifier.numberOfTimesFallen, HKQuantityTypeIdentifier.electrodermalActivity, HKQuantityTypeIdentifier.inhalerUsage, HKQuantityTypeIdentifier.bloodAlcoholContent, HKQuantityTypeIdentifier.forcedVitalCapacity, HKQuantityTypeIdentifier.forcedExpiratoryVolume1, HKQuantityTypeIdentifier.peakExpiratoryFlowRate, HKQuantityTypeIdentifier.dietaryFatTotal, HKQuantityTypeIdentifier.dietaryFatPolyunsaturated, HKQuantityTypeIdentifier.dietaryFatMonounsaturated, HKQuantityTypeIdentifier.dietaryFatSaturated, HKQuantityTypeIdentifier.dietaryCholesterol, HKQuantityTypeIdentifier.dietarySodium, HKQuantityTypeIdentifier.dietaryCarbohydrates, HKQuantityTypeIdentifier.dietaryFiber, HKQuantityTypeIdentifier.dietarySugar, HKQuantityTypeIdentifier.dietaryEnergyConsumed, HKQuantityTypeIdentifier.dietaryProtein, HKQuantityTypeIdentifier.dietaryVitaminA, HKQuantityTypeIdentifier.dietaryVitaminB6, HKQuantityTypeIdentifier.dietaryVitaminB12, HKQuantityTypeIdentifier.dietaryVitaminC, HKQuantityTypeIdentifier.dietaryVitaminD, HKQuantityTypeIdentifier.dietaryVitaminE, HKQuantityTypeIdentifier.dietaryVitaminK, HKQuantityTypeIdentifier.dietaryCalcium, HKQuantityTypeIdentifier.dietaryIron, HKQuantityTypeIdentifier.dietaryThiamin, HKQuantityTypeIdentifier.dietaryRiboflavin, HKQuantityTypeIdentifier.dietaryNiacin, HKQuantityTypeIdentifier.dietaryFolate, HKQuantityTypeIdentifier.dietaryBiotin, HKQuantityTypeIdentifier.dietaryPantothenicAcid, HKQuantityTypeIdentifier.dietaryPhosphorus, HKQuantityTypeIdentifier.dietaryIodine, HKQuantityTypeIdentifier.dietaryMagnesium, HKQuantityTypeIdentifier.dietaryZinc, HKQuantityTypeIdentifier.dietarySelenium, HKQuantityTypeIdentifier.dietaryCopper, HKQuantityTypeIdentifier.dietaryManganese, HKQuantityTypeIdentifier.dietaryChromium, HKQuantityTypeIdentifier.dietaryMolybdenum, HKQuantityTypeIdentifier.dietaryChloride, HKQuantityTypeIdentifier.dietaryPotassium, HKQuantityTypeIdentifier.dietaryCaffeine, HKQuantityTypeIdentifier.dietaryWater, HKQuantityTypeIdentifier.uvExposure].map {HKSampleType.quantityType(forIdentifier: $0)!}
    
    public let categoryTypes:[HKCategoryType] = [HKCategoryTypeIdentifier.sleepAnalysis/*, HKCategoryTypeIdentifier.appleStandHour*/, HKCategoryTypeIdentifier.cervicalMucusQuality, HKCategoryTypeIdentifier.ovulationTestResult, HKCategoryTypeIdentifier.menstrualFlow, HKCategoryTypeIdentifier.intermenstrualBleeding, HKCategoryTypeIdentifier.sexualActivity].map {HKSampleType.categoryType(forIdentifier: $0)!}
    
    public let characteristicTypes:[HKCharacteristicType] = [HKCharacteristicTypeIdentifier.biologicalSex, HKCharacteristicTypeIdentifier.bloodType, HKCharacteristicTypeIdentifier.dateOfBirth, HKCharacteristicTypeIdentifier.fitzpatrickSkinType].map {HKObjectType.characteristicType(forIdentifier: $0)!}
    
    public let correlationTypes:[HKCorrelationType] = [HKCorrelationTypeIdentifier.bloodPressure, HKCorrelationTypeIdentifier.food].map {HKSampleType.correlationType(forIdentifier: $0)!}
    
    @available(iOS 10.0, *)
    public func documentTypes() -> [HKDocumentType] {
        return [HKDocumentTypeIdentifier.CDA].map {HKSampleType.documentType(forIdentifier: $0)!}
    }
    
    public let workoutTypes:[HKWorkoutType] = [HKSampleType.workoutType()]
    
}

