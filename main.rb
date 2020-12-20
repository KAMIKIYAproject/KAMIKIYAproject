require 'dxopal'
include DXOpal

# 分割した他のソースコードを引き込む
# require_remote 'note.rb'
require_remote 'music.rb'

# 画像の読み込み
# Image.register(:note, 'images/player.png')
Image.register(:notea, 'images/note_a.png')
Image.register(:noteb, 'images/note_b.png')
Image.register(:notec, 'images/note_c.png')
Image.register(:noted, 'images/note_d.png')
Image.register(:playing, 'images/back1.png')
Image.register(:opening, 'images/back2.png')
Image.register(:result, 'images/back3.png')

Sound.register(:play_sound, 'sounds/maou_14_shining_star.mp3')


Window.load_resources do

	# 画面サイズの決定
	Window.width  = 800
	Window.height = 600
	
	# 画像の設定
	play_img = Image[:playing]
	opening_img = Image[:opening]	#op画像
	result_img = Image[:result]
	
	notea_img = Image[:notea]
	notea_img.set_color_key([255, 255, 255])
	noteb_img = Image[:noteb]
	noteb_img.set_color_key([255, 255, 255])
	notec_img = Image[:notec]
	notec_img.set_color_key([255, 255, 255])
	noted_img = Image[:noted]
	noted_img.set_color_key([255, 255, 255])
	
	# ノーマルモード用：４列    
	lane_pos_xs = [160, 320, 480, 640]      # レーンの位置(x座標のみ)
	note_imgs = [notea_img, noteb_img, notec_img, noted_img]    # ノーツ画像
	note_keycodes = [K_V, K_B, K_N, K_M]    # ノーツの反応するキー

	# 譜面を生成
	music = Music.new(lane_pos_xs, note_imgs, note_keycodes)

	# 判定用の基準線
	hantei1 = Window.height * 11 / 12
	hantei2 = Window.height * 10 / 12
	hantei3 = Window.height * 9 / 12
	
	# 判定用の基準線まとめ
	# :middleがOKライン
	hantei_lines = {:upper => hantei3, :middle => hantei2, :under => hantei1}
	
	# 画面切り替え用変数：mode
	mode = :title   # タイトル画面
	# mode = :play  # プレイ画面
	# mode = :result    # リザルト画面
	
	# メインループ
	Window.loop do
		
		# タイトル画面の表示とか
		if mode == :title
			Window.draw(0, 0, opening_img, z=0)	#画像表示
			
			# スペースキーでプレイ画面へ
			if Input.key_push?(K_SPACE)
			  mode = :play
			  
			  	# 譜面を新しく生成(リスタート用)
				music = Music.new(lane_pos_xs, note_imgs, note_keycodes)
				
				# 音楽を再生
				Sound[:play_sound].play
			end

		# プレイ中の表示や操作
		elsif mode == :play
			Window.draw(0, 0, play_img, z=0)
			
			# 緊急停止用(ポーズする)
			if Input.key_push?(K_BACK) or Input.key_push?(K_ESCAPE)
				Window.draw_font(0, 0, "end", Font.default, color: C_BLACK)
				Window.pause
			end
			
			# 判定線の表示		
			Window.draw_box(1, hantei1 , 800 , hantei1+1, C_RED)
			Window.draw_box(1, hantei2 , 800 , hantei2+1, C_RED)
			Window.draw_box(1, hantei3 , 800 , hantei3+1, C_RED)
	
			# 画面遷移：プレイが終わったらリザルト画面へ
			if music.update(hantei_lines)
				Sound[:play_sound].stop
				mode = :result
			end
		
		# リザルト画面の表示
		elsif mode == :result
			Window.draw(0, 0, result_img, z=0)

			# カウントの表示
			results = music.get_result	# 結果の取得
			Window.draw_font(500, 100, " OK  : #{results[:ok_count]}", Font.default, color: C_BLACK)
			Window.draw_font(500, 150, "miss : #{results[:miss_count]}", Font.default, color: C_BLACK)
			
			# スコアの計算と表示
			score = results[:ok_count] * 100 / (results[:ok_count] + results[:miss_count]) 
			Window.draw_font(100, 500, "score: #{score.to_f} %", Font.new(32), color: C_BLACK)
			
			# スコアに応じてランク付け(４段階)＆表示
			if score <= 25
				Window.draw_font(100, 100, " C ", Font.new(64), color: C_BLACK)
			elsif score <= 50
				Window.draw_font(100, 100, " B ", Font.new(64), color: C_BLUE)
			elsif score <= 75
				Window.draw_font(100, 100, " A ", Font.new(64), color: C_MAGENTA)
			elsif score <= 100
				Window.draw_font(100, 100, " S ", Font.new(64), color: C_RED)
			end
			
			# スペースキーでタイトルへ戻る
			if Input.key_push?(K_SPACE)
			   mode = :title 
			end
		end
	end

end