//
//  Manager.swift
//  Pods
//
//  Created by Ryu Iwasaki on 2016/05/22.
//
//

import Foundation


/**
 Validation regix = ([0-9]*).([0-9]*).([0-9]*)
 */

public struct ReleaseInfo : Equatable {
    
    public let majorVersion : Int
    public let minorVersion : Int
    public let maintenanceVersion : Int
    public let notes : String
    
    var version : String {
        return "\(majorVersion).\(minorVersion).\(maintenanceVersion)"
    }
    
    public init(majorVersion: Int, minorVersion: Int, maintenanceVersion: Int, notes: String) {
        
        self.majorVersion = majorVersion
        self.minorVersion = minorVersion
        self.maintenanceVersion = maintenanceVersion
        self.notes = notes
    }
    
    /**
     initializer
     - parameter version: Formatted text major number and minor number and maintenance number. e.g, 1.0.1
     - parameter note: release notes.
     
     */
    public init?(version:String, notes:String) {

        let regex = try? NSRegularExpression(pattern: "([0-9]*).([0-9]*).([0-9]*)", options: NSRegularExpressionOptions.CaseInsensitive)
        
        if let matches = regex?.matchesInString(version, options: NSMatchingOptions.WithTransparentBounds, range: NSMakeRange(0, version.characters.count)) {
            
            var values = [Int]()
            matches.forEach({ (result) in
                
                for i in 1..<result.numberOfRanges {
                 
                    let range = result.rangeAtIndex(i)
                    let valueStr = version.substringWithRange(version.startIndex.advancedBy(range.location)..<version.startIndex.advancedBy(NSMaxRange(range)))
                    if let value = Int(valueStr) {
                        values.append(value)
                    }
                }
            })
            
            if values.count == 3 {
             
                let m = values[0]
                let mi = values[1]
                let ma = values[2]
                self.init(majorVersion:m , minorVersion: mi, maintenanceVersion: ma, notes: notes)
                return
                
            } else {
                
                return nil
            }
            
        } else {
            
           return nil
        }
    }
    
    public func isSameVersion(versionString:String) -> Bool {
        
        let infoVersion = "\(majorVersion).\(minorVersion).\(maintenanceVersion)"
        
        return infoVersion == versionString
    }
}

public func == (lhs:ReleaseInfo, rhs:ReleaseInfo) -> Bool {
    
    return (lhs.majorVersion == rhs.majorVersion) && (lhs.minorVersion == rhs.minorVersion) && (lhs.maintenanceVersion == rhs.maintenanceVersion) && (lhs.notes == rhs.notes)
}

public class Manager {
    
    static let sharedInstance = Manager()
    static func defaultManager() -> Manager {
        
        return sharedInstance
    }
    
    var alertTitleFormat : String?
    var releaseInfo : ReleaseInfo?
    
    func resetReleaseInfo() {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("ReleaseInfo_MajorVersion")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("ReleaseInfo_MinorVersion")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("ReleaseInfo_MaintenanceVersion")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("ReleaseInfo_Notes")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func alreadyHasShow() -> Bool {
        
        return latestReleaseInfo() != nil && latestReleaseInfo() == releaseInfo
    }
    
    
    func latestReleaseInfo() -> ReleaseInfo? {
        
        let majorVersion = NSUserDefaults.standardUserDefaults().integerForKey("ReleaseInfo_MajorVersion")
        let minorVersion = NSUserDefaults.standardUserDefaults().integerForKey("ReleaseInfo_MinorVersion")
        let maintenanceVersion = NSUserDefaults.standardUserDefaults().integerForKey("ReleaseInfo_MaintenanceVersion")
        
        guard let notes = NSUserDefaults.standardUserDefaults().stringForKey("ReleaseInfo_Notes") else { return nil }
        
        return ReleaseInfo(majorVersion: majorVersion, minorVersion: minorVersion, maintenanceVersion: maintenanceVersion, notes: notes)
    }
    
    func storeReleaseInfo() {
        
        guard let releaseInfo = releaseInfo else { return }
        NSUserDefaults.standardUserDefaults().setInteger(releaseInfo.majorVersion, forKey: "ReleaseInfo_MajorVersion")
        NSUserDefaults.standardUserDefaults().setInteger(releaseInfo.minorVersion, forKey: "ReleaseInfo_MinorVersion")
        NSUserDefaults.standardUserDefaults().setInteger(releaseInfo.maintenanceVersion, forKey: "ReleaseInfo_MaintenanceVersion")
        NSUserDefaults.standardUserDefaults().setObject(releaseInfo.notes, forKey: "ReleaseInfo_Notes")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func showInfoIfNeededInViewController(vc:UIViewController){
        
        if alreadyHasShow() {
            
        } else {
            
            if let info = releaseInfo {
                
                let format = alertTitleFormat ?? NSLocalizedString("Ver. %@ release notes", tableName: "ReleaseLocalized", comment: "")
                let alert = UIAlertController(title: String(format: format, info.version ?? ""), message: info.notes, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) in
                    self.storeReleaseInfo()
                }))
                
                vc.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
    }
}
