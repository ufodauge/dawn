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
        'bubble',
    },
    entities = {
        {
            _name      = 'background',
            color      = { hex2tbl(color_palette.cyan['50']) },
            rectangle  = { w = 1280, h = 720 },
            background = 'background'
        },
        {
            _name     = 'block',
            transform = { x = 0, y = 0 },
            rectangle = { w = 40, h = 720 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 680 },
            rectangle = { w = 1200, h = 40 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 1240, y = 0 },
            rectangle = { w = 40, h = 720 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 660 },
            rectangle = { w = 460, h = 20 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 740, y = 660 },
            rectangle = { w = 500, h = 20 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 640 },
            rectangle = { w = 360, h = 20 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 620 },
            rectangle = { w = 280, h = 20 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 600 },
            rectangle = { w = 220, h = 20 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 580 },
            rectangle = { w = 180, h = 20 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 560 },
            rectangle = { w = 160, h = 20 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 520 },
            rectangle = { w = 140, h = 40 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 460 },
            rectangle = { w = 120, h = 60 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 380 },
            rectangle = { w = 100, h = 80 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 280 },
            rectangle = { w = 80, h = 100 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 160 },
            rectangle = { w = 60, h = 120 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 40, y = 0 },
            rectangle = { w = 40, h = 160 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 840, y = 640 },
            rectangle = { w = 400, h = 20 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 920, y = 620 },
            rectangle = { w = 320, h = 20 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 980, y = 600 },
            rectangle = { w = 260, h = 20 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 1020, y = 580 },
            rectangle = { w = 220, h = 20 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 1040, y = 560 },
            rectangle = { w = 200, h = 20 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 1060, y = 520 },
            rectangle = { w = 180, h = 40 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 1080, y = 460 },
            rectangle = { w = 160, h = 60 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 1100, y = 380 },
            rectangle = { w = 140, h = 80 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 1120, y = 280 },
            rectangle = { w = 120, h = 100 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 1140, y = 160 },
            rectangle = { w = 100, h = 120 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 1160, y = 0 },
            rectangle = { w = 80, h = 160 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'blob',
            transform = { x = 600, y = 600 },
            circle    = { r = 26 },
            color     = { hex2tbl(color_palette.cyan['400']) },
        }, {
            _name     = 'block',
            transform = { x = 320, y = 420 },
            rectangle = { w = 140, h = 40 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'goal',
            transform = { x = 620, y = 200 },
            circle    = { r = 10 },
            light     = { r = 50 },
            color     = { hex2tbl(color_palette.deeporange['300']) },
        }, {
            _name     = 'block',
            transform = { x = 540, y = 340 },
            rectangle = { w = 160, h = 40 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 420, y = 380 },
            rectangle = { w = 400, h = 40 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        }, {
            _name     = 'block',
            transform = { x = 780, y = 420 },
            rectangle = { w = 140, h = 40 },
            color     = { hex2tbl(color_palette.cyan['300']) },
        },
        {
            _name     = 'light',
            transform = { x = -75, y = -100 },
            circle    = { r = 1200 },
            color     = { hex2tbl('#FFFFFF') }
        },
        {
            _name     = 'timer',
            transform = { x = 1100, y = 30 },
            color     = { hex2tbl('#121212') }
        }
    }
}
