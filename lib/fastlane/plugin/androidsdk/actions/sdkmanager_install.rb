require 'fastlane/action'
require_relative '../helper/androidsdk_helper'

module Fastlane

	module Actions

		class SdkmanagerInstallAction < Action

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'SDK Manager Install Summary'
				)

				UI.message "Installing package path: #{params[:package_path]}"

				sdkmanager = Helper::AndroidSDK::SDKManager.new(params)
				results = sdkmanager.install_system_image(params)
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Install a package with sdkmanager'
			end

			def self.available_options
				[
					FastlaneCore::ConfigItem.new(
						key: :sdk_path,
						env_name: 'SDKMANAGER_INSTALL_SDK_PATH',
						description: 'Path to the Android sdk',
						default_value: ENV['ANDROID_HOME'] || ENV['ANDROID_SDK_ROOT'] || ENV['ANDROID_SDK']
					),
					FastlaneCore::ConfigItem.new(
						key: :package_path,
						env_name: 'SDKMANAGER_INSTALL_PACKAGE_PATH',
						description: 'API version',
						type: String
					)
				]
			end

			def self.output
				[
					[]
				]
			end

			def self.return_value
				'None'
			end

			def self.authors
				["UpBra"]
			end

			def self.is_supported?(platform)
				true
			end
		end
	end
end
