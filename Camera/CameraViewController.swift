//
//  CameraViewController.swift
//  Camera
//
//  Created by Dan Fortunato on 4/5/20.
//  Copyright © 2020 Dan Fortunato. All rights reserved.
//

import UIKit
import SwiftUI

final class CameraViewController: UIViewController
{
    let cameraController = CameraController()
    var previewView: UIView!

    override func viewDidLoad()
    {
        previewView = UIView(frame: UIScreen.main.bounds)
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
        view.addSubview(previewView)
        cameraController.prepare { (error) in
            if let error = error {
                print(error)
            }
            try? self.cameraController.displayPreview(on: self.previewView)
        }
        // Don't animate device rotation
        UIView.setAnimationsEnabled(false)
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator)
    {
        previewView.frame.size = size
        self.cameraController.resize(frame: previewView.frame)
    }
}

extension CameraViewController : UIViewControllerRepresentable
{
    public typealias UIViewControllerType = CameraViewController

    public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> CameraViewController
    {
        return CameraViewController()
    }

    public func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraViewController>)
    {}
}
