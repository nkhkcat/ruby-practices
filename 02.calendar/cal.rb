#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

# コマンドラインオプションで年月を取得する
options = ARGV.getopts('y:', 'm:')
is_year_nil = options['y'].nil?
is_month_nil = options['m'].nil?
year = options['y'].to_i
month = options['m'].to_i
this_year = Date.today.year
this_month = Date.today.month
today = Date.today.day
if is_year_nil && is_month_nil
  year = this_year
  month = this_month
elsif is_year_nil
  year = this_year
elsif is_month_nil
  puts 'コマンドラインオプション-mで月も指定して下さい'
  return
end
last_day = Date.new(year, month, -1)
first_wday = Date.new(year, month, 1).wday

# カレンダーを表示する
print "      #{month}月 #{year}\n"
%w[日 月 火 水 木 金 土].each { |day| print "#{day} " }
print "\n"

# その月の初日の前まで空白を追加する
0..first_wday.times { print '   ' }

# 日付を表示する
(1..last_day.day).each do |day|
  if year == this_year && month == this_month && day == today	# 日付が今日の場合は色を反転させる
    print "\e[47m\e[30m"
    print " #{day}"
    print "\e[0m"
    print ' '
  elsif day <= 9 # 列を揃えるために、日付が一桁の場合は数字の前に半角スペースを1つ追加する
    print " #{day} "
  else
    print "#{day} "
  end
  total_7days = day + first_wday
  print "\n" if (total_7days % 7).zero?
end

print "\n\n"
