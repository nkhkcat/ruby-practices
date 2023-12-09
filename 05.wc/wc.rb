#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  exit if ARGV.empty?

  # 標準入力を受け取る
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
