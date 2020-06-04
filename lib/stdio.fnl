(require "love.event")
(local view (require :lib.fennelview))

;; This module exists in order to expose stdio over a channel so that it
;; can be used in a non-blocking way from another thread.

(local (event channel) ...)

(when channel
  (let [prompt (fn [] (io.write "> ") (io.flush) (io.read "*l"))]
    ((fn looper [input]
       (when input
         ;; This is consumed by love.handlers[event]
         (love.event.push event input)
         (let [output (: channel :demand)]
           ;; There is probably a more efficient way of determining an error
           (if (and (. output 2) (= "Error:" (. output 2)))
               (print (view output))
               (each [_ ret (ipairs output)]
                 (print ret))))
         (io.flush)
         (looper (prompt)))) (prompt))))

{:start (fn start-repl []

          (let [code (love.filesystem.read "stdio.fnl")
                luac (if code
                         (love.filesystem.newFileData
                          (fennel.compileString code) "io")
                         (love.filesystem.read "lib/stdio.lua"))
                thread (love.thread.newThread luac)
                io-channel (love.thread.newChannel)
                coro (coroutine.create fennel.repl)
                out (fn [val]
                      (: io-channel :push  val))
                options {:readChunk coroutine.yield
                         :onValues out
                         :onError (fn [kind ...] (out [kind "Error:" ...]))
                         :pp view
                         :moduleName "lib.fennel"}]
            ;; this thread will send "eval" events for us to consume:
            (coroutine.resume coro options)
            (: thread :start "eval" io-channel)
            (set love.handlers.eval
                 (fn [input]
                   (coroutine.resume coro  (.. input "\n"))))))}
