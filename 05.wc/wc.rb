#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  ARGV.empty? ? count_and_print_stdin_data : count_and_print_file_data
end

def count_and_print_stdin_data
  line_count = word_count = byte_count = 0
  max_count_length = 0

  ARGF.each_line do |line|
    line_count += 1
    word_count += line.split.size
    byte_count += line.bytesize
  end

  current_max_count_length = [line_count, word_count, byte_count].max.to_s.length
  max_count_length = current_max_count_length if max_count_length < current_max_count_length

  puts "    #{line_count.to_s.rjust(max_count_length)}    #{word_count.to_s.rjust(max_count_length)}    #{byte_count.to_s.rjust(max_count_length)}"
end

def count_and_print_file_data
  options = parse_options
  total_line_count = total_word_count = total_byte_count = 0

  max_count_length = calc_max_counts_length

  ARGV.each do |file_name|
    text = File.read(file_name)
    line_count = text.lines.count
    word_count = text.split.size
    byte_count = text.bytesize

    total_line_count += line_count
    total_word_count += word_count
    total_byte_count += byte_count

    formatted_counts = format_counts(line_count, word_count, byte_count, options, max_count_length)
    puts "#{formatted_counts} #{File.basename(file_name)}"
  end

  return unless ARGV.size >= 2

  total_formatted_counts = format_counts(total_line_count, total_word_count, total_byte_count, options, max_count_length)
  puts "#{total_formatted_counts} total"
end

def calc_max_counts_length
  max_count_length = 0
  ARGV.each do |file_name|
    text = File.read(file_name)
    line_count = text.lines.count
    word_count = text.split.size
    byte_count = text.bytesize

    current_max_count_length = [line_count, word_count, byte_count].max.to_s.length
    max_count_length = current_max_count_length if max_count_length < current_max_count_length
  end
  max_count_length
end

def format_counts(line_count, word_count, byte_count, options, max_count_length)
  output = ''
  output += "    #{line_count.to_s.rjust(max_count_length)}" if options.empty? || options[:line_count]
  output += "    #{word_count.to_s.rjust(max_count_length)}" if options.empty? || options[:word_count]
  output += "    #{byte_count.to_s.rjust(max_count_length)}" if options.empty? || options[:byte_count]
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

main
