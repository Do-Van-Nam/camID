// import Flutter
// import UIKit
// import MyIDKYC  // Import framework MyIDKYC (đảm bảo đã add framework vào Xcode)

// @objc class MyidKycPlugin: NSObject, FlutterPlugin {
    
//     public static func register(with registrar: FlutterPluginRegistrar) {
//         let channel = FlutterMethodChannel(name: "myid_kyc_plugin", binaryMessenger: registrar.messenger())
//         let instance = MyidKycPlugin()
//         registrar.addMethodCallDelegate(instance, channel: channel)
//     }
    
//     public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//         switch call.method {
//         case "startKYC":
//             handleStartKYC(call: call, result: result)
//         default:
//             result(FlutterMethodNotImplemented)
//         }
//     }
    
//     private func handleStartKYC(call: FlutterMethodCall, result: @escaping FlutterResult) {
//         guard let args = call.arguments as? [String: Any],
//               let licenseKey = args["licenseKey"] as? String,
//               let sessionId = args["sessionId"] as? String else {
//             result(FlutterError(code: "INVALID_ARGUMENTS", message: "Thiếu licenseKey hoặc sessionId", details: nil))
//             return
//         }
        
//         // Khởi tạo MyIDKYC SDK
//         MyIDKYC.sharedInstance.setLicenseKey(licenseKey)
        
//         // Tạo view controller KYC
//         let kycVC = MyIDViewController(sessionId: sessionId)
        
//         // Tìm root view controller để present
//         guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
//             result(FlutterError(code: "NO_ROOT_VC", message: "Không tìm thấy root view controller", details: nil))
//             return
//         }
        
//         // Present KYC screen
//         kycVC.modalPresentationStyle = .fullScreen  // Hoặc .overFullScreen tùy yêu cầu
//         rootVC.present(kycVC, animated: true, completion: nil)
        
//         // Callback khi hoàn thành KYC
//         kycVC.completionBlock = { (response: [String: Any]?, error: Error?) in
//             if let error = error {
//                 result(FlutterError(code: "KYC_FAILED", message: error.localizedDescription, details: nil))
//             } else if let response = response {
//                 result(response)  // Trả về dictionary kết quả (Flutter sẽ tự convert sang Map)
//             } else {
//                 result(FlutterError(code: "NO_RESPONSE", message: "Không có kết quả từ MyIDKYC", details: nil))
//             }
//         }
//     }
// }
import Flutter
import UIKit
import MyIDKYC

public class MyidKycPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "myid_kyc_plugin",
                                           binaryMessenger: registrar.messenger())
        let instance = MyidKycPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startKYC":
            startKYC(call, result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func startKYC(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        
        guard let args = call.arguments as? [String: Any],
              let licenseKey = args["licenseKey"] as? String,
              let sessionId = args["sessionId"] as? String
        else {
            result(FlutterError(code: "INVALID_ARGUMENTS",
                                message: "Thiếu licenseKey hoặc sessionId",
                                details: nil))
            return
        }

        // Init SDK
        MyIDKYC.sharedInstance.setLicenseKey(licenseKey)

        // Create KYC ViewController
        let kycVC = MyIDViewController(sessionId: sessionId)
        kycVC.modalPresentationStyle = .fullScreen

        // Find top view controller
        guard let topVC = UIApplication.shared.topViewController() else {
            result(FlutterError(code: "NO_ROOT_VC",
                                message: "Không tìm thấy root view controller",
                                details: nil))
            return
        }

        // Present KYC UI
        topVC.present(kycVC, animated: true, completion: nil)

        // Callback
        kycVC.completionBlock = { response, error in
            if let error = error {
                result(FlutterError(code: "KYC_FAILED",
                                    message: error.localizedDescription,
                                    details: nil))
            } else if let response = response {
                result(response)
            } else {
                result(FlutterError(code: "NO_RESPONSE",
                                    message: "Không có kết quả từ MyIDKYC",
                                    details: nil))
            }
        }
    }
}

extension UIApplication {
    /// iOS 13+ safe way to access top ViewController
    func topViewController(
        base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
    ) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            return tab.selectedViewController.flatMap { topViewController(base: $0) }
        }

        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        return base
    }
}
