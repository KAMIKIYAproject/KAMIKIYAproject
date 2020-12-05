require 'dxopal'
include DXOpal

require_remote 'note.rb'

Image.register(:note, 'images/player.png')


Window.load_resources do
    Window.width  = 800
    Window.height = 600
    
    note_img = Image[:note]
    note_img.set_color_key([0, 0, 0])
    
    notea = Note.new(100, 0, note_img, K_V)
    noteb = Note.new(200, 0, note_img, K_B)
    notec = Note.new(300, 0, note_img, K_N)
    noted = Note.new(400, 0, note_img, K_M)
    
    note = [notea,noteb,notec,noted]
    
    Window.loop do
    #  if Input.key_push?(K_B) == true
    #     p "test"
    #     note.vanish
    # end
    note.each do |n| 
         if !n.vanished?
           n.update
           n.draw
           
         end
    end

     
    end
  
end