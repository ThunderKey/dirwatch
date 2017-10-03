require_relative 'string_extensions'
require 'fileutils'
require 'mkmf'

module Dirwatch
  class Templates
    TEMPLATES_DIR = File.join File.expand_path(File.dirname(__FILE__)), 'templates'

    def self.create template:, operating_system:, verbose:, force:
      template ||= 'latex'
      template_data = templates[template]
      raise TemplateNotFoundError, template if template_data.nil?
      os = template_data[:operating_systems]
      raise OsNotSupportedError, operating_systems, os unless os.include? operating_system

      puts "creating #{template}"

      copy_file File.join(TEMPLATES_DIR, operating_system.to_s, template_data[:filename]), File.join('.', 'dirwatch.yml'), force: force, verbose: verbose
    end

    def self.list operating_system:, verbose:
      puts "All available templates:"
      templates(verbose: verbose).each do |template, data|
        os = data[:operating_systems]
        os_strings = os.map {|o| o == operating_system ? o.to_s.bold : o.to_s }
        puts "  #{os.include?(operating_system) ? template.bold : template} (#{os_strings.join(', ')})"
      end
    end

    private

    def self.templates verbose: false
      templates = {}
      OsFetcher.available.each do |os|
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

    def self.copy_file source_file, target_file, force: false, verbose: false
      if File.exist? target_file
        if File.read(target_file) == File.read(source_file)
          puts "  #{'keep'.ljust(15)} #{target_file}"
        else
          if verbose
            silence_mkmf
            if find_executable 'diff'
              cmd = "diff #{Shellwords.escape source_file} #{Shellwords.escape target_file}"
              puts "  #{cmd}"
              diff = `#{cmd}`
              puts "  #{diff.gsub("\n", "\n  ")}"
            else
              puts "  #{'Command "diff" not found'.yellow}"
            end
          end
          if force
            FileUtils.cp source_file, target_file
            puts "  #{'overwrite'.ljust(15).red} #{target_file}"
          else
            puts "  #{'already exists'.ljust(15).red} #{target_file}"
          end
        end
      else
        FileUtils.cp source_file, target_file
        puts "  #{'created'.ljust(15).green} #{target_file}"
      end
    end

    def self.silence_mkmf
      unless MakeMakefile::Logging.quiet
        MakeMakefile::Logging.quiet = true
        MakeMakefile::Logging.logfile File::NULL
      end
    end
  end
end
