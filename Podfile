# Uncomment this line to define a global platform for your project

source 'git@code.59store.com:ios/HXSpecs.git'

source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '7.0'

target 'store' do

# cocoapods
pod 'SVPullToRefresh', '~> 0.4.1'
pod 'MagicalRecord', '~> 2.3.2'
pod 'XTSafeCollection', '~> 1.0.4'
pod 'iVersion', '~> 1.11.4'
pod 'iCloudDocumentSync', '~> 7.4.1'

# local 
pod 'HXStoreUtilities', '= 1.3.0'

pod 'HXStoreLocation', '= 1.1.0'
pod 'HXStoreWebviewController', '= 1.2.0'
pod 'HXStoreLogin', '= 1.2.0'
pod 'HXStorePrint', '= 1.2.0'

#设置Debug参数
post_install do |installer|

  installer.pods_project.targets.each do |target|

    target.build_configurations.each do |config|
      
      if config.name == 'Ad-hoc' 
       config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = '$(inherited) DEBUG=1'
      
      end

end

end

end
#设置参数完成

end
