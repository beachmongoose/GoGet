platform :ios, '11.0'

target 'GoGet' do
  use_frameworks!

  # Pods for GoGet
  pod 'Bond'
  pod 'ReactiveKit'
  pod 'SwiftLint'
  pod 'PromiseKit', '~> 6.8'
end

target 'GoGetTests' do
    use_frameworks!
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
    pod 'Bond'
    pod 'ReactiveKit'
    pod 'PromiseKit', '~> 6.8'
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
end
