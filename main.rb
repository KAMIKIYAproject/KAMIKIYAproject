require 'dxopal'
include DXOpal

require_remote 'note.rb'

# Image.register(:note, 'images/player.png')
Image.register(:notea, 'images/note_a.png')
Image.register(:noteb, 'images/note_b.png')
Image.register(:notec, 'images/note_c.png')
Image.register(:noted, 'images/note_d.png')



Window.load_resources do
    Window.width  = 800
    Window.height = 600
    
    # note_img = Image[:note]
    # note_img.set_color_key([0, 0, 0])
    notea_img = Image[:notea]
    notea_img.set_color_key([1, 1, 1])
    noteb_img = Image[:noteb]
    noteb_img.set_color_key([1, 1, 1])
    notec_img = Image[:notec]
    notec_img.set_color_key([1, 1, 1])
    noted_img = Image[:noted]
    noted_img.set_color_key([1, 1, 1])
    
    notea = Note.new(100, 0, notea_img, K_V)
    noteb = Note.new(200, 0, noteb_img, K_B)
    notec = Note.new(300, 0, notec_img, K_N)
    noted = Note.new(400, 0, noted_img, K_M)
    
    note = [notea,noteb,notec,noted]
    
    hantei1 = Window.height*11/12
    hantei2 = Window.height*10/12
    hantei3 = Window.height*9/12
    
    Window.loop do
    #  if Input.key_push?(K_B) == true
    #     p "test"
    #     note.vanish

    # end
    Window.draw_box(1, hantei1 , 800 , hantei1+1, C_RED)
    Window.draw_box(1, hantei2 , 800 , hantei2+1, C_RED)
    Window.draw_box(1, hantei3 , 800 , hantei3+1, C_RED)

        note.each do |n| 
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
               
               n.draw
               
             end
             
             if n.y == hantei1
                n.vanish
             end
        
        end
     
    end
  
end