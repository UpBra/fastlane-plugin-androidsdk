require 'fastlane/action'
require_relative '../helper/androidsdk_helper'

module Fastlane

	module Actions

		class SdkmanagerFindAction < Action

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'ADV Manager Package Summary'
				)

				sdkmanager = Helper::AndroidSDK::SDKManager.new(params)
				api = params[:api]
				platform = params[:platform]
				results = sdkmanager.system_image(api, platform)

				UI.header "Here"
				UI.message "Count: #{results.count}"
				UI.message results
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Delete an AVD'
			end

			def self.available_options
				[
					FastlaneCore::ConfigItem.new(
						key: :sdk_path,
						env_name: 'ADVMANAGER_PACKAGE_SDK_PATH',
						description: 'Path to the Android sdk',
						default_value: ENV['ANDROID_HOME'] || ENV['ANDROID_SDK_ROOT'] || ENV['ANDROID_SDK']
					),
					FastlaneCore::ConfigItem.new(
						key: :api,
						env_name: 'AVDMANAGER_SYSTEM_IMAGE_API',
						description: 'API version',
						type: String
					),
					FastlaneCore::ConfigItem.new(
						key: :platform,
						env_name: 'AVDMANAGER_SYSTEM_IMAGE_PLATFORM',
						description: 'Platform name',
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
