#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMNS_NUMBER = 3

def main
  show_file_names(file_names)
end

def file_names
  options = {}
  OptionParser.new { |opt| opt.on('-a') { options[:show_all] = true } }.parse!(ARGV)
  path = ARGV.empty? ? '.' : ARGV[0]
  if !Dir.exist?(path) && !File.exist?(path)
    puts "ls: #{ARGV[0]}: No such file or directory"
    exit(1)
  end

  if options[:show_all]
    Dir.entries(path).sort
  else
    Dir.entries(path).delete_if { |file_name| file_name.start_with?('.') }.sort
  end
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

def show_file_names(file_name_list)
  max_file_name_length = 0
  file_name_list.each do |file|
    max_file_name_length = file.length if file.length > max_file_name_length
  end

  vertical_array = split_array_vertically(file_name_list, COLUMNS_NUMBER)

  vertical_array.each do |file_array|
    file_array.each do |file|
      file_name = "#{file.ljust(max_file_name_length)}        "
      print file_name
    end
    puts
  end
end

main
