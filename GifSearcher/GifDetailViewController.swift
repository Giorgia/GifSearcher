//
//  GifDetailViewController.swift
//  GifSearcher
//
//  Created by Giorgia Marenda on 10/23/15.
//  Copyright © 2015 Giorgia Marenda. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

let gifUTI = "image/gif"

class GifDetailViewController: UIViewController, MFMessageComposeViewControllerDelegate {
  
    @IBOutlet weak var imageView: UIImageView!

    var gif: Gif!
    var shareData: NSData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let urlString = gif.images?.fixedHeight?.url, url = NSURL(string:urlString) {
            imageView.af_setImageWithURL( url, imageTransition: .CrossDissolve(0.3))
        } else {
            showAlert("Oops", message: "Image not found.")
        }
    }

    func showAlert(title: String, message: String) {
        let alert   = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let ok      = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func copyOnClipboard() {
    
        let pasteboard = UIPasteboard.generalPasteboard()
        if let urlString = gif.images?.fixedHeight?.url, url = NSURL(string:urlString) {
            pasteboard.URL = url
            showAlert("Yeah", message: "Copied to clipboard!")
        }
    }
    
    @IBAction func shareSMS() {
        if (MFMessageComposeViewController.canSendAttachments()) {
             let messageComposeVC = messageCompose()
             presentViewController(messageComposeVC, animated: true, completion: nil)
        } else {
            showAlert("Oops..", message: "Your device is not able to send text messages.")
        }
    }
    
    // MARK: - Message composer

    func messageCompose() -> MFMessageComposeViewController {
        let messageCompose = MFMessageComposeViewController()
        messageCompose.messageComposeDelegate = self
        messageCompose.addAttachmentData(shareData, typeIdentifier: gifUTI, filename: "gif.gif")
        return messageCompose
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
