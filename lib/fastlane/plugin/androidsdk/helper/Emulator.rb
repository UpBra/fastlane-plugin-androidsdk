require 'fastlane_core/ui/ui'

module Fastlane

	UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

	class Emulator
		attr_accessor :name, :device, :api, :platform

		def initialize(device: 'pixel', api: 'android-32', platform: 'google_apis')
			@name = [device, api, platform].join('_').gsub(' ', '_')
			@device = device
			@api = api
			@platform = platform
		end

		def to_s
			@name
		end
	end
end
