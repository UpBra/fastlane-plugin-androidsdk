module Fastlane

	module Actions

		module SharedValues
			AVDMANAGER_CREATE_CUSTOM_VALUE = :AVDMANAGER_CREATE_CUSTOM_VALUE
		end

		class AvdmanagerCreateAction < Action

			def self.run(params)
				sdk_path = params[:sdk_path]

				sh "#{sdk_path}/cmdline-tools/latest/bin/avdmanager list device"
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				"A short description with <= 80 characters of what this action does"
			end

			def self.details
				# Optional:
				# this is your chance to provide a more detailed description of this action
				"You can use this action to do cool things..."
			end

			def self.available_options
				# Define all options your action supports.

				# Below a few examples
				[
					FastlaneCore::ConfigItem.new(
						key: :sdk_path,
						env_name: "AVDMANAGER_CREATE_SDK_PATH",
						description: "Path to the Android sdk",
					),
					FastlaneCore::ConfigItem.new(
						key: :development,
						env_name: "FL_AVDMANAGER_CREATE_DEVELOPMENT",
						description: "Create a development certificate instead of a distribution one",
						is_string: false, # true: verifies the input is a string, false: every kind of value
						default_value: false
					)
				]
			end

			def self.output
				# Define the shared values you are going to provide
				# Example
				[
					['AVDMANAGER_CREATE_CUSTOM_VALUE', 'A description of what this value contains']
				]
			end

			def self.return_value
				# If your method provides a return value, you can describe here what it does
			end

			def self.authors
				# So no one will ever forget your contribution to fastlane :) You are awesome btw!
				["UpBra"]
			end

			def self.is_supported?(platform)
				true
			end
		end
	end
end
