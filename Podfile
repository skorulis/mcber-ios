# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

def shared_pods
    use_frameworks!
    pod "FontAwesomeKit", :git => 'https://github.com/PrideChung/FontAwesomeKit'
    pod 'SnapKit'
    pod 'Fabric'
    pod 'Crashlytics'
    pod "PromiseKit"
    pod "ObjectMapper"
end

target 'Mcber' do
	shared_pods
end

target 'McberTests' do
    shared_pods
end
