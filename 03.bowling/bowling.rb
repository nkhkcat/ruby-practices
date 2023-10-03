#!/usr/bin/env ruby

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
sum_point = 0
sum_point = shots.sum

frames = []
shots.each_slice(2) do |s|
  frames << s
end

# ストライクとスペアによる加算をする
add_strike_point = 0
add_spare_point = 0

number = 8 # ストライクかスペアによる加算の対象である9フレーム目まで配列を回すための数
for i in 0..number do
	if frames[i][0] == 10 # ストライクの場合
		if frames[i+1][0] == 10 # 2連続ストライクの場合
			add_strike_point += frames[i+1][0] + frames[i+2][0]
		else
			add_strike_point += frames[i+1].sum
		end
	elsif frames[i].sum == 10 # スペアの場合
		add_spare_point += frames[i+1][0]
	end
end

total_point = sum_point + add_strike_point + add_spare_point
puts total_point