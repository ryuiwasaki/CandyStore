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

        let regex = try? NSRegularExpression(pattern: "([0-9]*).([0-9]*).([0-9]*)", options: NSRegularExpression.Options.caseInsensitive)
        
        if let matches = regex?.matches(in: version, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSMakeRange(0, version.characters.count)) {
            
            var values = [Int]()
            matches.forEach({ (result) in
                
                for i in 1..<result.numberOfRanges {
                 
                    let range = result.range(at: i)
                    let valueStr = version.substring(with: version.characters.index(version.startIndex, offsetBy: range.location)..<version.characters.index(version.startIndex, offsetBy: NSMaxRange(range)))
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
    
    public func isSameVersion(_ versionString:String) -> Bool {
        
        let infoVersion = "\(majorVersion).\(minorVersion).\(maintenanceVersion)"
        
        return infoVersion == versionString
    }
}

public func == (lhs:ReleaseInfo, rhs:ReleaseInfo) -> Bool {
    
    return (lhs.majorVersion == rhs.majorVersion) && (lhs.minorVersion == rhs.minorVersion) && (lhs.maintenanceVersion == rhs.maintenanceVersion) && (lhs.notes == rhs.notes)
}

open class Manager {
    
    static let sharedInstance = Manager()
    static func defaultManager() -> Manager {
        
        return sharedInstance
    }
    
    var alertTitleFormat : String?
    var releaseInfo : ReleaseInfo?
    
    func resetReleaseInfo() {
        
        UserDefaults.standard.removeObject(forKey: "ReleaseInfo_MajorVersion")
        UserDefaults.standard.removeObject(forKey: "ReleaseInfo_MinorVersion")
        UserDefaults.standard.removeObject(forKey: "ReleaseInfo_MaintenanceVersion")
        UserDefaults.standard.removeObject(forKey: "ReleaseInfo_Notes")
        UserDefaults.standard.synchronize()
    }
    
    func alreadyHasShow() -> Bool {
        
        return latestReleaseInfo() != nil && latestReleaseInfo() == releaseInfo
    }
    
    
    func latestReleaseInfo() -> ReleaseInfo? {
        
        let majorVersion = UserDefaults.standard.integer(forKey: "ReleaseInfo_MajorVersion")
        let minorVersion = UserDefaults.standard.integer(forKey: "ReleaseInfo_MinorVersion")
        let maintenanceVersion = UserDefaults.standard.integer(forKey: "ReleaseInfo_MaintenanceVersion")
        
        guard let notes = UserDefaults.standard.string(forKey: "ReleaseInfo_Notes") else { return nil }
        
        return ReleaseInfo(majorVersion: majorVersion, minorVersion: minorVersion, maintenanceVersion: maintenanceVersion, notes: notes)
    }
    
    func storeReleaseInfo() {
        
        guard let releaseInfo = releaseInfo else { return }
        UserDefaults.standard.set(releaseInfo.majorVersion, forKey: "ReleaseInfo_MajorVersion")
        UserDefaults.standard.set(releaseInfo.minorVersion, forKey: "ReleaseInfo_MinorVersion")
        UserDefaults.standard.set(releaseInfo.maintenanceVersion, forKey: "ReleaseInfo_MaintenanceVersion")
        UserDefaults.standard.set(releaseInfo.notes, forKey: "ReleaseInfo_Notes")
        UserDefaults.standard.synchronize()
    }
    
    func showInfoIfNeededInViewController(_ vc:UIViewController){
        
        if alreadyHasShow() {
            
        } else {
            
            if let info = releaseInfo {
                
                let format = alertTitleFormat ?? NSLocalizedString("Ver. %@ release notes", tableName: "ReleaseLocalized", comment: "")
                let alert = UIAlertController(title: String(format: format, info.version ), message: info.notes, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                    self.storeReleaseInfo()
                }))
                
                vc.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}
