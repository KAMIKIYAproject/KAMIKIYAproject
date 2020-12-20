#
# purpose: 譜面を管理するクラスMusic
# function: 
#    曲が流れる
#    譜面が曲に合わせて流れる(消化される)
# author: Ki

require_remote 'note.rb'

class Music
	# lane_pos_xs: レーンのx座標(リスト)
	# note_imgs: ノーツの画像たち(リスト)
	# note_keycodes: ノーツの反応するキーコードたち(リスト)
	def initialize(lane_pos_xs, note_imgs, note_keycodes)
		@lane_pos_xs = lane_pos_xs
		@note_imgs = note_imgs
		@note_keycodes = note_keycodes
		
		# サイズが違うならエラーをどっかに出す        
		if(lane_pos_xs.length != note_imgs.length)
			p "Error: not equal number of Lane and number of note-images."
		end
		
		# フレームに合わせて設置：１フレームは1/60秒とする(となっているはず)
		# あとで曲の秒数から計算して算出する
		@flame = 6 * 60    # 試しで５秒分
		
		# 現在のフレームを参照する
		@current_flame = 0
		
		# レーンの数
		@lane = lane_pos_xs.length

		# 譜面を作成(枠だけ，中身は後で詰める)
		@notes = Array.new(@flame) do |i| Array.new(@lane) do |j| {note: nil, move: false} end end
		
		# 譜面をセット(中身を詰めたり)
		self.set_notes
	end
	
	# def initialize(filepath)
	# 	@filepath = filepath    # ゆくゆくはファイルから譜面を読みたい。
	# end
	
	# 更新するメソッド update
	# 毎フレームよぶ
	# vanish_lines: 消すことができる範囲(ハッシュ)
	#               [:upper]：上ライン，[:middle]：中央ライン，[:under]：下ライン
	def update(vanish_lines)

		# カレントフレームの表示(デバッグ用)
		# p format("current flame:[%d]", @current_flame)
		
		# ノーツを出現させる
		self.pop(base_y=10)

		# moveがtrueのノーツを更新
		# head = Array.new(@lane + 1) do true end  # 先頭のみを消したかった
		@notes.each_with_index do |notes, i| notes.each_with_index do |note, j|
			if  note[:move] and !note[:note].vanished? then   # 出現済み # 消されてない
				@notes[i][j][:note].draw

				# 判定：消せるか
				able_keydown = false
				if  note[:note].y + note[:note].image.height >= vanish_lines[:upper] and
					note[:note].y + note[:note].image.height <= vanish_lines[:under] then

					able_keydown = true
				end
				
				# 先頭ひとつだけを消したかった
				# able_keydown &= head[j]
				# head[j] = false
				
				# 判定：OK判定ラインに乗っているか
				mergin = 5  # 判定の厳しさ(大きければ大きいほど厳しい)
				if  note[:note].y - note[:note].image.height + mergin >= vanish_lines[:middle] and
					note[:note].y + mergin <= vanish_lines[:middle] then
					
					able_keydown &= true
					# Window.draw_box(1, vanish_lines[:middle], 800, vanish_lines[:middle] + 1, C_BLUE)
				end
				
				# ノーツの状態を更新
				@notes[i][j][:note].update(able_keydown)
				
				# 最下層に来たら勝手に消える(ミスになる？)
				if !note[:note].vanished? and note[:note].y >= vanish_lines[:under] then
					note[:note].vanish
					note[:note].show_miss(@current_flame)
				end
				
				# ノーツがこのフレームで消えていたら表示を出す
				if note[:note].vanished?
					@notes[i][j][:note].hyouka(@current_flame)
				end
			end
			
			# ノーツごとに判定結果の表示を行う(おそらく１つのメソッドにできそう)
			if note[:note] != nil then
				note[:note].show_ok(@current_flame)
				note[:note].show_miss(@current_flame)
			end
		end
		end
		
		# カレントを進める
		@current_flame += 1
		
		# すべてのvanishしているノーツがいなくなったら(即座に)ゲームを終わる
		check_finish = true
		@notes.each do |notes| notes.each do |note| if note[:note] != nil then check_finish &= note[:note].vanished? end end end
		
		return check_finish
	end
	
	# notesをセットする
	def set_notes
		# p "set start"
		
		# 譜面マップ
		# 0がなし，1にノーツ
		music_map = 
			[
				# 0 sec
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[1,0,1,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],

				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],

				# 1 sec
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,1,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],

				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],

				# 2 sec
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,1,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],

				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],

				# 3 sec
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[1,0,0,1],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],

				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,1,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],

				# 4 sec
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,1,0,1],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],

				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],

				# 5 sec
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[1,1,1,1],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],

				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
				[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],
			]
		@notes.each_with_index do |lane, flame| lane.each_with_index do |note_and_move, jndex|
			# if flame % 60 == 13 and jndex == 0 then  # テスト用
			#     @notes[flame][jndex][:note] = Note.new(@lane_pos_xs[jndex], -50, @note_imgs[jndex], @note_keycodes[jndex])
			# end
			# if flame % 60 == 33 and jndex == 1 then  # テスト用
			#     @notes[flame][jndex][:note] = Note.new(@lane_pos_xs[jndex], -50, @note_imgs[jndex], @note_keycodes[jndex])
			# end
			# if flame % 60 == 53 and jndex == 2 then  # テスト用
			#     @notes[flame][jndex][:note] = Note.new(@lane_pos_xs[jndex], -50, @note_imgs[jndex], @note_keycodes[jndex])
			# end
			# if flame % 60 == 46 and jndex == 3 then  # テスト用
			#     @notes[flame][jndex][:note] = Note.new(@lane_pos_xs[jndex], -50, @note_imgs[jndex], @note_keycodes[jndex])
			# end
			
			# ハードモード用
			# if flame % 59 == 0 and jndex == 4 then
			#     @notes[flame][jndex][:note] = Note.new(@lane_pos_xs[jndex], -50, @note_imgs[jndex], @note_keycodes[jndex])
			# elsif flame % 47 == 0 and jndex == 5 then
			#     @notes[flame][jndex][:note] = Note.new(@lane_pos_xs[jndex], -50, @note_imgs[jndex], @note_keycodes[jndex])
			
			if music_map[flame][jndex] == 1 then
				@notes[flame][jndex][:note] = Note.new(@lane_pos_xs[jndex], -50, @note_imgs[jndex], @note_keycodes[jndex])
			end
			
			@notes[flame][jndex][:move] = false
		end end
		# p "set end"
	end
	

	# currentにあるノーツを出現させる
	# base_y: 現れるy座標
	def pop(base_y)
		if @current_flame < @notes.length then
			@notes[@current_flame].each_with_index do |note, i|
				if note[:note] != nil then
					@notes[@current_flame][i][:note].y = base_y     # 汚い書き方だがこうしないと値を更新できないっぽい，以降も同じ
					@notes[@current_flame][i][:move] = true
				end
			end
		end
	end
end