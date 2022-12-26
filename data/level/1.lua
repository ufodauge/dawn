local hex2tbl = require('lib.lume').color
local util = require('lib.util')
local color_palette = util.parseJson('data/material_color.json')

return {
  systems = { 'debug_mode', 'rectangle', 'physics', 'blob', 'player', 'background' },
  entities = {
    {
      _name      = 'background',
      color      = { hex2tbl(color_palette.pink['50']) },
      rectangle  = { w = 1280, h = 720 },
      background = 'background'
    },
    {
      _name = 'block',
      transform = { x = 0, y = 0 },
      rectangle = { w = 40, h = 720 },
      color = { hex2tbl(color_palette.pink['300']) },
    },
    {
      _name = 'block',
      transform = { x = 40, y = 680 },
      rectangle = { w = 1200, h = 40 },
      color = { hex2tbl(color_palette.pink['300']) },
    },
    {
      _name = 'block',
      transform = { x = 1240, y = 0 },
      rectangle = { w = 40, h = 720 },
      color = { hex2tbl(color_palette.pink['300']) },
    },
    {
      _name = 'blob',
      transform = { x = 160, y = 450 },
      circle = { r = 26 },
      color = { hex2tbl(color_palette.pink['300']) },
      player = {},
      player_ui = {}
    },
  }
}
