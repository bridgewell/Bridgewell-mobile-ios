Pod::Spec.new do |s|

  s.name         = "BridgewellMAXSDK"
  s.version      = "3.4.0"
  s.summary      = "BridgewellMAXSDK is a lightweight framework that integrates directly with Prebid Server."

  s.description  = <<-DESC
    BridgewellMAXSDK is a lightweight framework increase yield for publishers by adding more mobile buyers."
    DESC
  s.homepage     = "https://www.bridgewell.com/"


  s.license      = { :type => "Apache License, Version 2.0", :text => <<-LICENSE
    Copyright 2018-2021 Prebid.org, Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    LICENSE
    }

  s.author                  = { "bridgewell.com, Inc." => 'https://www.bridgewell.com/en/contact/'}
  s.platform     	          = :ios, "12.0"
  s.swift_version 	        = '5.0'
  s.source                  = { :git => "https://github.com/bridgewell/Bridgewell-mobile-ios.git", :tag => "#{s.version}" }
  s.xcconfig 		            = { :LIBRARY_SEARCH_PATHS => '$(inherited)',  
			                          :OTHER_CFLAGS => '$(inherited)',
			                          :OTHER_LDFLAGS => '$(inherited)',
			                          :HEADER_SEARCH_PATHS => '$(inherited)',
			                          :FRAMEWORK_SEARCH_PATHS => '$(inherited)'
			                        }
  s.requires_arc = true
  s.vendored_frameworks = 'BridgewellMAXSDK/BridgewellMAXSDK.xcframework'
  s.user_target_xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }
  s.pod_target_xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }

  # Dependencies
  s.dependency 'BridgewellSDK', '3.4.0'
  s.dependency 'PrebidMobileMAXAdapters', '2.2.1'
  s.dependency 'AppLovinSDK', '12.4.2'

end
