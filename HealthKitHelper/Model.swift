//
//  Model.swift
//  HealthPad
//
//  Created by Finn Gaida on 19.03.16.
//  Copyright © 2016 Finn Gaida. All rights reserved.
//

import Foundation

public enum FGColor {
    case Orange
    case Gray
    case Yellow
    case Purple
    case Blue
    case Green
    case Turquoise
}

public enum DataType:String {
    case Weight = "Weight"
    case Sleep = "Sleep"
    case Distance = "Distance"
    case Steps = "Steps"
    case Energy = "Energy"
    case HeartRate = "HeartRate"
    case BloodPressure = "BloodPressure"
    case Generic = "Generic"
}

public struct Day {
    let type:DataType
    var maximumValue:Double
    var minimumValue:Double
    var all:Array<HealthObject>?
}

public struct Weight:HealthObject {
    public var value:Double? = nil
    public var description:String? = ""
    public var unit:Unit? = Unit.kg
    public var date:NSDate? = nil
}

public struct Sleep:HealthObject {
    public var value:Double? = nil
    public var description:String? = ""
    public var unit:Unit? = Unit.hours
    public var date:NSDate? = nil
}

public enum Medium {
    case Pedestrian
    case Bicycle
    case Car
    case Train
    case Plane
}

public struct Distance:HealthObject {
    let medium:Medium? = .Pedestrian
    public var value:Double? = nil
    public var description:String? = ""
    public var unit:Unit? = Unit.km
    public var date:NSDate? = nil
}

public struct Steps:HealthObject {
    public var value:Double? = nil
    public var description:String? = ""
    public var unit:Unit? = Unit.steps
    public var date:NSDate? = nil
}

public struct Energy:HealthObject {
    public var value:Double? = nil
    public var description:String? = ""
    public var unit:Unit? = Unit.kcal
    public var date:NSDate? = nil
}

public struct HeartRateValue {
    let date:NSDate?
    let bpm:Int
}

public struct HeartRate:HealthObject {
    let highestbpm:Int
    let lowestbpm:Int
    let all:[HeartRateValue]?
    public var value:Double? = nil
    public var description:String? = ""
    public var unit:Unit? = Unit.bpm
    public var date:NSDate? = nil
}

public struct BloodPressureValue {
    let systolic:Int
    let diastolic:Int
}

public struct BloodPressure:HealthObject {
    let highest:Int
    let lowest:Int
    let all:[BloodPressureValue]?
    public var value:Double? = nil
    public var description:String? = ""
    public var unit:Unit? = Unit.mmHg
    public var date:NSDate? = nil
}

public struct GeneralHealthObject:HealthObject {
    public var value:Double? = nil
    public var description:String? = ""
    public var unit:Unit?
    public var date:NSDate? = nil
}

public protocol HealthObject {
    var value:Double? {get set}
    var description:String? {get set}
    var unit:Unit? {get set}
    var date:NSDate? {get set}
}

public enum Unit:String {
    case steps = " steps"
    case mmHg = " mmHg"
    case bpm = " bpm"
    case hours = " h"
    case kg = " kg"
    case kcal = " kcal"
    case km = " km"
}