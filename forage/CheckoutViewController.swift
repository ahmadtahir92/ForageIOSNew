
//
//  CheckoutViewController.swift
//  Forage
//
//  Created by Chandramouli Balasubramanian on 2/19/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//
import UIKit
import Stripe
import GooglePlaces

class CheckoutViewController: UIViewController, STPPaymentContextDelegate, GMSAutocompleteViewControllerDelegate {
    
    let deliverIndex = 0
    let pickupIndex = 1
    
    let titleIndex = 0
    let detailIndex = 1
    let tapIndex = 2
    
    var paymentContextComplete = false
    
    // These values will be shown to the user when they purchase with Apple Pay.
    let paymentCurrency = "usd"
    var paymentContext: STPPaymentContext
    
    var price: Double = 0.0
    var totalPriceText: String = ""
    
    var theme: STPTheme
    var numberFormatter: NumberFormatter
    
    var deliveryOptions = [["Deliver To:", "", true], ["Pickup @:", Constants.MARKET_ADDRESS_MV, false]]
    
    var paymentInProgress: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                if self.paymentInProgress {
                    self.activityIndicator.startAnimating()
                    self.activityIndicator.alpha = 1
                    self.buyButton.alpha = 0
                }
                else {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.alpha = 0
                    self.buyButton.alpha = 1
                }
            }, completion: nil)
        }
    }
    
    @IBOutlet weak var deliveryView: DeliveryRowView!
    @IBOutlet weak var buyButton: ForageButton!
    @IBOutlet weak var paymentRow: PaymentRowView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var secureText: UILabel!
    @IBOutlet weak var stripeIcon: UIImageView!
    @IBOutlet weak var applePayIcon: UIImageView!
    
    @IBOutlet weak var deliverySwitch: UISwitch!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    private func totalViewSetup(subtotal: Double, deliveryFee: Double) {
        let total = subtotal + deliveryFee
        let chargeAmount = (Int) (total * 100)
        
        self.subTotalLabel.text = self.numberFormatter.string(from: NSNumber(value: subtotal))
        self.deliveryPriceLabel.text = self.numberFormatter.string(from: NSNumber(value: deliveryFee))
        self.totalPriceText = self.numberFormatter.string(from: NSNumber(value: total))!
        self.totalLabel.text = self.totalPriceText
        
        // Keep payment context upto date!
        self.paymentContext.paymentAmount = chargeAmount
    }
    
    // Mark: Delivery setups!
    
    private func dSetup(value: Bool) {
        var dIndex = deliverIndex
        
        if (!value) {
            dIndex = pickupIndex
        }
        
        let delivery = deliveryOptions[dIndex]
        
        deliveryView.setup(title: delivery[titleIndex] as! String, detail: delivery[detailIndex] as! String, tappable: delivery[tapIndex] as! Bool)
        
        totalViewSetup(subtotal: self.price, deliveryFee: DeliveryRowView.getDeliveryFee(delivery: value))
    }
    @IBAction func deliveryToggle(_ sender: UISwitch) {
        dSetup(value: sender.isOn)
    }
    
    private func setupDeliveryAddress(shipAddr: String) {
        self.deliveryOptions[deliverIndex][detailIndex] = shipAddr
    }
    
    func setup(price: Double, shipAddress: String) {
        self.price = price
        self.setupDeliveryAddress(shipAddr: shipAddress)

        let userInformation = STPUserInformation()
        self.paymentContext.prefilledInformation = userInformation
        self.paymentContext.paymentCurrency = self.paymentCurrency
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.theme.primaryBackgroundColor
        
        var red: CGFloat = 0
        self.theme.primaryBackgroundColor.getRed(&red, green: nil, blue: nil, alpha: nil)
        self.activityIndicator.activityIndicatorViewStyle = red < 0.5 ? .white : .gray
        self.activityIndicator.alpha = 0
        
        self.navigationItem.title = Constants.APP_MERCHANT_NAME
        
        self.buyButton.setup(title: "Buy!", enabled: true)
        self.buyButton.addTarget(self, action: #selector(didTapBuy), for: .touchUpInside)
        
        self.paymentRow.setup(title: "Payment", detail: "Select Payment")
        self.paymentRow.onTap = { [weak self] _ in
            self?.paymentContext.pushPaymentMethodsViewController()
        }
        
        self.deliveryView.onTap = { [weak self] _ in
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            
            // Set a filter to return only addresses.
            let addressFilter = GMSAutocompleteFilter()
            addressFilter.type = .address
            autocompleteController.autocompleteFilter = addressFilter
            
            self?.present(autocompleteController, animated: true, completion: nil)
        }
        
        self.secureText.text = Constants.SECURE_CHECKOUT_STR
        self.stripeIcon.image = #imageLiteral(resourceName: "stripe_logo")
        self.applePayIcon.image = #imageLiteral(resourceName: "apple-pay-logo")
        
        // Toggle delivery switch to be on
        self.deliverySwitch.setOn(true, animated: true)
        dSetup(value: true)
    }
    
    func didTapBuy() {
        self.paymentInProgress = true
        self.paymentContext.requestPayment()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        self.theme = STPTheme()
        /* Map UITheme to STPTheme */
        self.theme.primaryBackgroundColor = UITheme.defaultBackgroundColor
        self.theme.secondaryBackgroundColor = UITheme.lightPrimaryColor
        self.theme.primaryForegroundColor = UITheme.primaryTextColor
        self.theme.secondaryForegroundColor = UITheme.secondaryTextColor
        self.theme.accentColor = UITheme.accentColor
        self.theme.errorColor = UITheme.defaultErrorColor
        self.theme.font = UITheme.font
        self.theme.emphasisFont = UITheme.emphasisFont
        
        let paymentContext = STPPaymentContext(apiAdapter: StripePaymentClient.sharedClient,
                                               configuration: STPPaymentConfiguration.shared(),
                                               theme: self.theme)
        self.paymentContext = paymentContext
        
        var localeComponents: [String: String] = [
            NSLocale.Key.currencyCode.rawValue: self.paymentCurrency,
            ]
        localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
        let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeID)
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        self.numberFormatter = numberFormatter

        super.init(coder: aDecoder)
        
        self.paymentContext.delegate = self
        self.paymentContext.hostViewController = self
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let confirmationViewController = segue.destination as! ConfirmationViewController
        confirmationViewController.totalPriceText = self.totalPriceText
    }
    
    private func initiateSegueToConfirmation() {
        self.paymentContextComplete = true
        performSegue(withIdentifier: "segueToConfirmation", sender: self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "segueToConfirmation" {
            if (!self.paymentContextComplete) {
                return false
            }
        }
        return true
    }

    
    // MARK: STPPaymentContextDelegate
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        StripePaymentClient.sharedClient.completeCharge(paymentResult, amount: self.paymentContext.paymentAmount,
                                                completion: completion)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        self.paymentInProgress = false
        let title: String
        let message: String
        switch status {
            case .error:
                title = Constants.PAYMENT_DEFAULT_ERR_STR
                message = error?.localizedDescription ?? "" + "\n" + Constants.CUSTOMER_SERVICE_STR
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { action in
                    // Pop the controller to allow user to try a different payment method!
                    _ = self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            case .success:
                // Ok great show the confirmation page!
                self.initiateSegueToConfirmation()
            case .userCancellation:
                return
        }
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        self.paymentRow.loading = paymentContext.loading
        if let paymentMethod = paymentContext.selectedPaymentMethod {
            self.paymentRow.detail = paymentMethod.label
        }
        else {
            self.paymentRow.detail = "Select Payment"
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Need to assign to _ because optional binding loses @discardableResult value
            // https://bugs.swift.org/browse/SR-1681
            _ = self.navigationController?.popViewController(animated: true)
        })
        let retry = UIAlertAction(title: "Retry", style: .default, handler: { action in
            self.paymentContext.retryLoading()
        })
        alertController.addAction(cancel)
        alertController.addAction(retry)
        self.present(alertController, animated: true, completion: nil)
    }

    
    // Mark: GMSAutocompleteViewControllerDelegate
    
    private func updateAddress(addr: String?) {
        if let address = addr {
            setupDeliveryAddress(shipAddr: address)
            ParseHomeOwner.updateHomeAddress(address: address)
            dSetup(value: true)
        }
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place address: \(place.formattedAddress)")
        
        updateAddress(addr: place.formattedAddress)
        
        // Close the autocomplete widget.
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

