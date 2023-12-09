#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  ARGV.empty? ? count_and_print_stdin_data : count_and_print_file_data
end

def count_and_print_stdin_data
  line_count = word_count = byte_count = 0

  ARGF.each_line do |line|
    line_count += 1
    word_count += line.split.size
    byte_count += line.bytesize
  end

  puts line_count.to_s.rjust(8) + word_count.to_s.rjust(8) + byte_count.to_s.rjust(8)
end

def count_and_print_file_data
  options = parse_options
  ARGV.each do |arg|
    text = File.read(arg)

    total_lines = text.lines.count.to_s.rjust(8)
    total_words = count_words(text).to_s.rjust(8)
    total_bytes = text.bytesize.to_s.rjust(8)
    file_name = " #{File.basename(arg)}"

    if options.empty?
      puts total_lines + total_words + total_bytes + file_name
    else
      print total_lines if options[:line_count]
      print total_words if options[:word_count]
      print total_bytes if options[:byte_count]
      print file_name
      puts
    end
  end
end

def parse_options
  options = {}
  OptionParser.new do |opt|
    opt.on('-l') { options[:line_count] = true }
    opt.on('-w') { options[:word_count] = true }
    opt.on('-c') { options[:byte_count] = true }
  end.parse!(ARGV)
  options
end

def count_words(str)
  ary = str.split(/\s+/)
  ary.size
end

main
