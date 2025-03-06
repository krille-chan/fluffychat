Pod::Spec.new do |s|
  s.name = 'fcm_shared_isolate'
  s.version = '0.0.1'
  s.summary = 'fixme'
  s.homepage = 'https://gitlab.com/famedly/libraries/fcm_shared_isolate'
  s.license = { :file => '../LICENSE' }
  s.author = { 'Famedly' => 'info@famedly.de' }
  s.source = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Firebase/Messaging'
  s.swift_version = '5.2'
  s.ios.deployment_target = '10.0'
  s.static_framework = true
end
