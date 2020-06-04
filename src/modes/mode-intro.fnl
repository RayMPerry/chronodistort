(var counter 0)
(var time 0)

(fn draw [message]
  (love.graphics.print
    (: "This window should close in %0.2f seconds"
      :format (- 3 time)) 32 16))

(fn update [dt set-mode]
  (if (< counter 65535)
    (set counter (+ counter 1))
    (set counter 0))
  (set time (+ time dt))
  (when (> time 3)
    (love.event.quit)))

(fn keypressed [key set-mode]
  (love.event.quit))

{ :draw draw 
  :update update
  :keypressed keypressed }

