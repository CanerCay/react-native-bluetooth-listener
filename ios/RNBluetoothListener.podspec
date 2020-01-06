
Pod::Spec.new do |s|
  s.name         = "RNBluetoothListener"
  s.version      = "1.0.0"
  s.summary      = "RNBluetoothListener"
  s.description  = <<-DESC
                  RNBluetoothListener
                   DESC
  s.homepage     = "https://github.com/CanerCay/react-native-bluetooth-listener"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNBluetoothListener.git", :tag => "master" }
  s.source_files  = "RNBluetoothListener/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  
