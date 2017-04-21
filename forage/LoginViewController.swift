//
//  LoginViewController.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/28/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    var window: UIWindow?
    static var eventTracker = EventTracker()

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var unameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func login(_ sender: UIButton) {
        var username = self.unameField.text ?? "veena@farmview.com"
        var password = self.passwordField.text ?? "123"
        
        if (username.isEmpty && password.isEmpty) {
            username = Constants.LOGIN_HOMEOWNER_DEFAULT_USERNAME
            //username = "vvalluri@gmail.com"
            //username = Constants.LOGIN_FARMER_DEFAULT_USERNAME
            password = Constants.LOGIN_DEFAULT_PASSWORD
        }
        
        if !username.isEmpty && !password.isEmpty {
            PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) -> Void in
                if let error = error {
                    print("User login failed.")
                    print(error.localizedDescription)
                } else {
                    print("User logged in successfully")
                    let currUser = user as! User
                    let setup = ParseUser.setupUserGlob(currUser: currUser)
                    if (setup) {
                        // display view controller that needs to shown after successful login
                        let userType = currUser.userType
                        // TODO - MOULI - UGLY - please change to enums!!!
                        switch (userType) {
                            case 1:
                                self.launchHome()
                                break
                            case 2:
                                if let farmId = currUser.farmId {
                                    self.launchFarmer(farmId: farmId)
                                }
                                break
                            case 3:
                                self.launchCourier()
                                break
                            default:
                                print("unsupported userType")
                                break
                        }
                        LoginViewController.eventTracker.trackUserEvent(userType: userType, event: Constants.USER_LOGIN_EVENT, user: currUser)
                    }
                    
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        /*
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init]
        logInViewController.delegate = self
        [self presentViewController:logInViewController animated:YES completion:nil]
 */
        
        // Do any additional setup after loading the view.
        self.bgImage.image = #imageLiteral(resourceName: "couple_farmers_market")
        self.loginButton.layer.cornerRadius = Constants.BUTTON_CORNER_RADIUS
        self.loginButton.clipsToBounds = true
        self.signupButton.layer.cornerRadius = Constants.BUTTON_CORNER_RADIUS
        self.signupButton.clipsToBounds = true
        
        self.navigationController?.navigationBar.isHidden = true;
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func launchHome() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "MarketNavigationController") as! UITabBarController
        // Set it to Market!
        tabBarController.selectedIndex = 0
        
        // Customize colors to material design
        tabBarController.tabBar.barTintColor = UITheme.primaryColor
        tabBarController.tabBar.tintColor = UITheme.textPrimaryColor
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }
    
    func launchFarmer(farmId: String) {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "FarmNavigationController") as! UITabBarController
        // Set it to Farmer!
        tabBarController.selectedIndex = 0
        
        // Customize colors to material design
        tabBarController.tabBar.barTintColor = UITheme.primaryColor
        tabBarController.tabBar.tintColor = UITheme.textPrimaryColor
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }
    
    func launchCourier() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let courierNavController = storyboard.instantiateViewController(withIdentifier: "CourierNavigationController") as! UINavigationController

        self.window?.rootViewController = courierNavController
        self.window?.makeKeyAndVisible()
    }

}
