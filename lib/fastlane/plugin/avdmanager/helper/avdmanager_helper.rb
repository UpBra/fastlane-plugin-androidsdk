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

			def self.adb_path(params)
				sdk_path = params[:sdk_path]

				unless File.exist?(sdk_path)
					UI.user_error! "Android SDK does not exist at path: #{sdk_path}"
				end

				adb_path = "#{sdk_path}/platform-tools/adb"

				if File.exist?(adb_path)
					return adb_path
				end

				UI.user_error! "Unable to locate adb executable!"
			end
		end
	end
end
