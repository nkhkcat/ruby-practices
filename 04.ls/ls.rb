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
  show_long_format_info(files, options[:show_all]) if options[:long_format]
  show_file_in_columns(files)
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
  permissions = permissions_to_s(file_stat.mode)
  hard_link_number = format('%2d', file_stat.nlink)
  owner_name = Etc.getpwuid(file_stat.uid).name
  group_name = format('%3s', Etc.getgrgid(file_stat.gid).name)
  file_size = format('%6d', file_stat.size)
  last_modified = file_stat.mtime.strftime('%m %e %H:%M')
  file_name = File.basename(path)

  puts "#{permissions} #{hard_link_number} #{owner_name} #{group_name} #{file_size} #{last_modified} #{file_name}"
end

def permissions_to_s(mode)
  type = (mode[0]).zero? ? '-' : 'd'

  perms = ['---', '---', '---'].map(&:+@)
  [['r', 256], ['w', 128], ['x', 64], ['r', 32], ['w', 16], ['x', 8], ['r', 4], ['w', 2], ['x', 1]].each_with_index do |(char, mask), i|
    perms[i / 3][i % 3] = char if mode & mask != 0
  end

  "#{type}#{perms.join}"
end

def total_blocks(directory, show_all)
  total = 0
  Dir.foreach(directory) do |file|
    next if ['.', '..'].include?(file)

    total += File.stat(File.join(directory, file)).blocks if show_all || !file.start_with?('.')
  end
  total
end

def show_long_format_info(files, show_all)
  puts "total #{total_blocks(path, show_all)}"
  files.each do |file|
    file_path = "#{path}/#{file}"
    show_file_info(file_path)
  end
  exit 0
end

def show_file_in_columns(files)
  max_file_name_length = 0
  files.each do |file|
    max_file_name_length = file.length if file.length > max_file_name_length
  end
  vertical_array = split_array_vertically(files, COLUMNS_NUMBER)
  vertical_array.each do |file_array|
    file_array.each do |file|
      file_name = "#{file.ljust(max_file_name_length)}        "
      print file_name
    end
    puts
  end
end

main
