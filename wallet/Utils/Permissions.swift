//
//  Permissions.swift
//  wallet
//
//  Created by Michael Miller on 9/20/20.
//  Copyright © 2020 Michael Miller. All rights reserved.
//

import AVFoundation

class Permissions {
    
    public static let canAccessCamera = {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }()
    
    public static func requestCameraAccess(_ onPermissionGranted: @escaping () -> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) -> Void in
           if (granted) { onPermissionGranted() }
       })
    }
    
}
