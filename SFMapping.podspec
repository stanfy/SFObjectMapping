Pod::Spec.new do |s|

  s.name         = "SFMapping"
  s.version      = "0.0.1"
  s.summary      = "Object mapping."

  s.homepage     = "http://dev.stanfy.com"
  s.license      = 'MIT'

  s.author       = { "Paul Taykalo" => "ptaykalo@stanfy.com.ua" }

  s.source       = { :git => "ssh://git@dev.stanfy.com:8822/object-mapping-ios.git" }

  s.platform     = :ios, '4.3'

  s.source_files = 'Classes/*{h,m}'
  s.requires_arc = true

end