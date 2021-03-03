//
//  ScreenProtector.swift
//  PreventScreenshot
//
//  Created by Eric Yang on 19/9/20.
//

import UIKit
import Photos

class ScreenProtector: NSObject {
    private var warningWindow: UIWindow?

    private var window: UIWindow? {
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
    }

    func startPreventingRecording() {
        NotificationCenter.default.addObserver(self, selector: #selector(didDetectRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
    }

    func startPreventingScreenshot() {
        NotificationCenter.default.addObserver(self, selector: #selector(didDetectScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }

    @objc private func didDetectRecording() {
        DispatchQueue.main.async {
            self.hideScreen()
            self.presentwarningWindow("Screen recording is not allowed in our app!")
        }
    }

@objc private func didDetectScreenshot() {
    DispatchQueue.main.async {
        self.hideScreen()
        self.presentwarningWindow( "Screenshots are not allowed in our app. Please follow the instruction to delete the screenshot from your photo album!")
        
        self.didTakeScreenshot()
    }
}
    
    

    private func hideScreen() {
        if UIScreen.main.isCaptured {
            window?.isHidden = true
        } else {
            window?.isHidden = false
        }
    }

    private func presentwarningWindow(_ message: String) {
        // Remove exsiting
        warningWindow?.removeFromSuperview()
        warningWindow = nil

        guard let frame = window?.bounds else { return }

        // Warning label
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.text = message

        // warning window
        var warningWindow = UIWindow(frame: frame)

        let windowScene = UIApplication.shared
            .connectedScenes
            .first {
                $0.activationState == .foregroundActive
            }
        if let windowScene = windowScene as? UIWindowScene {
            warningWindow = UIWindow(windowScene: windowScene)
        }

        warningWindow.frame = frame
        warningWindow.backgroundColor = .black
        warningWindow.windowLevel = UIWindow.Level.statusBar + 1
        warningWindow.clipsToBounds = true
        warningWindow.isHidden = false
        warningWindow.addSubview(label)

        self.warningWindow = warningWindow

        UIView.animate(withDuration: 0.15) {
            label.alpha = 1.0
            label.transform = .identity
        }
        warningWindow.makeKeyAndVisible()
    }
    
    func didTakeScreenshot() {
        //self.perform(#selector(deleteAppScreenShot), with: nil, afterDelay: 1, inModes: [])
        let delayTime = DispatchTime.now() + 2.0
           print("one")
           DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
            self.deleteAppScreenShot()
           })
    }
    
     func deleteAppScreenShot() {
        NSLog("i am here")
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors?[0] = Foundation.NSSortDescriptor(key: "creationDate", ascending: true)
        let fetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: fetchOptions)
        guard let lastAsset = fetchResult.lastObject else { return }
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.deleteAssets([lastAsset] as NSFastEnumeration)
        } completionHandler: { (success, errorMessage) in
            if !success, let errorMessage = errorMessage {
                print(errorMessage.localizedDescription)
            }
        }
    }

    // MARK: - Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
