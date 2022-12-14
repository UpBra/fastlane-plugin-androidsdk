require 'fastlane/action'
require_relative '../helper/androidsdk_helper'

module Fastlane

	module Actions

		module SharedValues
			AVDMANAGER_CREATE_NAME = :AVDMANAGER_CREATE_NAME
		end

		class AvdmanagerCreateAction < Action

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'ADV Manager Create Summary'
				)

				avdmanager = Helper::AndroidSDK::AVDManager.new(params)
				avdmanager.create(params)
				avdname = params[:name]

				lane_context[SharedValues::AVDMANAGER_CREATE_NAME] = avdname

				avdname
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Create a new AVD'
			end

			def self.available_options
				[
					FastlaneCore::ConfigItem.new(
						key: :sdk_path,
						env_name: 'AVDMANAGER_CREATE_SDK_PATH',
						description: 'Path to the Android sdk',
						default_value: ENV['ANDROID_HOME'] || ENV['ANDROID_SDK_ROOT'] || ENV['ANDROID_SDK']
					),
					FastlaneCore::ConfigItem.new(
						key: :name,
						env_name: 'AVDMANAGER_CREATE_NAME',
						description: 'Name of the device',
						type: String,
						default_value: 'fastlane'
					),
					FastlaneCore::ConfigItem.new(
						key: :package,
						env_name: 'AVDMANAGER_CREATE_PACKAGE',
						description: 'The selected system image of the emulator',
						type: String,
						default_value: 'system-images;android-25;google_apis;x86'
					),
					FastlaneCore::ConfigItem.new(
						key: :device,
						env_name: 'AVDMANAGER_CREATE_DEVICE',
						description: 'The selected system image of the emulator',
						type: String,
						default_value: 'pixel'
					),
					FastlaneCore::ConfigItem.new(
						key: :size,
						env_name: 'AVDMANAGER_CREATE_SIZE',
						description: 'The selected system image of the emulator',
						type: String,
						default_value: '4096M'
					)
				]
			end

			def self.output
				[
					['AVDMANAGER_CREATE_NAME', 'The name of the AVD device that was created']
				]
			end

			def self.return_value
				'The name of the AVD device that was created'
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
