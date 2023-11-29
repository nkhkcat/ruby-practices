#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

COLUMNS_NUMBER = 3

def main
  options = parse_options
  files = Dir.entries(path).sort.delete_if { |file_name| !options[:show_all] && file_name.start_with?('.') }
  files.reverse! if options[:reverse]
  if options[:long_format]
    show_long_format_info(files, options[:show_all])
    exit 0
  end
  show_file_name_in_columns(files)
end

def parse_options
  options = {}
  OptionParser.new do |opt|
    opt.on('-a') { options[:show_all] = true }
    opt.on('-r') { options[:reverse] = true }
    opt.on('-l') { options[:long_format] = true }
  end.parse!(ARGV)
  options
end

def path
  path = ARGV.empty? ? '.' : ARGV[0]
  if !Dir.exist?(path) && !File.exist?(path)
    puts "ls: #{ARGV[0]}: No such file or directory"
    exit(1)
  end
  path
end

def split_array_vertically(input_array, columns_number)
  return [] if input_array.empty? || columns_number.zero?

  elements_number = (input_array.size / columns_number.to_f).ceil
  result = Array.new(elements_number) { [] }
  input_array.each_with_index do |item, index|
    target_group = index % elements_number
    result[target_group] << item
  end
  result
end

def show_file_info(path)
  file_stat = File.stat(path)
  permissions = permissions_to_s(file_stat.mode, path)
  hard_link_number = file_stat.nlink.to_s.rjust(2)
  owner_name = Etc.getpwuid(file_stat.uid).name
  group_name = Etc.getgrgid(file_stat.gid).name.ljust(3)
  file_size = file_stat.size.to_s.rjust(6)
  last_modified = file_stat.mtime.strftime('%m %e %H:%M')
  file_name = File.basename(path)

  puts "#{permissions} #{hard_link_number} #{owner_name} #{group_name} #{file_size} #{last_modified} #{file_name}"
end

def permissions_to_s(mode, path)
  type = File.directory?(path) ? 'd' : '-'
  perms = ['', '', '']
  [64, 8, 1].each_with_index do |shift, i|
    perms[i] += mode & (shift << 2) != 0 ? 'r' : '-'
    perms[i] += mode & (shift << 1) != 0 ? 'w' : '-'
    perms[i] += mode & shift != 0 ? 'x' : '-'
  end

  "#{type}#{perms.join}"
end

def total_blocks(directory, show_all)
  Dir.foreach(directory).sum do |file|
    next 0 if ['.', '..'].include?(file) || (!show_all && file.start_with?('.'))

    File.stat(File.join(directory, file)).blocks
  end
end

def show_long_format_info(files, show_all)
  puts "total #{total_blocks(path, show_all)}"
  files.each do |file|
    file_path = "#{path}/#{file}"
    show_file_info(file_path)
  end
end

def show_file_name_in_columns(files)
  max_file_name_length = files.max_by(&:length).length
  vertical_array = split_array_vertically(files, COLUMNS_NUMBER)
  vertical_array.each do |file_array|
    print file_array.map { |file| file.ljust(max_file_name_length) }.join('        ')
    puts
  end
end

main
