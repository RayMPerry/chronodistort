(local *sprite-width* 17)
(local *sprite-height* 17)

(local direction { :up 0 :right 1 :down 2 :left 3 })

(var player { :x 0
              :y 0
              :width *sprite-width*
              :height *sprite-height*
              :color { :r 255 :g 0 :b 0 }
              :direction direction.up
              :sprite { :column 24 :row 12 } })

(var sprites (love.graphics.newImage "assets/tilesheet/monochrome.png"))
(love.graphics.setNewFont "assets/fonts/Oxanium-Regular.ttf" 16)

(fn get-sprite [column row]
  (love.graphics.newQuad
    (* column *sprite-width*)
    (* row *sprite-height*)
    *sprite-width* *sprite-height* 815 373))

(fn change-sprite [delta-x delta-y]
  (tset player :sprite
    { :column (lume.clamp (+ player.sprite.column delta-x) 0 47)
      :row (lume.clamp (+ player.sprite.row delta-y) 0 21) })
  (pp player.sprite))

(var deck (love.graphics.newSpriteBatch sprites))
(: deck :add (get-sprite 24 12) 0 0)
(: deck :add (get-sprite 25 13) 0 16)
(: deck :add (get-sprite 25 13) 0 32)
(: deck :add (get-sprite 25 13) 0 48)

(fn draw-player [player]
  (let [{ :x x
          :y y
          :width width
          :height height
          :color color
          :direction direction
          :sprite { :column column :row row } } player]
    (love.graphics.rectangle "line" (* width x) (* height y) 16 16)
    (love.graphics.draw sprites
      (get-sprite column row)
      (* width x) (* height y)
      (* 90 (/ math.pi 180) direction)
      1 1
      7 7)))
      

(fn move-player [key]
  (set player.x
    (+ player.x (if (= key "left") -1 0) (if (= key "right") 1 0)))
  (set player.y
    (+ player.y (if (= key "up") -1 0) (if (= key "down") 1 0)))
  (set player.direction
    (match key
      "left" direction.left
      "right" direction.right
      "up" direction.up
      "down" direction.down
      _ player.direction)))

(fn activate [])

(fn update [dt])

(fn draw []
  (draw-player player)
  (love.graphics.print "Etiam laoreet quam sed arcu." 4 124))

(fn keypressed [key]
  (match key
    "1" (change-sprite -1 0)
    "2" (change-sprite 1 0)
    "3" (change-sprite 0 -1)
    "4" (change-sprite 0 1))
  (move-player key))

{ :activate activate
  :update update
  :draw draw
  :keypressed keypressed }
