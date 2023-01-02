local hex2tbl = require('lib.lume').color
local util = require('lib.util')
local color_palette = util.parseJson('data/material_color.json')

return {
  systems = {
    'debug_mode',
    'rectangle',
    'block',
    'ball',
    'circle',
    'blob',
    'player',
    'background',
    'goal',
    'light',
    'animation',
    'timer',
    'movable',
    'bubble'
  },
  entities = {
    {
      _name      = 'background',
      color      = { hex2tbl(color_palette.cyan['50']) },
      rectangle  = { w = 1280, h = 720 },
      background = 'background'
    },
    {
      _name = 'block',
      transform = { x = 0, y = 0 },
      rectangle = { w = 40, h = 720 },
      color = { hex2tbl(color_palette.cyan['300']) },
    },
    {
      _name = 'block',
      transform = { x = 1240, y = 0 },
      rectangle = { w = 40, h = 720 },
      color = { hex2tbl(color_palette.cyan['300']) },
    },
    --------------------------------------------------------------
    {
      _name = 'movable_block',
      transform = { x = 40, y = 320 },
      rectangle = { w = 400, h = 400 },
      movable = { to_y = 200, duration = 4 },
      color = { hex2tbl(color_palette.cyan['300']) },
    },
    {
      _name = 'movable_block',
      transform = { x = 840, y = 320 },
      rectangle = { w = 400, h = 400 },
      movable = { to_y = 200, duration = 4 },
      color = { hex2tbl(color_palette.cyan['300']) },
    },
    {
      _name = 'movable_block',
      transform = { x = 440, y = 520 },
      rectangle = { w = 400, h = 400 },
      movable = { to_y = -200, duration = 4 },
      color = { hex2tbl(color_palette.cyan['300']) },
    },

    --------------------------------------------------------------
    {
      _name = 'blob',
      transform = { x = 220, y = 240 },
      circle = { r = 26 },
      color = { hex2tbl(color_palette.cyan['400']) },
    },
    {
      _name = 'goal',
      transform = { x = 1060, y = 240 },
      circle = { r = 10 },
      light = { r = 50 },
      color = { hex2tbl(color_palette.amber['300']) },
    },
    {
      _name = 'light',
      transform = { x = -75, y = -100 },
      circle = { r = 1200 },
      color = { hex2tbl('#FFFFFF') },
    },
    {
      _name = 'timer',
      transform = { x = 1100, y = 30 },
      color = { hex2tbl('#121212') },
    },
  }
}
