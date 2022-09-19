require 'fastlane/action'
require_relative '../helper/androidsdk_helper'

module Fastlane

	module Actions

		class AvdmanagerExecuteAction < Action

			def self.run(params)
				FastlaneCore::PrintTable.print_values(
					config: params,
					title: 'ADV Manager Execute Summary'
				)

				sdk_path = params[:sdk_path]
				name = params[:name]
				package = params[:package]
				device = params[:device]
				size = params[:size]
				port = params[:port]
				location = params[:location]
				demo_mode = params[:demo_mode]
				cold_boot = params[:cold_boot]
				block = params[:block]
				avdmanager = Helper::AndroidSDK::AVDManager.new(params)
				adb = Helper::AndroidSDK::ADB.new(params)

				UI.message('Creating android emulator...')
				avdmanager.create(params)

				UI.message('Starting android emulator...')

				system("LC_NUMERIC=C;")

				command = "#{sdk_path}/emulator/emulator @#{name} -port #{port}"
				sh("#{command} > /dev/null 2>&1 &")
				sh("#{adb.path} -e wait-for-device")

				pid = Actions.sh(
					"pgrep -f '@#{name} -port #{port}'",
					error_callback: ->(_) { }
				)

				until Actions.sh("#{adb.path} -e shell getprop dev.bootcomplete", log: false).strip == "1"
					sleep(5)
				end

				if location
					UI.message("Set location")
					sh("LC_NUMERIC=C; #{adb.path} emu geo fix #{location}")
				end

				if demo_mode
					UI.message("Set in demo mode")
					sh("#{adb.path} -e shell settings put global sysui_demo_allowed 1")
					sh("#{adb.path} -e shell am broadcast -a com.android.systemui.demo -e command clock -e hhmm 0700")
				end

				ENV['SCREENGRAB_SPECIFIC_DEVICE'] = "emulator-#{port}"

				begin
					block.call(name)
				ensure
					UI.message 'Deleting android emulator...'
					avdmanager.delete(params)

					unless pid.empty?
						UI.message 'Stopping appium server...'
						sh("kill #{pid}")
					end
				end
			end

			#####################################################
			# @!group Documentation
			#####################################################

			def self.description
				'Creates a new AVD, executes the given block, and then deletes the AVD'
			end

			def self.available_options
				[
					FastlaneCore::ConfigItem.new(
						key: :sdk_path,
						env_name: 'AVDMANAGER_EXECUTE_SDK_PATH',
						description: 'Path to the Android sdk',
						default_value: ENV['ANDROID_HOME'] || ENV['ANDROID_SDK_ROOT'] || ENV['ANDROID_SDK']
					),
					FastlaneCore::ConfigItem.new(
						key: :name,
						env_name: 'AVDMANAGER_EXECUTE_NAME',
						description: 'Name of the device',
						type: String,
						default_value: 'fastlane'
					),
					FastlaneCore::ConfigItem.new(
						key: :package,
						env_name: 'AVDMANAGER_EXECUTE_PACKAGE',
						description: 'The selected system image of the emulator',
						type: String,
						default_value: 'system-images;android-25;google_apis;x86'
					),
					FastlaneCore::ConfigItem.new(
						key: :device,
						env_name: 'AVDMANAGER_EXECUTE_DEVICE',
						description: 'The selected system image of the emulator',
						type: String,
						default_value: 'pixel'
					),
					FastlaneCore::ConfigItem.new(
						key: :size,
						env_name: 'AVDMANAGER_EXECUTE_SIZE',
						description: 'The selected system image of the emulator',
						type: String,
						default_value: '4096M'
					),
					FastlaneCore::ConfigItem.new(
						key: :port,
						env_name: "AVDMANAGER_EXECUTE_PORT",
						description: 'Port of the emulator',
						type: String,
						default_value: "5554"
					),
					FastlaneCore::ConfigItem.new(
						key: :location,
						env_name: 'AVDMANAGER_EXECUTE_LOCATION',
						description: "Set location of the emulator '<longitude> <latitude>'",
						type: String,
						optional: true
					),
					FastlaneCore::ConfigItem.new(
						key: :demo_mode,
						env_name: 'AVDMANAGER_EXECUTE_DEMO_MODE',
						description: 'Set the emulator in demo mode',
						type: Boolean,
						default_value: true
					),
					FastlaneCore::ConfigItem.new(
						key: :cold_boot,
						env_name: 'AVDMANAGER_EXECUTE_COLD_BOOT',
						description: 'Create a new AVD every run',
						type: Boolean,
						default_value: false
					),
					FastlaneCore::ConfigItem.new(
						key: :block,
						description: 'Block to execute',
						type: Proc
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

