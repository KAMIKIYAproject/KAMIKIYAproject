class Note < Sprite
  def initialize(x, y, image, keycode)
    super(x, y, image)
    @keycode = keycode
  end
  def update
    self.y += 1
    # if self.y >= Window.height - self.image.height
    #   self.vanish
    # end
    if Input.key_push?(@keycode) == true
        p "test"
        self.vanish
    end
  end
end