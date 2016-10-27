platform :ios, '8.0'
use_frameworks!

target 'ZP' do
  # Tools
  pod 'AFNetworking', '~>2.6.3'
  pod 'DateTools'
  pod 'SDWebImage'
  pod 'INTULocationManager'
  pod 'PureLayout'
  pod 'IDDaDataSuggestions', git: 'https://github.com/DanShevlyuk/IDDaDataSuggestions.git'

  # UI
  pod 'OAStackView'
  pod 'JSBadgeView'
  pod 'SCLAlertView-Objective-C'
  pod 'VBFPopFlatButton'
  pod 'REFormattedNumberField'
  pod 'MBProgressHUD'
  pod 'ActionSheetPicker-3.0'
  pod 'HCSStarRatingView'
  pod 'EZSwipeController', git: 'https://github.com/DanShevlyuk/EZSwipeController.git'
  pod 'CWStatusBarNotification', '~> 2.3.4'

  # Fabric
  pod 'Fabric'
  pod 'Crashlytics'

  # Maps
  pod 'GoogleMaps'
  pod 'LMGeocoder'

  # Facebook SDK
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings['SWIFT_VERSION'] = '2.3'
  end
end
