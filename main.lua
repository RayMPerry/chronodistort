-- main.lua
local MODE = "debug"
fennel = require("lib.fennel")
table.insert(package.loaders or package.searchers, fennel.make_searcher({ correlate = true }))

pp = function(x) print(require("lib.fennelview")(x)) end
lume = require("lib.lume")
tick = require("lib.tick")
tween = require("lib.tween")

require("src.wrap")


