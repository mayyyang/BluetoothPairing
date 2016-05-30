

import UIKit

class PaymentViewController: UIViewController, NearbyDelegate, UITextFieldDelegate
{
    var nearbyManager:NearbyManager = NearbyManager()
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var payButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.amountTextField.keyboardType = UIKeyboardType.DecimalPad
        self.amountTextField.becomeFirstResponder()
        self.payButton.enabled = false
        
        self.nearbyManager.start() // Advertise yourself
        NearbyManager.sharedInstance.nearbyDelegate = self
    }
    
    func selectedNearbyContact(peerDisplayName: String)
    {
        self.toLabel.text = peerDisplayName
        self.payButton.enabled = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        textField.text = "$25"
    }
    
    @IBAction func payButtonPressed(sender: UIButton)
    {
        let amount = self.amountTextField.text?.stringByReplacingOccurrencesOfString("$", withString: "")
        
        let amountDictionary: [String:String] = ["amount": amount!]
        
        self.nearbyManager.sendData(amountDictionary)
        
    }
    
    func paymentRecieved(amount: String, peerName: String)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            let ac = UIAlertController(title: "Payment Recieved", message: "\(peerName) sent you $\(amount)", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func connectedWithPeer(peerName: String)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            let ac = UIAlertController(title: "Successfully Connected", message: "You may now send money to \(peerName)", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    func lostPeer(peerName: String)
    {
        NSOperationQueue.mainQueue().addOperationWithBlock
        {
            let ac = UIAlertController(title: "Connection Lost", message: "Sorry, you've been disconnected with \(peerName). Please reconnect.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        }
    }

}

