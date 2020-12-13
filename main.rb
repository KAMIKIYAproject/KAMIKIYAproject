require 'dxopal'
include DXOpal

require_remote 'note.rb'

# Image.register(:note, 'images/player.png')
Image.register(:notea, 'images/note_a.png')
Image.register(:noteb, 'images/note_b.png')
Image.register(:notec, 'images/note_c.png')
Image.register(:noted, 'images/note_d.png')
Image.register(:op, 'images/back1.png')

Window.load_resources do
    Window.width  = 800
    Window.height = 600
    
    # note_img = Image[:note]
    # note_img.set_color_key([0, 0, 0])
    play_img = Image[:op]
    notea_img = Image[:notea]
    notea_img.set_color_key([255, 255, 255])
    noteb_img = Image[:noteb]
    noteb_img.set_color_key([255, 255, 255])
    notec_img = Image[:notec]
    notec_img.set_color_key([255, 255, 255])
    noted_img = Image[:noted]
    noted_img.set_color_key([255, 255, 255])
    
    notea = Note.new(100, 300, notea_img, K_V)
    noteb = Note.new(200, 300, noteb_img, K_B)
    notec = Note.new(300, 300, notec_img, K_N)
    noted = Note.new(400, 300, noted_img, K_M)
    
    note = [notea,noteb,notec,noted]
    
    hantei1 = Window.height*11/12
    hantei2 = Window.height*10/12
    hantei3 = Window.height*9/12
    
    loop_count = 0
    
    # 画面切り替え用変数：mode
    # mode = :title   # タイトル画面
    mode = :play  # プレイ画面
    # mode = :result    # リザルト画面
    
    Window.loop do
        
        # タイトル画面の表示とか
        if mode == :title
            # コードを書く
        
        
        # プレイ中の表示や操作
        elsif mode == :play
            Window.draw(0, 0, play_img, z=0)
            
            if Input.key_push?(K_BACK)
                Window.draw_font(0, 0, "end", Font.default, color: C_BLACK)
                Window.pause
            end
        
            Window.draw_box(1, hantei1 , 800 , hantei1+1, C_RED)
            Window.draw_box(1, hantei2 , 800 , hantei2+1, C_RED)
            Window.draw_box(1, hantei3 , 800 , hantei3+1, C_RED)
    
            note.each do |n| 
                # p note.length
                if !n.vanished?
                    #n.update
                    flag_ablekeydown = false
                    if n.y+n.image.height >= hantei3 and n.y+n.image.height <= hantei1
                        flag_ablekeydown = true
                    end
                    if n.y+n.image.height >= hantei2 and n.y <= hantei2
                        Window.draw_box(1, hantei2 , 800 , hantei2+1, C_BLUE)
                    end
        
                    n.update(flag_ablekeydown)
        
                    if  n.vanished? == true
                        n.hyouka(loop_count)
                    end
    
                    n.draw
                   
                end
    
                n.show_ok(loop_count)
                n.show_miss(loop_count)
                # p "flag_show_ok(#{n.object_id}):#{n.flag_show_ok}"
                # p "flag_show_miss(#{n.object_id}):#{n.flag_show_miss}"
                 
                if n.y == hantei1
                    n.vanish
                end
            
            end
            loop_count += 1
        
        # リザルト画面の表示など
        elsif mode == :result
            # コードを書く
            
        end
    end
end