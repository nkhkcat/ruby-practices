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
  total_line_count = total_word_count = total_byte_count = 0

  ARGV.each do |file_name|
    text = File.read(file_name)
    line_count = text.lines.count
    word_count = count_words(text)
    byte_count = text.bytesize

    total_line_count += line_count
    total_word_count += word_count
    total_byte_count += byte_count

    formatted_counts = format_counts(line_count, word_count, byte_count, options)
    puts "#{formatted_counts} #{File.basename(file_name)}"
  end

  return unless ARGV.size >= 2

  total_formatted_counts = format_counts(total_line_count, total_word_count, total_byte_count, options)
  puts "#{total_formatted_counts} total"
end

def format_counts(line_count, word_count, byte_count, options)
  output = ''
  output += line_count.to_s.rjust(8) if options.empty? || options[:line_count]
  output += word_count.to_s.rjust(8) if options.empty? || options[:word_count]
  output += byte_count.to_s.rjust(8) if options.empty? || options[:byte_count]
  output
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
