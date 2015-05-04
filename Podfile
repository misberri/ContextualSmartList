platform :ios, "7.0"

source 'https://github.com/CocoaPods/Specs.git'
log_level = 'VERBOSE_LOG=1' #'WARN_LOG=1 etc'

target "GeoSmart" do 
    pod 'RCLocationManager', :git => "https://github.com/rcabamo/RCLocationManager"
    pod 'libextobjc'			          # useful things like @weakify
    pod 'CocoaLumberjack', '~> 1.9.1'             # logging platform: can log to screen, files, with different levels
    pod 'LumberjackConsole', '~> 2.0.2'             # display the console view from within the app (can be only for debug mode)
    pod 'ReactiveCocoa'                           # functional programming
    pod 'Reachability'                            # tools to detect when servers are available
    pod 'AFNetworking-RACExtensions'              # reactive cocoa extenisons to AFNetworking
    pod 'ReactiveViewModel'                       # reactive cocoa complement: MVVM pattern
    pod 'Masonry', '~>0.6' #:git => "https://github.com/Masonry/Masonry"  # UI - to auto layout more easily
    pod 'BOString'                                # UI - to create formatted strings
    pod 'ISHPermissionKit'                        # makes it easier to request permissions from the user
    pod 'ABUtils',                    :git => "https://github.com/agathe/ABUtils"
    pod 'Mantle', '~> 1.5'                  # object model with serialization
end

target "GeoSmartTests" do
  pod 'Expecta', '~> 0.2.0'
  pod 'XCAsyncTestCase'
  pod 'OCMockito'
end
