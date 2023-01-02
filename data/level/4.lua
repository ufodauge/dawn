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
      color      = { hex2tbl(color_palette.indigo['50']) },
      rectangle  = { w = 1280, h = 720 },
      background = 'background'
    },
    {
      _name = 'block',
      transform = { x = 0, y = 0 },
      rectangle = { w = 40, h = 720 },
      color = { hex2tbl(color_palette.indigo['300']) },
    },
    {
      _name = 'block',
      transform = { x = 40, y = 680 },
      rectangle = { w = 1200, h = 40 },
      color = { hex2tbl(color_palette.indigo['300']) },
    },
    {
      _name = 'block',
      transform = { x = 1240, y = 0 },
      rectangle = { w = 40, h = 720 },
      color = { hex2tbl(color_palette.indigo['300']) },
    },
    --------------------------------------------------------------
    {
      _name = 'movable_block',
      transform = { x = 40, y = 320 },
      rectangle = { w = 200, h = 40 },
      movable = { to_x = 600, duration = 4 },
      color = { hex2tbl(color_palette.indigo['300']) },
    },
    {
      _name = 'block',
      transform = { x = 40, y = 360 },
      rectangle = { w = 200, h = 320 },
      color = { hex2tbl(color_palette.indigo['300']) },
    },
    {
      _name = 'block',
      transform = { x = 240, y = 400 },
      rectangle = { w = 200, h = 280 },
      color = { hex2tbl(color_palette.indigo['300']) },
    },
    {
      _name = 'block',
      transform = { x = 440, y = 480 },
      rectangle = { w = 200, h = 200 },
      color = { hex2tbl(color_palette.indigo['300']) },
    },
    {
      _name = 'block',
      transform = { x = 640, y = 560 },
      rectangle = { w = 200, h = 120 },
      color = { hex2tbl(color_palette.indigo['300']) },
    },
    {
      _name = 'block',
      transform = { x = 840, y = 640 },
      rectangle = { w = 400, h = 40 },
      color = { hex2tbl(color_palette.indigo['300']) },
    },
    {
      _name = 'block',
      transform = { x = 900, y = 240 },
      rectangle = { w = 340, h = 160 },
      color = { hex2tbl(color_palette.indigo['300']) },
    },
    --------------------------------------------------------------
    {
      _name = 'blob',
      transform = { x = 1140, y = 540 },
      circle = { r = 26 },
      color = { hex2tbl(color_palette.indigo['300']) },
    },
    {
      _name = 'goal',
      transform = { x = 1140, y = 140 },
      circle = { r = 10 },
      light = { r = 50 },
      color = { hex2tbl(color_palette.lime['400']) },
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
