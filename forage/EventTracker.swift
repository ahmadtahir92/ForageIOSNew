//
//  EventTracker.swift
//  forage
//
//  Created by vamsi valluri on 2/21/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//
import Foundation

class EventTracker {
    static var send_parse: Bool  = true;
    var eventHmap = [String: EventSample]()
    
    // Location
    func setLocation(s: String) {
    // Set location - GPS co-ordinates
    }
    
    func getLocation(s: String) {
    // Get location - GPS co-ordinates
    }
    
    // Event timestamps
    func setEventStartTime(metricName: String) {
        if let s1 = eventHmap[metricName] {
            let currentDate = Date().timeIntervalSince1970
            s1.startTime = Int64(currentDate)
        }
    }
    
    func setEventStopTime(metricName: String) {
        if let s1 = eventHmap[metricName] {
            let currentDate = Date().timeIntervalSince1970
            s1.stopTime = Int64(currentDate)
        }
    }
    
    
    /************************* Tracking Events Batch Processing ********************************/
    // Add events for batch processing
    func addEvent(metricName: String, type: String, seriesName: String, value: Double,
                  fields: [String: Any], tags: [String: Any]) {
        // Create the Event sample and add to hashmap
        let s1 = EventSample(name: seriesName, type: type, value: value, tagKVs: tags, fieldKVs: fields)
        eventHmap[metricName] = s1
    }
    
    
    /************************* Tracking Events Single Processing ********************************/
    
    // Farm Events
    func trackFarmEvent(inv: Inventory) {
        var fields = [String: Any]()
        var tags = [String: Any]()
        
        fields["itemPrice"] =  inv.rate
        fields["itemTotAvail"] = inv.totalAvailable
        tags["farmName"] = inv.farmName
        tags["itemName"] = inv.name
        tags["itemUnit"] = inv.unit
        sendEvent(metricName: Constants.FARM_INV_ITEM, type: Constants.ATYPE_TIMESERIES, seriesName: Constants.FARM_ITEM_TRACKER, value: 0, fields: fields, tags: tags, tsDate: inv.updatedAt);
    }
    
    // Order Events
    func trackOrderEvent(order: Order) {
        var fields = [String: Any]()
        let tags = [String: Any]()
        
        fields[Constants.ORDER_ID_STR] = order.getOrderId()
        sendEvent(metricName: Constants.HOME_ORDER_ITEM, type: Constants.ATYPE_TIMESERIES, seriesName: Constants.HOME_ORDER_ITEM_TRACKER, value: 0, fields: fields, tags: tags, tsDate:order.updatedAt);
    }
    
    // User events
    func trackUserEvent(userType: Int, event: String, user: User) {
        var tags = [String: Any]()
        let fields = [String: Any]()
        var userTypeStr: String
        var idStr: String
    
        switch (userType) {
        case UserType.HOMEOWNER_USER:
            userTypeStr = Constants.HOME_USER_EVENT
            idStr = user.homeId!
            break
        case UserType.FARMER_USER:
            userTypeStr = Constants.FARM_USER_EVENT
            idStr = user.farmId!
            break
        case UserType.COURIER_USER:
            userTypeStr = Constants.COURIER_USER_EVENT
            idStr = user.courierId!
            break
        default:
            userTypeStr = "unknown"
            idStr = "unknown"
        }
        tags["userType"] =  userTypeStr
        tags["userName"] =  user.name
        tags["userId"] =  idStr
        tags["event"] =  event
        
        sendEvent(metricName: userTypeStr, type: Constants.ATYPE_TIMESERIES, seriesName: Constants.USER_EVENT_TRACKER, value: 0, fields: fields, tags: tags, tsDate: nil);
    }
    
    // Screen Events
    func trackScreenEvent(screenType: String) {
        var tags = [String: Any]()
        let fields = [String: Any]()
    
        tags["screen"] = screenType
        tags["userName"] = User.getCurrentUser().name
        
        var userTypeStr: String
        var idStr: String
        
        switch (User.getCurrentUser().userType) {
        case UserType.HOMEOWNER_USER:
            userTypeStr = Constants.HOME_USER_EVENT
            idStr = User.getCurrentUser().homeId!
            break
        case UserType.FARMER_USER:
            userTypeStr = Constants.FARM_USER_EVENT
            idStr = User.getCurrentUser().farmId!
            break
        case UserType.COURIER_USER:
            userTypeStr = Constants.COURIER_USER_EVENT
            idStr = User.getCurrentUser().courierId!
            break
        default:
            userTypeStr = "unknown"
            idStr = "unknown"
        }
    
        tags["userType"] = userTypeStr
        tags["userId"] = idStr
        sendEvent(metricName: screenType, type: Constants.ATYPE_TIMESERIES, seriesName: Constants.SCREEN_EVENT_TRACKER, value: 0, fields: fields, tags: tags, tsDate: nil);
    }
    
    /************************* Send Events Processing ********************************/
    
    func sendEvent(metricName: String, type: String,  seriesName: String, value: Double,
                   fields: [String: Any], tags: [String: Any], tsDate: Date?) {
        // Create the Event sample item
        let s1 = EventSample(name: seriesName, type: type, value: value, tagKVs: tags, fieldKVs: fields)
        sendOne(seriesName: seriesName, type: type, sample: s1, date: tsDate)
    }
    
    //func synchronized sendOne(seriesName: String, type: String, sample: EventSample, date: Date?) {
    func sendOne(seriesName: String, type: String, sample: EventSample, date: Date?) {
        var fields = [String: Any]()
        var tags = [String: Any]()
        
        if (EventTracker.send_parse) {
            fields = sample.fieldKVs;
            tags = sample.tagKVs;
        } else {
            return;
        }
    
        // Get Event timestamp!
        var time: UInt64
        if let indate = date {
            time = UInt64(indate.timeIntervalSince1970 * 1000)
        } else {
            time = UInt64(Date().timeIntervalSince1970 * 1000)
        }
        // Convert to nanoseconds
        time = time*1000000
        
        // Post to cloud DB
        send(type: type, series: seriesName, fields: fields, tags: tags, timestamp: time, sb: nil);
    }
    
    func sendAll() {
        for (_, value) in eventHmap {
            sendOne(seriesName: value.name, type: value.type, sample: value, date: nil)
        }
    }
    
    // Send to Cloud
    func send(type: String, series: String, fields: [String: Any], tags: [String: Any],
              timestamp: UInt64, sb: String?) {
        if (EventTracker.send_parse) {
            ParseCloudFunctions.trackingEventPost(type: type, series: series, fieldList: fields, taglist: tags, timeStamp: timestamp, sb: sb);
        }
    }
}
