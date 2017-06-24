require 'fileutils'
require 'english'
require 'io/console'
require_relative '../_vendor/inquirer/lib/inquirer'

SOURCE_DIR     = File.expand_path('../..', __FILE__).freeze
MACOS_DOTFILES = %w(.DS_Store .CFUserTextEncoding .Trash).map { |file| "#{Dir.home}/#{file}" }
LOCAL_DOTFILES = Dir["#{Dir.home}/.[^.]*"]
IGNORE         = if File.exist?("#{SOURCE_DIR}/.spawnignore")
                   File.read("#{SOURCE_DIR}/.spawnignore")
                       .split("\n")
                       .reject { |line| line.empty? || line.strip[0] == '#' }
                       .map { |file| File.expand_path("#{SOURCE_DIR}/#{file}") }
                 else
                   []
                 end

OPTIONS = ARGV.select { |x| x =~ /^-[a-z]+$/ || x == '--help' }
              .map    { |x| x[1..-1].split('').map(&:to_sym) }
              .flatten
