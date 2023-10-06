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
blank_day_number = first_wday - 1

# カレンダーを表示する
print "      #{month}月 #{year}\n"

days = %w[日 月 火 水 木 金 土]
days.each do |day|
  print "#{day} "
end
print "\n"

# その月の初日の前まで空白を追加する
for num in 0..blank_day_number do
  print '   '
end

# 日付を表示する
i = 1
while i <= last_day.day
  if year == this_year && month == this_month && i == today	# 日付が今日の場合は色を反転させる
    print "\e[47m\e[30m"
    print " #{i}"
    print "\e[0m"
    print ' '
  elsif i <= 9 # 列を揃えるために、日付が一桁の場合は数字の前に半角スペースを1つ追加する
    print " #{i} "
  else
    print "#{i} "
  end

  # 合計7日で改行をする
  total_7day = i + first_wday
  if total_7day % 7 == 0
    print "\n"
  end

  i += 1
end

print "\n\n"
