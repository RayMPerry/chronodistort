(local canvas
  (let [(w h) (love.window.getMode)]
    (love.graphics.newCanvas w h)))

(var scale 1)
(var mode (require "src.modes.mode-game"))

(fn set-mode [mode-name ...]
  (set mode (require mode-name))
  (when mode.activate
    (mode.activate ...)))

(fn reload-mode [mode-name ...]
  (tset package.loaded mode-name nil)
  (set-mode mode-name ...))

(fn love.load []
  (love.graphics.setDefaultFilter :nearest :nearest)
  (canvas:setFilter :nearest :nearest))

(fn love.draw []
  (love.graphics.setCanvas canvas)
  (love.graphics.clear)
  (love.graphics.setColor 1 1 1)
  (mode.draw)
  (love.graphics.setCanvas)
  (love.graphics.setColor 1 1 1)
  (love.graphics.draw canvas 0 0 0 scale scale))

(fn love.update [dt]
  (mode.update dt set-mode))

(fn love.keypressed [key]
  (match key
    "f5" (reload-mode "src.modes.mode-game")
    "f6" (love.event.quit "restart")
    "f7" (love.event.quit))
  
  (if (and (love.keyboard.isDown "lctrl" "rctrl" "capslock") (= key "q"))
    (love.event.quit)
    ;; add what each keypress should do in each mode
    (when mode.keypressed
      (mode.keypressed key set-mode))))
