-- cargo v0.1.1
-- https://github.com/bjornbytes/cargo
-- MIT License

---@class Cargo
---@field loaders table
---@field processors table
local cargo = {}

---merge tables (shallow copy / target table's gonna be muted)
---@param target table [mutable] targeted table
---@param source table source table to be inserted
---@param ... table additional source tables
---@return table merged
local function merge(target, source, ...)
  if not target or not source then return target end
  for k, v in pairs(source) do target[k] = v end
  return merge(target, ...)
end

-- shorthands
local la, lf, lg = love.audio, love.filesystem, love.graphics

---retruns a function generating a new font object
---@param path string
---@return function fontGenerator
local function makeFont(path)

  ---generate a new font object
  ---@param size number
  ---@return love.Font
  return function(size)
    return lg.newFont(path, size)
  end
end

---lua file loader
---@param path string
---@return function chunk
local function loadFile(path)
  return lf.load(path)()
end

cargo.loaders = {
  lua = lf and loadFile,
  png = lg and lg.newImage,
  jpg = lg and lg.newImage,
  dds = lg and lg.newImage,
  ogv = lg and lg.newVideo,
  glsl = lg and lg.newShader,
  mp3 = la and la.newSource,
  ogg = la and la.newSource,
  wav = la and la.newSource,
  txt = lf and lf.read,
  ttf = lg and makeFont
}

cargo.processors = {}

---initializer with some props
---@param config string|table
---@return table
function cargo.init(config)
  if type(config) == 'string' then
    config = {dir = config}
  end

  local loaders = merge({}, cargo.loaders, config.loaders)
  local processors = merge({}, cargo.processors, config.processors)

  local init

  ---comment
  ---@param t table
  ---@param k any
  ---@return unknown
  local function halp(t, k)
    local path = (t._path .. '/' .. k):gsub('^/+', '')
    if lf.getInfo(path) then
      rawset(t, k, init(path))
      return t[k]
    else
      for extension, loader in pairs(loaders) do
        local file = path .. '.' .. extension
        if loader and lf.getInfo(file) then
          local asset = loader(file)
          rawset(t, k, asset)
          for pattern, processor in pairs(processors) do
            if file:match(pattern) then
              processor(asset, file, t)
            end
          end
          return asset
        end
      end
    end

    return rawget(t, k)
  end

  ---comment
  ---@param path any
  ---@return table
  init = function(path)
    return setmetatable({_path = path}, {__index = halp})
  end

  return init(config.dir)
end

return cargo
