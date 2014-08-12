Pod::Spec.new do |s|

  s.name         = 'SFMapping'
  s.version      = '0.0.3'
  s.summary      = 'Object mapping.'

  s.homepage     = 'http://dev.stanfy.com'
  s.license      = 'MIT'

  s.author       = { 'Paul Taykalo' => 'ptaykalo@stanfy.com.ua' }

  s.source       = { :git => 'https://github.com/stanfy/SFObjectMapping.git', :tag => '0.0.3' }

  s.platform     = :ios, '4.3'

  s.source_files = 'Classes/*.{h,m}'
  s.requires_arc = true

end
