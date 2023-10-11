#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

# 倒したピンの数のみを合計する
sum_point = shots.sum

frames = []
shots.each_slice(2) do |s|
  frames << s
end

# ストライクとスペアによる加算をする
strike_point = 0
spare_point = 0

frames.each_with_index do |frame, i|
  break if i == 9

  if frame[0] == 10 # ストライクの場合
    if frames[i + 1][0] == 10 # 2連続ストライクの場合
      strike_point += frames[i + 1][0]
      strike_point += frames[i + 2][0]
    else
      strike_point += frames[i + 1].sum
    end
  elsif frame.sum == 10 # スペアの場合
    spare_point += frames[i + 1][0]
  end
end

total_point = sum_point + strike_point + spare_point
puts total_point
