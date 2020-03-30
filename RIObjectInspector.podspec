# vi: ft=ruby

Pod::Spec.new do |s|
  s.name = "RIObjectInspector"
  s.version = "1.0.0"
  s.summary = "RIObjectInspector Library"

  s.description = <<-DESC
  RIObjectInspector Library for iOS
  DESC

  s.homepage = "https://www.rocketinsights.com"

  s.author = "Paul Calnan"

  s.source = { :git => "https://github.com/RocketLaunchpad/RIObjectInspector.git", :tag => "#{s.version}" }
  s.license = { :type => "MIT" }

  s.platform = :ios, "11.0"
  s.swift_version = "5.0"

  s.source_files = "Sources/RIObjectInspector/**/*.{swift,h,m}"
  s.resources = "Sources/RIObjectInspector/**/*.{storyboard,xcassets,strings,imageset,png}"
end

