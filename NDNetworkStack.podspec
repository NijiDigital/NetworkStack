Pod::Spec.new do |s|

  s.name         = "NDNetworkStack"
  s.version      = "0.1.0"
  s.summary      = "A Swift network request manager framework using reactive programming"

  s.homepage     = "https://github.com/NijiDigital/NDNetworkStack"
  s.license      = { :type => "Apache 2", :file => "LICENSE" }

  s.authors            = { "Niji" => "" }
  s.social_media_url   = "https://twitter.com/niji_digital"

  s.ios.deployment_target = "8.0"  

  s.source       = { :git => "https://github.com/NijiDigital/NDNetworkStack.git", :tag => s.version.to_s }
  
  s.source_files = 'Sources/**/*.swift'

  s.ios.framework  = 'MobileCoreServices'
  
  s.dependency 'Alamofire', '~> 4.0'
  s.dependency 'RxSwift', '~> 3.0'
  s.dependency 'KeychainAccess', '~> 3.0'
end
