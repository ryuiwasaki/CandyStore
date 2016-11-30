//
//  CandyStore.swift
//  Pods
//
//  Created by Ryu Iwasaki on 2016/05/22.
//
//

import Foundation

public func setReleaseInfo(_ releaseInfo:ReleaseInfo) {
    
    Manager.defaultManager().releaseInfo = releaseInfo
}

public func showInfoIfNeededInViewController(_ vc:UIViewController){
    
    Manager.defaultManager().showInfoIfNeededInViewController(vc)
}

public func reset() {
    Manager.defaultManager().resetReleaseInfo()
}

public func alertTitleFormat(_ format:String?) {
    Manager.defaultManager().alertTitleFormat = format
}
