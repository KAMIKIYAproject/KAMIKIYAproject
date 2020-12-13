
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
        @flame = 5 * 60    # 試しで５秒分
        
        # 現在のフレームを参照する
        @current_flame = 0
        
        # レーンの数
        @lane = lane_pos_xs.length

        # 譜面を作成(枠だけ，中身は後で詰める)
#        @notes = Array.new(@flame){|i| Array.new(@lane){|j| Note.new(lane_pos_xs[j], 20, note_imgs[j], note_keycodes)}}
        @notes = Array.new(@flame) do |i| Array.new(@lane) do |j| {note: nil, move: false} end end
        
        # 譜面をセット(中身を詰めたり)
        self.set_notes
    end
    
#    def initialize(filepath)
#        @filepath = filepath    # ゆくゆくはファイルから譜面を読みたい。
#   end
    
    # 更新するメソッド update
    # 毎フレームよぶ
    # able_keydowns: レーンごとのキー押せるかフラグ
    def update(able_keydowns)

        # カレントフレームの表示
        p format("current flame:[%d]", @current_flame)
        # lengthが異なったら表示しておく(念のため)
        if able_keydowns.length != @lane
            p_ format("Length of Lane is not equal length of able_keydowns.")
        end
        
        # currentにあるノーツを出現させる
        if @current_flame < @notes.length then
            @notes[@current_flame].each_with_index do |note, i|
                if note[:note] != nil then
                    @notes[@current_flame][i][:note].y = 10     # 汚い書き方だがこうしないと値を更新できないっぽい，以降も同じ
                    @notes[@current_flame][i][:move] = true
                end
            end
        end
            
        # moveがtrueのノーツを更新
        @notes.each_with_index do |notes, i| notes.each_with_index do |note, j|
            # 出現済みかつ消されていないとき
            if note[:move] and !note[:note].vanished? then
                @notes[i][j][:note].draw
                @notes[i][j][:note].update(able_keydowns[j])
            end
        end end
            
        # カレントを進める
        @current_flame += 1
    end
    
    # notesをセットする
    def set_notes
        p "set start"
        @notes.each_with_index do |lane, flame| lane.each_with_index do |note_and_move, jndex|
            #p format("set a, flame:[%d], j:[%d]", flame, jndex)
            if flame % 60 == 30 then  # テスト用に0.5秒に１回降るように。
                #note.vanish # killしておく
               # p "set b"
                # if jndex % 2 == 1 then
                    @notes[flame][jndex][:note] = Note.new(@lane_pos_xs[jndex], -50, @note_imgs[jndex], @note_keycodes[jndex])
                # else
                #     @notes[flame][jndex][:note] = Note.new(@lane_pos_xs[jndex], -50, @note_imgs[jndex], @note_keycodes)
                # end
                #p "set c"
            end
            @notes[flame][jndex][:move] = false
        end end
        p "set end"
    end
end