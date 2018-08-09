require_relative 'string_extensions'
require 'fileutils'
require 'mkmf'

module Dirwatch
  class Templates
    TEMPLATES_DIR = File.join __dir__, 'templates'

    class << self
      def create template:, operating_system:, verbose:, force:
        template ||= 'latex'
        template_data = templates[template]
        raise TemplateNotFoundError, template if template_data.nil?
        os = template_data[:operating_systems]
        raise OsNotSupportedError.new operating_system, os unless os.include? operating_system

        puts "creating #{template}"

        copy_file template_path(operating_system, template_data[:filename]),
          '.dirwatch.yml',
          force: force,
          verbose: verbose
      end

      def list operating_system:, verbose:
        puts "Operating system: #{operating_system}" if verbose
        puts 'All available templates:'
        templates(verbose: verbose).each do |template, data|
          os = data[:operating_systems]
          os_strings = os.map {|o| o == operating_system ? o.to_s.bold : o.to_s }
          template = template.bold if os.include? operating_system
          puts "  #{template} (#{os_strings.join(', ')})"
        end
      end

      private

      def template_path operating_system, filename
        File.join TEMPLATES_DIR, operating_system.to_s, filename
      end

      def templates verbose: false
        templates = {}
        OsFetcher::AVAILABLE.each do |os|
          file_matcher = File.join TEMPLATES_DIR, os.to_s, '*.yml'
          puts "  Searching files: #{file_matcher}" if verbose
          Dir[file_matcher].each do |template|
            filename = File.basename template
            name = filename.gsub(/\.yml$/, '')
            puts "    Found: #{template} (#{name})" if verbose
            (templates[name] ||= {
              filename: filename,
              operating_systems: [],
            })[:operating_systems] << os.to_sym
          end
        end
        templates
      end

      def copy_file source_file, target_file, force: false, verbose: false
        if File.exist? target_file
          update_file source_file, target_file, force: force, verbose: verbose
        else
          create_file source_file, target_file
        end
      end

      def update_file source_file, target_file, force: false, verbose: false
        if File.read(target_file) == File.read(source_file)
          puts "  #{'keep'.ljust(15)} #{target_file}"
        else
          print_diff source_file, target_file if verbose
          if force
            FileUtils.cp source_file, target_file
            puts "  #{'overwrite'.ljust(15).red} #{target_file}"
          else
            puts "  #{'already exists'.ljust(15).red} #{target_file}"
          end
        end
      end

      def create_file source_file, target_file
        FileUtils.cp source_file, target_file
        puts "  #{'created'.ljust(15).green} #{target_file}"
      end

      def print_diff source_file, target_file
        silence_mkmf
        if find_executable 'diff'
          cmd = "diff #{Shellwords.escape source_file} #{Shellwords.escape target_file}"
          puts "  #{cmd}"
          puts "  #{`#{cmd}`.gsub("\n", "\n  ")}"
        else
          puts "  #{'Command "diff" not found'.yellow}"
        end
      end

      def silence_mkmf
        return if MakeMakefile::Logging.quiet
        MakeMakefile::Logging.quiet = true
        MakeMakefile::Logging.logfile File::NULL
      end
    end
  end
end
