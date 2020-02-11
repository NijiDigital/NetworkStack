Pod::Spec.new do |s|

  s.name         = "NetworkStack"
  s.version      = "0.1.6"
  s.summary      = "A Swift network request manager framework using reactive programming"

  s.homepage     = "https://github.com/NijiDigital/NetworkStack"
  s.license      = { :type => "Apache 2", :file => "LICENSE" }

  s.authors            = { "Niji" => "" }
  s.social_media_url   = "https://twitter.com/niji_digital"

  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/NijiDigital/NetworkStack.git", :tag => s.version.to_s }

  s.source_files = 'Sources/**/*.swift'

  s.ios.framework  = 'MobileCoreServices'

  s.dependency 'Alamofire', '~> 4.0'
  s.dependency 'RxSwift'

  s.dependency 'KeychainAccess', '~> 4.1.0'
end
