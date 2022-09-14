require 'fastlane/action'
require_relative '../helper/avdmanager_helper'

module Fastlane

	module Actions

		class AvdmanagerDeleteAction < Action

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'ADV Manager Delete Summary'
				)

				name = params[:name]
				avdmanager_path = Helper::AVDManager.avdmanager_path(params)

				command = "#{avdmanager_path} delete avd"
				command << " -n '#{name}'"

				FastlaneCore::CommandExecutor.execute(
					command: command,
					print_all: true,
					print_command: true
				)
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
						env_names: ['AVDMANAGER_DELETE_SDK_PATH', 'AVDMANAGER_CREATE_SDK_PATH'],
						description: 'Path to the Android sdk',
						default_value: ENV['ANDROID_HOME'] || ENV['ANDROID_SDK_ROOT'] || ENV['ANDROID_SDK']
					),
					FastlaneCore::ConfigItem.new(
						key: :name,
						env_name: 'AVDMANAGER_DELETE_NAME',
						description: 'Name of the device',
						type: String,
						default_value: lane_context[SharedValues::AVDMANAGER_CREATE_NAME]
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
