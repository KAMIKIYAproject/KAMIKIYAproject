class Note < Sprite
  
  attr_reader :flag_show_ok,:flag_show_miss
  def initialize(x, y, image, keycode)
    super(x, y, image)
    @keycode = keycode
    @hantei2 = Window.height*10/12
    @ok_count=0
    @miss_count=0
    @loop_count=0
    @flag_show_ok=false
    @flag_show_miss=false
  end
  
  def update(ablekeydown)
    @ablekeydown = ablekeydown
    self.y += 1
    # if self.y >= Window.height - self.image.height
    #   self.vanish
    # end
    if ablekeydown and Input.key_push?(@keycode) == true
        p "keydown"
        self.vanish
        # p self.vanished?
    end
  end
  def hyouka(loop_count)
    @loop_count = loop_count
    if self.y+self.image.height >= @hantei2 and self.y <= @hantei2
      # if self.vanished?
        @flag_show_ok=true
        p "a"
      # end
      return true
    # Window.draw_font(self.x, 100, "OK", Font.default, color: C_GREEN)
    # p "OK"
    # @ok_count += 1
    else
      # if self.vanished?
        @flag_show_miss=true
        p "b"
      # end
      return false
    # Window.draw_font(self.x, 100, "miss", Font.default, color: C_GREEN)
    # p "miss"
    # @miss_count += 1
    end
  end
  def show_ok(loop_count_af)
    p @flag_show_ok
    p @ablekeydown
    if  @flag_show_ok == true
      dis = loop_count_af - @loop_count
      p dis
      if dis <= 60# and @ablekeydown == true
        Window.draw_font(self.x, 100, "OK", Font.default, color: C_GREEN)
        p "OK"
      end
      @ok_count += 1
    end
  end
  
  def show_miss(loop_count_af)
    if @flag_show_miss == true 
      dis = loop_count_af - @loop_count
      p dis
      if dis <= 60# and @ablekeydown == true
        Window.draw_font(self.x, 100, "miss", Font.default, color: C_GREEN)
        p "miss"
      end
      @miss_count += 1
    end
  end
end