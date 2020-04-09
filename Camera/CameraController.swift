//
//  CameraController.swift
//  Camera
//
//  Created by Dan Fortunato on 4/5/20.
//  Copyright © 2020 Dan Fortunato. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: NSObject
{
    var session: AVCaptureSession?
    var camera: AVCaptureDevice?
    var cameraInput: AVCaptureDeviceInput?
    var previewLayer: AVCaptureVideoPreviewLayer?

    enum CameraControllerError: Swift.Error
    {
       case captureSessionAlreadyRunning
       case captureSessionIsMissing
       case inputsAreInvalid
       case invalidOperation
       case noCamerasAvailable
       case unknown
    }

    func prepare(completionHandler: @escaping (Error?) -> Void)
    {
        func createCaptureSession()
        {
            self.session = AVCaptureSession()
        }

        func configureCaptureDevices() throws
        {
            let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
            self.camera = camera
            try camera?.lockForConfiguration()
            camera?.unlockForConfiguration()
        }

        func configureDeviceInputs() throws
        {
            guard let session = self.session else
            {
                throw CameraControllerError.captureSessionIsMissing
            }

            if let camera = self.camera {
                self.cameraInput = try AVCaptureDeviceInput(device: camera)
                if session.canAddInput(self.cameraInput!) {
                    session.addInput(self.cameraInput!)
                } else {
                    throw CameraControllerError.inputsAreInvalid
                }
            } else {
                throw CameraControllerError.noCamerasAvailable
            }
            session.startRunning()
        }

        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
            }

            catch {
                DispatchQueue.main.async{
                    completionHandler(error)
                }
                return
            }

            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
    
    func displayPreview(on view: UIView) throws
    {
        guard let session = self.session, session.isRunning else
        {
            throw CameraControllerError.captureSessionIsMissing
        }

        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.resize(frame: view.frame)
        view.layer.insertSublayer(self.previewLayer!, at: 0)
    }
    
    func resize(frame: CGRect)
    {
        // Don't animate resizing the preview window
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        self.previewLayer?.frame = frame
        CATransaction.commit()
        // Make sure the camera orientation matches the device orientation
        self.setCameraOrientation()
    }

    func setCameraOrientation()
    {
        switch UIDevice.current.orientation {
        case .landscapeRight:
            self.previewLayer?.connection?.videoOrientation = .landscapeLeft
        case .landscapeLeft:
            self.previewLayer?.connection?.videoOrientation = .landscapeRight
        case .portrait:
            self.previewLayer?.connection?.videoOrientation = .portrait
        default:
            if self.previewLayer?.connection?.videoOrientation == nil {
                self.previewLayer?.connection?.videoOrientation = .portrait
            }
        }
    }
}
