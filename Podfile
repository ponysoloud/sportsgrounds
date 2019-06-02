# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'

target 'sportsgrounds' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for sportsgrounds
  pod 'PromiseKit', '~> 6.8'
  pod 'Socket.IO-Client-Swift', '~> 15.0.0'
  pod 'Starscream', '~> 3.1.0'
  pod 'Keyboard+LayoutGuide'
  pod 'GoogleMaps'
  pod 'SPAlert'
  pod 'rubber-range-picker'
  pod 'GoogleStaticMapsKit'
  pod 'YPImagePicker'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          if target.name == 'Starscream'
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '4.2'
              end
          end
      end
  end
  
end
