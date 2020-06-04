(var player { :x 0
              :y 0
              :width 50
              :height 50
              :color { :r 255 :g 0 :b 0 }
              :sprite { :row 30 :column 0 } })

(var sprites (love.graphics.newImage "assets/tilesheet/monochrome.png"))
(love.graphics.setNewFont "assets/fonts/Oxanium-Regular.ttf" 16)

(fn draw-player [player]
  (let [{:x x :y y :width width :height height :color color} player]
    (love.graphics.setColor (/ color.r 255) (/ color.g 255) (/ color.b 255) (/ 100 255))
    (love.graphics.rectangle "fill" x y width height)
    (love.graphics.setColor (/ color.r 255) (/ color.g 255) (/ color.b 255) 1)
    (love.graphics.rectangle "line" x y width height)
    (love.graphics.setColor 1 1 1 1)))

(fn get-sprite [relative-x relative-y]
  (love.graphics.newQuad
    (* relative-x 17)
    (* relative-y 17)
    17 17 815 373))

(fn change-sprite [delta-x delta-y]
  (tset player :sprite
    { :row (lume.clamp (+ player.sprite.row delta-x) 0 47)
      :column (lume.clamp (+ player.sprite.column delta-y) 0 21) })
  (pp player.sprite))

(fn activate [])

(fn update [dt]
  (when (love.keyboard.isDown "up")
    (set player.y (- player.y (* 50 dt))))
  (when (love.keyboard.isDown "down")
    (set player.y (+ player.y (* 50 dt))))
  (when (love.keyboard.isDown "left")
    (set player.x (- player.x (* 50 dt))))
  (when (love.keyboard.isDown "right")
    (set player.x (+ player.x (* 50 dt)))))

(fn draw []
  (love.graphics.draw sprites (get-sprite player.sprite.row player.sprite.column) player.x player.y)
  (love.graphics.print "Etiam laoreet quam sed arcu." 4 4))

(fn keypressed [key]
  (let [{ :sprite { :row row :column column } } player]
    (match key
      "1" (change-sprite -1 0)
      "2" (change-sprite 1 0)
      "3" (change-sprite 0 -1)
      "4" (change-sprite 0 1))))

{ :activate activate
  :update update
  :draw draw
  :keypressed keypressed }
