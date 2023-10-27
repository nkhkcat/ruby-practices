#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMNS_NUMBER = 3

def main
  opt = OptionParser.new
  opt.parse!(ARGV)
  if !Dir.exist?(ARGV[0]) && !File.exist?(ARGV[0])
    puts "ls: #{ARGV[0]}: No such file or directory"
    exit
  end

  path = ARGV.empty? ? '.' : ARGV[0]
  files = Dir.entries(path).delete_if { |file| file.start_with?('.') }.sort

  vertical_array = split_array_vertically(files, COLUMNS_NUMBER)

  vertical_array.each do |file_array|
    file_array.each do |file|
      printf('%-20s', file)
    end
    puts
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

main
