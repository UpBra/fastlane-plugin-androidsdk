require 'fastlane_core/ui/ui'

module Fastlane
	UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

	module Helper

		class AVDManager

			def self.avdmanager_path(params)
				sdk_path = params[:sdk_path]

				unless File.exist?(sdk_path)
					UI.user_error! "Andoid SDK does not exist at path: #{sdk_path}"
				end

				latest = "#{sdk_path}/cmdline-tools/latest/bin/avdmanager"
				if File.exist?(latest)
					return latest
				end

				UI.user_error! "Unable to locate avdmanager executable!"
			end
		end
	end
end
