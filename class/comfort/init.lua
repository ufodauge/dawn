local lf = love.filesystem

-- local dir = select(1, ...)
-- local JSON = require(dir .. ".json")
local JSON = require('lib.json_reader')

local result = {}

local defaultFilename = 'config.json'
local defaultConfig = [[{}]]

local comfort = {}

function comfort.init(filename, content)
    filename = filename or defaultFilename
    content  = content or defaultConfig

    local file = nil

    -- create configure flies
    file = lf.newFile(filename)

    file:open('w')
    file:write(content)
    file:close()
end


function comfort.load(filename)
    local bool, result = xpcall(function()
        local content = lf.read('string', filename)
        assert(content ~= nil, "there's no file: " .. filename)

        result = JSON.decode(content)

        return result
    end, function(message)
        print(message)

        return nil
    end)

    return result
end


function comfort.forceSave(filename, content)
    local bool, result = xpcall(function()
        local file = lf.newFile(filename)

        local result = JSON.encode(content)

        file:open('w')
        file:write(result)
        file:close()

        return result
    end, function(message)
        print(message)

        return nil
    end)

    return result
end


function comfort.forceSaveAsLua(filename, content)
    local bool, result = xpcall(function()
        local file = lf.newFile(filename)

        file:open('w')
        file:write(content)
        file:close()

        return result
    end, function(message)
        print(message)

        return nil
    end)

    return result
end


function comfort.getLatestResult()
    return result
end


return comfort
