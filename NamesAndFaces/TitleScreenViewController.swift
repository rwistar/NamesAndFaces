//
//  TitleScreenViewController.swift
//  TwoWayCommunication
//
//  Created by Allie Shuldman 2016 on 3/9/16.
//  Copyright © 2016 Allie Shuldman. All rights reserved.
//

import UIKit

class TitleScreenViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var foregroundImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordResultsLabel: UILabel!
    
    var password = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getPasswordFromServer()
        
        foregroundImageView.contentMode = UIViewContentMode.ScaleAspectFit
        foregroundImageView.image = UIImage(named: "prototypelogo")
        
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView.image = UIImage(named: "Field_Hockey_Image")
        backgroundImageView.alpha = 0.5
        
        navigationController?.navigationBarHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @IBAction func continueButtonPressed(sender: AnyObject) {
        
        if self.passwordTextField.text == password
        {
            self.performSegueWithIdentifier("goToTerms", sender: self)
        }
        else
        {
            passwordTextField.text = ""
            passwordResultsLabel.text = "Incorrect password."
            passwordResultsLabel.hidden = false
        }
    }
    
    func getPasswordFromServer()
    {
        var urlString = "http://namesandfaces.hotchkiss.org/password.txt"
        var url = NSURL(string: urlString)
        
        func getData(){
            let task = NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 15.0)){(data, response, error) in
                let urlContent = (NSString(data: data!, encoding: NSUTF8StringEncoding))
                let tempContent:String = urlContent as! String
                print(tempContent)
                self.password = tempContent
                
            }
            
            task.resume()
        }
        
        getData()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
