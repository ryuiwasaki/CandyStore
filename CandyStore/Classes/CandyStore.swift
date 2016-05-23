//
//  CandyStore.swift
//  Pods
//
//  Created by Ryu Iwasaki on 2016/05/22.
//
//

import Foundation

public func setReleaseInfo(releaseInfo:ReleaseInfo) {
    
    Manager.defaultManager().releaseInfo = releaseInfo
}

public func showInfoIfNeededInViewController(vc:UIViewController){
    
    Manager.defaultManager().showInfoIfNeededInViewController(vc)
}

public func reset() {
    Manager.defaultManager().resetReleaseInfo()
}