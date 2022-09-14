require 'fastlane_core/ui/ui'

module Fastlane
	UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

	module Helper

		module AndroidCommand

			def self.architecture
				arch = `arch`.strip.downcase

				return 'x86' if arch.include?('i386')
				return arch if arch.include?('arm')

				return 'x86'
			end
		end

		class Package
			attr_accessor :path, :version, :description

			def initialize(str)
				arr = str.split("|")
				@path = arr[0].strip
				@version = arr[1].strip
				@description = arr[2].strip
			end

			def to_s
				@path
			end

			def ==(other)
				@path == other.path &&
				@version == other.version &&
				@description == other.description
			end
		end

		class SDKManager

			attr_accessor :path

			def initialize(params)
				sdk_path = params[:sdk_path]
				latest = "#{sdk_path}/cmdline-tools/latest/bin/sdkmanager"

				unless File.exist?(latest)
					raise Exception.new "Failed to locate sdk manager executable"
				end

				@path = latest
			end

			def list
				command = "#{@path} --list"

				result = FastlaneCore::CommandExecutor.execute(
					command: command,
					print_all: false,
					print_command: false
				)

				output = result.split("Available Packages:").last
				lines = output.split("\n").select { |v| v.include?("|") }
				packages = lines.map { |v| Package.new(v) }.uniq
				packages
			end

			def system_image(api, platform)
				filter = list.select { |v| v.path.include?('system-image') }
				filter = filter.select { |v| v.path.include?("#{api};") }
				filter = filter.select { |v| v.path.include?("#{platform};") }
				filter = filter.select { |v| v.path.include?(AndroidCommand.architecture) }
				filter
			end
		end

		class AVDManager

			attr_accessor :path

			def initialize(params)
				sdk_path = params[:sdk_path]
				latest = "#{sdk_path}/cmdline-tools/latest/bin/avdmanager"

				unless File.exist?(latest)
					raise Exception.new "Failed to locate avd manager executable"
				end

				@path = latest
			end

			def list
				command = "#{sdkmanager_path} --list"

				result = FastlaneCore::CommandExecutor.execute(
					command: command,
					print_all: false,
					print_command: false
				)

				result.split("\n")
			end

			def create(params)
				name = params[:name]
				package = params[:package]
				device = params[:device]
				size = params[:size]

				command = "#{@path} create avd"
				command << " -n '#{name}'"
				command << " -k '#{package}'"
				command << " -d '#{device}'"
				command << " -c '#{size}'"
				command << " -f"

				FastlaneCore::CommandExecutor.execute(
					command: command,
					print_all: true,
					print_command: true
				)
			end
		end

		class ADB

			attr_accessor :path

			def initialize(params)
				sdk_path = params[:sdk_path]
				latest = "#{sdk_path}/platform-tools/adb"

				unless File.exist?(latest)
					raise Exception.new "Failed to locate ADB executable"
				end

				@path = latest
			end
		end
	end
end
