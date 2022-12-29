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
    'light',
    'door',
    'animation'
  },
  entities = {
    {
      _name      = 'background',
      color      = { hex2tbl(color_palette.bluegrey['50']) },
      rectangle  = { w = 1920, h = 1080 },
      background = 'background'
    },
    {
      _name = 'block',
      transform = { x = 0, y = 0 },
      rectangle = { w = 40, h = 720 },
      color = { hex2tbl(color_palette.bluegrey['300']) },
    },
    {
      _name = 'block',
      transform = { x = 40, y = 680 },
      rectangle = { w = 1200, h = 40 },
      color = { hex2tbl(color_palette.bluegrey['300']) },
    },
    {
      _name = 'block',
      transform = { x = 1240, y = 0 },
      rectangle = { w = 40, h = 720 },
      color = { hex2tbl(color_palette.bluegrey['300']) },
    },
    {
      _name = 'block',
      transform = { x = 300, y = 520 },
      rectangle = { w = 680, h = 40 },
      color = { hex2tbl(color_palette.bluegrey['300']) },
    },
    {
      _name = 'door',
      transform = { x = 340, y = 630 },
      circle = { r = 10 },
      light = { r = 50 },
      color = { hex2tbl(color_palette.orange['300']) },
      door = { 1 },
    },
    {
      _name = 'blob',
      transform = { x = 160, y = 450 },
      circle = { r = 26 },
      color = { hex2tbl(color_palette.bluegrey['300']) },
    },
    {
      _name = 'light',
      transform = { x = -75, y = -100 },
      circle = { r = 1200 },
      color = { hex2tbl('#FFFFFF') },
    },
  }
}
