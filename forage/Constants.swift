//
//  Constants.swift
//  forage
//
//  Created by Chandramouli Balasubramanian on 1/30/17.
//  Copyright © 2017 Forage Inc. All rights reserved.
//

import UIKit

struct Constants {
    // Forage Constants
    static let APP_NAME = "Forage"
    static let APP_COMPANY_NAME = "Forage Inc."
    static let APP_MERCHANT_NAME = APP_COMPANY_NAME
    static let APP_PHONE = "(650) 314-9696"
    static let APP_EMAIL = "reachforagers@gmail.com"
    
    // Home Owner Constants
    static let HOME_USER_CACHE = "Harvest"
    
    // Farm Constants
    static let DELETE_INVENTORY = "Deleting inventory"
    
    // Image constants
    static let FULL_ALPHA = 1.0 as CGFloat
    static let MEDIUM_ALPHA = 0.5 as CGFloat
    static let LOW_ALPHA = 0.1 as CGFloat
    static let VIEW_BRIGHT_ALPHA = FULL_ALPHA
    static let ICON_BRIGHT_ALPHA = FULL_ALPHA
    static let ICON_DIM_ALPHA = MEDIUM_ALPHA
    static let VIEW_MEDIUM_ALPHA = MEDIUM_ALPHA
    static let VIEW_DIM_ALPHA = LOW_ALPHA
    
    
    // Environment to use when creating an instance of Wallet.WalletOptions
    // static let WALLET_ENVIRONMENT_TEST = WalletConstants.ENVIRONMENT_TEST
    // static let WALLET_ENVIRONMENT_PRODUCTION = WalletConstants.ENVIRONMENT_PRODUCTION
    // static let WALLET_ENVIRONMENT = WALLET_ENVIRONMENT_TEST
    
    static let MERCHANT_NAME = "Forage Inc."
    
    // Intent extra keys
    static let EXTRA_ITEM_ID = "EXTRA_ITEM_ID"
    static let EXTRA_MASKED_WALLET = "EXTRA_MASKED_WALLET"
    static let EXTRA_FULL_WALLET = "EXTRA_FULL_WALLET"
    
    static let CURRENCY_CODE_USD = "USD"
    
    // values to use with KEY_DESCRIPTION
    static let DESCRIPTION_LINE_ITEM_SHIPPING = "Shipping"
    static let DESCRIPTION_LINE_ITEM_TAX = "Tax"
    
    // Google Analytics usage strings
    static let GA_INVENTORY_SUBSTRING = "\'s inventory Screen"
    static let GA_CHECKOUT_CART_SCREEN = "Checkout Cart Screen"
    static let GA_ALL_FARMS_SCREEN = "All Farm\'s Screen"
    static let GA_MY_FARMS_SCREEN = "Fav Farm\'s Screen"
    static let GA_CARD_PAYMENT_SCREEN = "Card Payment Screen"
    static let GA_MAIN_ACTIVITY_SCREEN = "Main Screen"
    static let GA_ORDER_MASON_SCREEN = "Order Mason Screen"
    static let GA_FARM_ACTIVITY_SCREEN = "\'s Management Main Screen"
    static let GA_FARM_PROFILE_SCREEN = "\'s Profile Screen"
    static let GA_FARM_ADD_ITEM_SCREEN = " Add Item Screen"
    static let GA_COURIER_ACTIVITY_SCREEN = "\'s Main Screen"
    static let GA_MEDIA_SCREEN = " Media Screen"
    static let GA_FARM_ORDER_LIST_SCREEN = "farmorder"
    static let GA_FARM_ORDER_DETAIL_SCREEN = " Farm Order Detail Screen"
    static let GA_COURIER_ORDER_LIST_SCREEN = "courierorder"
    static let GA_COURIER_ORDER_DETAIL_SCREEN = " Courier Order Detail Screen"
    
    
    // Parcel Argument usage strings
    static let PARCEL_HOMEID = "homeId"
    static let PARCEL_HOMENAME = "homeName"
    static let PARCEL_FARMID = "farmId"
    static let PARCEL_FARMNAME = "farmName"
    static let PARCEL_USERID = "uId"
    static let PARCEL_USERNAME = "uName"
    static let DEFAULT_ID = "FORAGER"
    static let PARCEL_GOURMARK_DETAIL = "gourmark"
    static let PARCEL_ORDER_DETAIL = "order"
    static let PARCEL_SAVED_CARD = "savedCard"
    static let PARCEL_CARD_CMD = "cardMetaData"
    static let PARCEL_CHARGE_RESULT = "chargeResult"
    
    //Test time series for inventory
    static let TEST_FARMNAME = "farmName"
    static let TEST_ITEMNAME = "itemName"
    static let TEST_ITEMNAME_ORANGE = "orange"
    
    // Login constants
    static let LOGIN_DEFAULT_PASSWORD = "123"
    static let LOGIN_DOMAIN = "@farmview.com"
    static let LOGIN_HOMEOWNER_DEFAULT_USERNAME = "veena" + LOGIN_DOMAIN
    static let LOGIN_FARMER_DEFAULT_USERNAME = "chetan" + LOGIN_DOMAIN
    
    // Market Ids!
    static let ADMIN_EMAIL = "cfma" + LOGIN_DOMAIN
    static let ADMIN_LOGIN_EMAIL = ADMIN_EMAIL
    static let ADMIN_SEASONAL_LIST_EMAIL = ADMIN_EMAIL
    static let ADMIN_DEFAULT_PASSWORD = LOGIN_DEFAULT_PASSWORD
    
    
    // AWS Constants
    static let SDCARD_TMP_STORAGE_PATH = "/sdcard"
    static let S3_COUPLE_FARMERS_MARKET_DEFAULT_IMAGE = "couple_farmers_market.jpg"
    static let AWS_FOLDER_SUFFIX = "/"
    static let AWS_UNDERSCORE = "_"
    
    // Stripe constants
    static let DISCOVER_DUMMY_CARD_NUMBER = "6011000990139424"
    static let DUMMY_CARD_CVC = "123"
    static let DUMMY_CARD_EXP_MONTH = 9
    static let DUMMY_CARD_EXP_YEAR = 2021
    static let DUMMY_CARD_ZIPCODE = "94040"
    static let DUMMY_CARD_LAST4 = "0000"
    static let STRIPE_DUMMY_CUSTOMER_ID = "DEADBEEF"
    
    // Android Permission Constants
    static let MY_PERMISSIONS_REQUEST_CAMERA = 100
    static let MY_PERMISSIONS_REQUEST_WRITE_EXTERNAL_STORAGE = 101
    static let MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE = 102
    
    // Home Owner View dynamics
    static let HOME_FAV_COUNT_MIN_TO_PRIORITIZE = 3
    
    //Home PageAdapter constants
    static let MARKET_TAB = "Market"
    static let MY_TAB = "Cache"
    static let GENIE_TAB = "Genie"
    static let MEDIA_TAB = "Media"
    
    //Checkout PageAdapter constants
    static let DELIVERY_TAB = "Delivery"
    static let PAYMENT_TAB = "Payment"
    static let CONFIRMATION_TAB = "Confirmation"
    
    //feedback Constants
    static let FROM = "From: "
    static let TO = "To: "
    static let OUR_SIGNATURE = "The Foragers"
    static let FEEDBACK_STR_MIN_LEN = 10 // e.g. "I love it."
    
    
    // Error Strings
    static let SUCCESS_STR = "SUCCESS!!!"
    static let DEFAULT_ERR_PREFIX = "FORAGE_ERROR_HANDLE_IT"
    static let NET_CONN_FAIL_PREFIX = "NET_CONN_ERR"
    static let CHARGE_ERR_PREFIX = "CHRG_ERR"
    static let QUERY_ERR_PREFIX = "Q_ERR"
    static let STRIPE_ERR_PREFIX = "STRIPE_ERR"
    static let PAYMENT_DEFAULT_ERR_STR = "Payment Transaction Error!"
    static let PARSE_CLOUD_ERR = "PARSE_CLOUD_ERR: "
    
    
    // Warning Strings
    static let NEEDS_DESCRIPTION = "Enter Description:"
    
    // Billing Strings
    static let SHIPPING_STR = "Shipping: "
    static let TAX_STR = "Tax: "
    static let DELIVERY_FEE_STR = "Delivery Fee: "
    static let SUBTOTAL_STR = "Subtotal: "
    static let TOTAL_STR = "Total: "
    static let CHECKOUT_STR = "Checkout: "
    static let CART_STR = "Tote"
    static let SPACE_STR = " "
    static let DASH_STR = "- "
    static let CARD_STR = "Card ending in "
    
    // Delivery String
    static let PICKUP_PREFIX = "@ "
    static let DELIVER_PREFIX = "To: "
    static let FREE_STR = "Free!" // Never thought this would be a cool thing!
    static let CHECKOUT_PRICE_THRESHOLD_FOR_FREE_DELIVERY = 60.0
    static let DEFAULT_DELIVERY_COST = 8.0
    static let NO_DELIVERY_COST = 0.0
    
    // Checkout constants
    static let SECURE_CHECKOUT_STR = "Payments secured by"
    
    // Payment tags
    static let PAYMENT_THANK_YOU_STR = "Thank you for shopping with Forage!"
    static let PAYMENT_ORDER_CONFIRMATION_PREFIX_STR = "Confirmation number is: "
    static let RETURN_TO_SHOPPING_STR = "Return to shopping!"
    
    
    // Parse cloud function constants
    static let USER_EMAIL = "userEmail"
    static let HOME_ID = "homeId"
    static let NEW_CARD_STR = "newCard"
    static let CUST_ID_STR = "customerId"
    static let CARD_ID_STR = "cardId"
    static let ORDER_ID_STR = "orderId"
    static let CARD_TOKEN_STR = "cardToken"
    
    
    // Date Patterns
    static let FORAGE_DATE_PATTERN = "EEE MMM d HH:mm"
    
    // Order Constants
    //public static let ORDER_UPLOAD = "Upload order to cart?"
    static let ORDER_UPLOAD = "Adding order to tote!"
    static let ORDER_WARNING = "Repopulating your tote"
    static let LAST_ORDER_STR = "Last Order: "
    static let ORDER_NAME = "My Order @ "
    
    
    // My Cache Constants
    static let SEASONAL_STR = "Seasonals"
    static let GOURMARKS_STR = "Gourmarks"
    static let ORDER_STR = "Order Builder"
    
    // Parse Constants
    static let DEFAULT_MAX_FETCH_RECS = 10
    static let MAX_FETCH_ADMIN_ORDERS = 3
    static let MAX_FETCH_FARM_RECS = 10
    static let MAX_FETCH_GOURMARK_RECS = 20
    
    // Market Constants
    static let MARKET_ADDRESS_MV = "Mountain View Caltrain, 600 W Evelyn Ave, Mountain View, CA 94041"
    static let MARKET_ADDRESS_MV_ALTERNATE = "380 Bryant St, Mountain View, CA 94041"
    
    // CFMA Constants
    static let CFMA_STAFF_NAME_STR = "CFMA_Staff"
    static let CFMA_STAFF_ADDRESS_STR = "3000 Citrus Cir, Walnut Creek, CA 94598, USA"
    
    // About Us @ login page!
    static let ABOUT_US_STR = "We absolutely love our farmer’s market - rows and rows of vibrant and colorful fruits and vegetables, fresh bread, milk, and eggs, and a huge list of gourmet food stalls - a sensory overload each week! It is a vibrant social gathering and an opportunity know and directly connect with the folks who produce our food!\n" +
    "\n" +
    "Our weekends are busy with kids classes, house chores, long training rides, holiday trips, pursuing our passions, and honestly many times even work. We don’t always get to go to the market, but rain or shine the farmers are at the market every week!!!\n" +
    "\n" +
    "Forage started with bringing the benefits of online shopping and delivery to the market’s awesomeness to our friends! Find out what is currently in season, and who is offering the super sweet organic oranges, or the mini butternut squashes. Save, track, and rate your favorites. Pay without juggling with cash. Simply point and we will jump to action!\n" +
        "\n" +
    "After several rich learning experiences in our backyards and apartment patios, we stick to building the app’s tech. :) We bridge farmers directly with our customers and partner with the market association. If you are passionate about empowering the farming community and in general solving world hunger, ping us @ " + APP_EMAIL + " or " + APP_PHONE + "."
    
    
    // Contact String
    static let CONTACT_US_STR = "Contact us @" + APP_EMAIL + " or " + APP_PHONE + "."
    static let CUSTOMER_SERVICE_STR = "For help please contact us @" + APP_EMAIL + " or " + APP_PHONE + "."
    
    // To change promotion item, change the item here and also corresponding text/image
    // in fragment_promo_address_lookup.xml layout.
    static let PROMOTION_ITEM = 2
    
    // Analytics Tracking events
    static let ATYPE_TIMESERIES = "timeseries"
    static let ATYPE_DOCUMENTSERIES = "documentseries"
    // Farm Inventory
    static let FARM_ITEM_TRACKER = "farmitemseries"
    static let FARM_INV_ITEM = "farminventoryitem"
    // Home Order
    static let HOME_ORDER_ITEM_TRACKER = "homeorderseries"
    static let HOME_ORDER_ITEM = "homeorderitem"
    // User Events (Farmer/Home owner/Delivery person)
    static let USER_EVENT_TRACKER = "usereventseries"
    static let FARM_USER_EVENT = "farmuser"
    static let HOME_USER_EVENT = "homeuser"
    static let COURIER_USER_EVENT = "courieruser"
    static let USER_LOGIN_EVENT = "login"
    static let USER_LOGOUT_EVENT = "logout"
    // Screen usage tracking
    static let SCREEN_EVENT_TRACKER = "screeneventseries"
    // Note: Uses Google Analytics usage strings
    
    // Farm classification tags
    static let FARM_CLASS_ORGANIC = "Organic"
    static let FARM_CLASS_NATURAL = "Natural"
    static let S3_FARM_CLASS_ORGANIC_IMAGE = "ccof_logo.jpg"
    static let S3_FARM_CLASS_NATURAL_IMAGE = "certified_natural.jpg"
    
    // Feed share tags
    static let ORIG_AUTHOR_PREFIX = "Creator: ";
    static let SHARED_AUTHOR_PREFIX = "Tagged by: ";
    
    // Image constants
    static let IMAGE_CORNER_RADIUS: CGFloat = 5
    static let IMAGE_SHADOW_OFFSET_WIDTH = 0.2 // 0
    static let IMAGE_SHADOW_OFFSET_HEIGHT = 0.3 // 3
    static let IMAGE_SHADOW_RADIUS = 2 // 1 - thinner, subtler shadows
    static let IMAGE_SHADOW_OPACITY: Float = 0.5 //0.2 - subtle is better
    static let BUTTON_CORNER_RADIUS: CGFloat = 5
    
    
    // Dictionary constants
    static let MAX_SEARCH_DICTIONARY_SIZE = 100 // 100 words is a lot hopefully
    
    
    // XXX - Mouli - move all this to info.plist!!!
    
    /**
     * localhost on the emulator points to the device - not PC!
     * To debug for genymotion - use 10.0.3.2
     * For Android emulator - use 10.0.2.2
     */
    // XXX - TO BE DEPRECREATED - please remove!!!
    // FORAGE_AWS_SERVER = "http://farmserver.us-east-1.elasticbeanstalk.com"
    // FORAGE_AWS_SERVER = "http://forageserver.us-west-2.elasticbeanstalk.com"
    //$0.server = "http://10.0.3.2:1337/parse/" - home wifi
    /**
     * For local server - need to be on same wifi connection!
     */
    //$0.server = "http://172.31.99.221:1337/parse/"
    //$0.server = "http://192.168.43.254:1337/parse/" - Mouli AP
    //$0.server = "http://192.168.1.8:1337/parse/"
    //$0.server = "http://10.0.1.6:1337/parse/"

    // SERVER ENDPOINTS
    static let FORAGE_MOULIAP_SERVER = "http://192.168.43.254:1337"
    static let FORAGE_AWS_SERVER = "https://market.foragelocal.com"
    static let FORAGE_HEROKU_SERVER = "https://farmviewserver.herokuapp.com"
    
    static let FORAGE_SERVER = FORAGE_AWS_SERVER
    static let FORAGE_PARSE_ENDPOINT = "/parse"
    static let FORAGE_STRIPE_ENDPOINT = "/stripe"
    
    // XXX - Mouli - move all this out of here to info.plist???
    static let PARSE_APP_ID = "bgVXRUCTrWhVpT3Ztrl2McZisxr1KZ4INFqLrI8X"
    static let PARSE_CLIENT_KEY = "Cl6LWJU8NLW9x6yX0LFDl7q4nyJqaWV5gFf3eLmT"
    static let PARSE_MASTER_KEY = "k7BNuhwUDN7vYrT0XAmOi3CThIVDqLAehT5hQnFC"

    // Stripe constants
    static let STRIPE_PUBLISHABLE_TEST_KEY = "pk_test_DSRP1uClZ1ReyaDyvb8LFie9"
    static let STRIPE_PUBLISHABLE_LIVE_KEY = "pk_live_6nV62TqHFuILyOWAzyNTCh9D"
    static let STRIPE_PUBLISHABLE_KEY = STRIPE_PUBLISHABLE_LIVE_KEY
    static let STRIPE_APPLE_MERCHANT_ID = "your apple merchant identifier"
    
    // Google Constants
    static let GOOGLE_API_KEY = "AIzaSyBjkMuDLdjeyaFMUmac-EIWrnckxUme170" // Team Foragers project !!!
    
    // FCM Messaging Constants
    static let SUBSCRIBE_ORDER_NOTIF_TOPIC = "ordernotify" // Notify customers to place orders
    static let SUBSCRIBE_INVENTORY_UPDATE_NOTIF_TOPIC = "inventory_update_notify" // Notify farmers to update inventory
    
}
