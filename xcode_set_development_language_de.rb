#!/usr/bin/env ruby

require 'fileutils'
require 'xcodeproj'

unless ARGV.count == 2
	puts "Usage: xcode_set_development_region.rb [project] [region]"
  exit(1)
end

filename = ARGV[0]
region = ARGV[1]

raise "Argument '#{filename}' is not a valid .xcodeproject" unless filename && File.directory?(filename) && File.extname(filename).downcase == ".xcodeproj"

puts "Region to set: "

project = Xcodeproj::Project.open(filename)
project.root_object.development_region = region
project.save

puts "#{project.path}", "development_region = #{project.root_object.development_region}"