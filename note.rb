#
# purpose: ノーツの設定，OKとmissの設定
# function:
#	対応したキーがタイミングよく押されるとノーツが消える
#	OKとmissの設定と表示
# author: Mi
#

class Note < Sprite
	
	attr_reader :flag_show_ok, :flag_show_miss
	def initialize(x, y, image, keycode)
		super(x, y, image)
		@keycode = keycode	# 反応するキー
		@hantei2 = Window.height * 10 / 12	# OKの基準ライン
		@ok_count = 0	# OKを獲得した個数
		@miss_count = 0	# NGを獲得した個数
		@loop_count = 0	# ループカウンター：表示時間を計算する
		@mes_show_time = 20	# メッセージの表示時間
		@mes_show_height = 100	# メッセージの表示位置：高さのみ
		@flag_show_ok = false	# フラグ：たっている間は「OK」と表示
		@flag_show_miss = false	# フラグ：たっている間は「miss」と表示
	end
	
	# ノーツの状態を更新：消えるor消えない
	def update(ablekeydown)
		@ablekeydown = ablekeydown
		self.y += 1
		if ablekeydown and Input.key_push?(@keycode) == true
			# p "keydown"
			self.vanish
		end
	end
	
	# Ok or Missの評価をする
	# 表示フラグもたてる
	def hyouka(loop_count)
		@loop_count = loop_count
		if self.y + self.image.height >= @hantei2 and self.y <= @hantei2
			@flag_show_ok = true
			return true
		else
			@flag_show_miss = true
			return false
		end
	end
	
	# OKと表示する
	def show_ok(loop_count_af)
		if  @flag_show_ok == true
			dis = loop_count_af - @loop_count
			if dis <= @mes_show_time
				Window.draw_font(self.x, @mes_show_height, "OK", Font.default, color: C_BLACK)
			else
				@flag_show_ok = false	# なぞの条件式１，たぶん代入がしたい
			end
			@ok_count += 1
		end
	end
	
	# Missと表示する
	def show_miss(loop_count_af)
		if @flag_show_miss == true
			dis = loop_count_af - @loop_count
			if dis <= @mes_show_time
				Window.draw_font(self.x, @mes_show_height, "miss", Font.default, color: C_BLACK)
			else
				@flag_show_miss = false	# なぞの条件式２，たぶん代入がしたい
			end
			@miss_count += 1
		end
	end
end