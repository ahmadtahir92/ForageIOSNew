# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'forage' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  inhibit_all_warnings!

  # Pods for forage 
  pod 'AFNetworking', '~> 3.0'
  pod 'MBProgressHUD'
  pod 'Parse'
  pod 'ParseUI'
  pod 'IQKeyboardManagerSwift'
  pod 'Stripe', '9.4.0'
  # AWS Stuff is huge...
  #pod 'AWSAutoScaling'
  #pod 'AWSCloudWatch'
  pod 'AWSCognito'
  pod 'AWSCognitoIdentityProvider'
  pod 'AWSS3'
  #pod 'AWSDynamoDB'
  #pod 'AWSEC2'
  #pod 'AWSElasticLoadBalancing'
  #pod 'AWSIoT'
  #pod 'AWSKinesis'
  #pod 'AWSLambda'
  #pod 'AWSLex'
  #pod 'AWSMachineLearning'
  #pod 'AWSMobileAnalytics'
  #pod 'AWSPinpoint'
  #pod 'AWSPolly'
  #pod 'AWSRekognition'
  #pod 'AWSSES'
  #pod 'AWSSimpleDB'
  #pod 'AWSSNS'
  #pod 'AWSSQS'
  # Image async download
  pod 'AlamofireImage'
  pod 'Toast-Swift', '~> 2.0.0'
  # Google places
  pod 'GooglePlaces'
  #pod 'GooglePlacePicker'
  #pod 'GoogleMaps'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  #FCM Messaging
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'

  target 'forageTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'AFNetworking', '~> 3.0'
    pod 'Parse'
    pod 'ParseUI'
    pod 'Stripe', '9.4.0'
    pod 'AWSCognito'
    pod 'AWSCognitoIdentityProvider'
    pod 'AWSS3'
    pod 'AlamofireImage'
    pod 'Toast-Swift', '~> 2.0.0'
    pod 'GooglePlaces'
  end

  target 'forageUITests' do
    inherit! :search_paths
    # Pods for testing
    pod 'MBProgressHUD'
    pod 'ParseUI'
    pod 'AWSCognito'
    pod 'AWSS3'
    pod 'AlamofireImage'
    pod 'Toast-Swift', '~> 2.0.0'
    pod 'GooglePlaces'
  end
end
