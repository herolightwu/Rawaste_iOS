//
//  WalletReceiveVC.swift
//  rawaste
//
//  Created by MeiXiang Wu on 12/16/19.
//

import UIKit
import EFQRCode

class WalletReceiveVC: UIViewController {
    
    @IBOutlet weak var imgQrCode: UIImageView!
    @IBOutlet weak var lbQrcode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshView()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func refreshView() {
        lbQrcode.text = me.address
        let start = me.address.index(me.address.startIndex, offsetBy: 2)
        let end = me.address.index(me.address.endIndex, offsetBy: 0)
        let range = start..<end

        let addr = String(me.address[range])
        //                    content: Content of QR Code
        //            size (Optional): Width and height of image
        // backgroundColor (Optional): Background color of QRCode
        // foregroundColor (Optional): Foreground color of QRCode
        //       watermark (Optional): Background image of QRCode
        if let tryImage = EFQRCode.generate(
            content: addr) {
            imgQrCode.image = UIImage(cgImage: tryImage)
        } else {
            print("Create QRCode image failed!")
        }
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
    
}
