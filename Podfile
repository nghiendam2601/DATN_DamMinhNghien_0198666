use_frameworks!

target 'MovieInMinutes' do
  pod 'RatingStar'
  pod 'Pageboy', '~> 4.2'
  pod 'Tabman', '~> 3.2'
  pod 'SwipeCellKit'
  pod "PullToRefreshKit"
  pod 'NVActivityIndicatorView'

end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "15.6"
    end
  end
end
