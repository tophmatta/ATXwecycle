# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'ATXwecycle' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'SwiftyJSON', :git => 'https://github.com/appsailor/SwiftyJSON.git', :branch => 'swift3'
  pod 'Alamofire', '~> 4.0'
  pod 'Firebase'
  pod 'Firebase/Messaging'
end

target 'ATXwecycleTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ATXwecycleUITests' do
    inherit! :search_paths
    # Pods for testing
  end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
