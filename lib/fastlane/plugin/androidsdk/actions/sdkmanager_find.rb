require 'fastlane/action'
require_relative '../helper/androidsdk_helper'

module Fastlane

	module Actions

		module SharedValues
			SDKMANAGER_FIND_RESULTS = :SDKMANAGER_FIND_RESULTS
			SDKMANAGER_FIND_FIRST = :SDKMANAGER_FIND_FIRST
			SDKMANAGER_FIND_FIRST_PATH = :SDKMANAGER_FIND_FIRST_PATH
		end

		class SdkmanagerFindAction < Action

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'SDK Manager Find Summary'
				)

				sdkmanager = Helper::AndroidSDK::SDKManager.new(params)
				api = params[:api]
				platform = params[:platform]
				results = sdkmanager.find_system_image(api, platform)

				UI.header 'SDK Manager Find Results'
				UI.message results

				if results.count > 1
					UI.header "SDK Manager Warning"
					UI.warning "#{results} system images found!"
					UI.warning "First result may not be the one you wanted!"
				end

				UI.user_error! 'Failed to locate system image sdk!' if results.empty?

				lane_context[SharedValues::SDKMANAGER_FIND_RESULTS] = results
				lane_context[SharedValues::SDKMANAGER_FIND_FIRST] = results.first
				lane_context[SharedValues::SDKMANAGER_FIND_FIRST_PATH] = results.first.path

				results
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Finds package details given a specific api and platform'
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
