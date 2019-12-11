//
//  WalletSendVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/16/19.
//

import UIKit
import Toaster
import QRCodeReader

class WalletSendVC: UIViewController {

    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // Configure the view controller (optional)
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onQRClick(_ sender: Any) {
        // Retrieve the QRCode content
         // By using the delegate pattern
         readerVC.delegate = self
         // Or by using the closure pattern
         readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            self.txtAddress.text = result?.value
         }
         // Presents the readerVC as modal form sheet
         readerVC.modalPresentationStyle = .formSheet
        
         present(readerVC, animated: true, completion: nil)
    }
    @IBAction func onSendClick(_ sender: Any) {
        if txtAddress.text?.count == 0 {
            Toast(text: "Please input address").show()
            return
        }
        var addr = txtAddress.text!
        if !addr.starts(with: "0x") {
            addr = "0x" + addr
        }
        if txtAmount.text?.count == 0 {
            Toast(text: "please input amount").show()
            return
        }
        sendEthereum(addr, amount: Double(txtAmount.text!)!)
    }
    
    func sendEthereum(_ addr: String, amount: Double){
        
    }
}

extension WalletSendVC: QRCodeReaderViewControllerDelegate {
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
      reader.stopScanning()

      dismiss(animated: true, completion: nil)
    }
}
