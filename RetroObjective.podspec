Pod::Spec.new do |s|
		s.name 				= "RetroObjective"
		s.version 			= "0.0.1"
		s.summary         	= "Sort description of 'RetroObjective' framework"
	    s.homepage        	= "https://github.com/amine2233/RetroObjective"
	    s.license           = { type: 'MIT', file: 'LICENSE' }
	    s.author            = { 'Amine Bensalah' => 'amine.bensalah@outlook.com' }
	    s.ios.deployment_target = '10.0'
	    s.osx.deployment_target = '10.12'
	    s.tvos.deployment_target = '10.0'
	    s.watchos.deployment_target = '3.0'
	    s.requires_arc = true
	    s.source            = { :git => "https://github.com/amine2233/RetroObjective.git", :tag => s.version.to_s }
	    s.source_files      = "Sources/**/*.swift"
  		s.module_name = s.name
  		s.swift_version = "5.0"
  		s.pod_target_xcconfig = {
    		'SWIFT_VERSION' => s.swift_version.to_s
		}
		s.test_spec 'Tests' do |test_spec|
			test_spec.source_files = 'Tests/**/*.{swift}'
		end
	end
