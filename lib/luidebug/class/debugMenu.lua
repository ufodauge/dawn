--------------------------------------------------------------
-- Const
--------------------------------------------------------------
local DEBUG_MENU_DIR_NAME_TOGGLE    = 'toggle'
local DEBUG_MENU_DIR_NAME_CLEAR_LOG = 'clear log'
local DEBUG_MENU_DIR_NAME_SCENE     = 'scene'
local DEBUG_MENU_DIR_NAME_COMMANDS  = 'commands'


--------------------------------------------------------------
-- Import
--------------------------------------------------------------
local PATH         = (...):gsub('[^/.\\]+$', '')
local EntryManager = require(PATH .. 'entrymanager')
local Directory    = require(PATH .. 'entrymanager.directory')
local Executable   = require(PATH .. 'entrymanager.executable') --[[@as Executable]]
local KeyManager   = require(PATH .. 'keyManager')


--------------------------------------------------------------
-- Shorthands
--------------------------------------------------------------
local lg = love.graphics
local lf = love.filesystem


--------------------------------------------------------------
-- Utils
--------------------------------------------------------------

---@param subject any
---@param super any
local function isInstanceOf(subject, super)
    local ss = tostring(super)
    local mt = getmetatable(subject)

    while true do
        if mt == nil then
            return false
        end

        if tostring(mt.__index) == ss then
            return true
        end

        mt = getmetatable(mt.__index)
    end
end


--------------------------------------------------------------
-- Debug Menu
--------------------------------------------------------------

---@class DebugMenu
---@field display        boolean
---@field key_manager    KeyManager
---@field entry_manager  EntryManager
---@field roomy          Roomy
---@field current_dir    Directory
---@field luidebug       LLDebug
---@field cursor_index   integer
---@field x              integer
---@field y              integer
local DebugMenu = {}


function DebugMenu:update(dt)
    self.key_manager:update(dt, { 'hide' })

    -- you can't controll menu while not displaying
    if not self.display then
        return
    end

    self.key_manager:update(dt, { 'up', 'down', 'ok' })
end


function DebugMenu:draw()
    if not self.display then
        return
    end

    local line_height = lg.getFont():getHeight()
    local entries = self.current_dir:getEntries()
    for index, entry in ipairs(entries) do

        -- For each Entries
        --------------------------------------------------------------
        local name = entry:getName()
        lg.print(
            ' ' .. name, -- add space to display cursor
            self.x,
            self.y + line_height * (index - 1))
    end

    -- print "return"
    --------------------------------------------------------------
    lg.print(
        ' return',
        self.x,
        self.y + line_height * #entries)

    -- Selecting index
    --------------------------------------------------------------
    lg.print(
        '>',
        self.x,
        self.y + line_height * (self.cursor_index - 1))
end


---return true if toggler could be added
---@param name string display name
---@param func function toggle function
---@return boolean
function DebugMenu:addToggler(name, func)
    local toggleDir = self.entry_manager
        :getRootDir()
        :getEntry('toggle') --[[@as Directory]]

    -- Check directory existence
    --------------------------------------------------------------
    if toggleDir == nil or toggleDir:getEntry(name) then
        return false
    end
    toggleDir:add(Executable.new(name, func))

    return true
end


---return true if toggler could be removed
---@param name string
---@return boolean
function DebugMenu:removeToggler(name)
    local toggleDir = self.entry_manager
        :getRootDir()
        :getEntry(DEBUG_MENU_DIR_NAME_TOGGLE) --[[@as Directory]]

    if toggleDir == nil or not toggleDir:getEntry(name) then
        return false
    end
    toggleDir:removeEntry(name)

    return true
end


---@param name string
---@param func function
---@return boolean
function DebugMenu:addCommand(name, func)
    local commandDir = self.entry_manager
        :getRootDir()
        :getEntry(DEBUG_MENU_DIR_NAME_COMMANDS)

    if commandDir == nil or commandDir:getEntry(name) then
        return false
    end
    commandDir:add(Executable.new(name, func))

    return true
end


---@param name string
---@return boolean
function DebugMenu:removeCommand(name)
    local commandDir = self.entry_manager
        :getRootDir()
        :getEntry(DEBUG_MENU_DIR_NAME_COMMANDS)

    if commandDir == nil or not commandDir:getEntry(name) then
        return false
    end
    commandDir:removeEntry(name)

    return true
end


-- ---@param name string
-- ---@return boolean
-- function DebugMenu:hideCommand(name)
--     local commandDir = self.entry_manager
--         :getRootDir()
--         :getEntry(DEBUG_MENU_DIR_NAME_COMMANDS)

--     if commandDir == nil or not commandDir:getEntry(name) then
--         return false
--     end
--     commandDir:removeEntry(name)

--     return true
-- end


function DebugMenu:setRoomy(instance)
    self.roomy = instance
end


function DebugMenu:setMainInstance(luidebug)
    self.luidebug = luidebug
end


---comment
---@param debugmenu DebugMenu
---@param path      string
---@param dir       Directory
local function create_scene_executables(debugmenu, path, dir)
    local scenes = lf.getDirectoryItems(path)

    for _, filename in ipairs(scenes) do

        -- create filepath then get information
        local filepath = path .. '/' .. filename
        local info = lf.getInfo(filepath)

        if not info then

            -- pass

        elseif info.type == 'file' then

            -- load scene file
            --------------------------------------------------------------
            local chunk, errmsg = lf.load(filepath)

            if errmsg then
                -- scene file is somewhat broken
                debugmenu.luidebug:log(errmsg)

            else
                -- create executable to switch scene
                dir:add(Executable.new(
                    filename,
                    function()
                        debugmenu.roomy:enter(chunk())
                    end))

            end

        elseif info.type == 'directory' then

            -- create new directory then create scenes
            --------------------------------------------------------------
            local new_dir = Directory.new(filename)
            dir:add(new_dir)

            create_scene_executables(debugmenu, filepath, new_dir)

        end
    end
end


function DebugMenu:setScenePath(path)
    local sceneDir = self.entry_manager
        :getRootDir()
        :getEntry(DEBUG_MENU_DIR_NAME_SCENE) --[[@as Directory]]

    -- Clear scenes
    --------------------------------------------------------------
    sceneDir:clearContents()

    -- Iterate scene directory
    --------------------------------------------------------------
    create_scene_executables(self, path, sceneDir)
end


---comment
---@param x integer
---@param y integer
---@return DebugMenu
function DebugMenu.new(x, y)
    local obj = {} --[[@as DebugMenu]]

    -- Fields
    --------------------------------------------------------------
    obj.display = false -- display flag
    obj.x       = x or 0 -- coordinates
    obj.y       = y or 0


    -- Entry Manager
    --------------------------------------------------------------
    obj.entry_manager = EntryManager.new() -- contains root directory
    local rootDir = obj.entry_manager:getRootDir() --[[@as Directory]]

    -- Togglers
    rootDir:add(Directory.new(DEBUG_MENU_DIR_NAME_TOGGLE))

    -- States
    rootDir:add(Directory.new(DEBUG_MENU_DIR_NAME_SCENE))

    -- commands
    rootDir:add(Directory.new(DEBUG_MENU_DIR_NAME_COMMANDS))
    local commandDir = rootDir:getEntry(DEBUG_MENU_DIR_NAME_COMMANDS)

    -- clear log
    if commandDir then
        commandDir:add(Executable.new(DEBUG_MENU_DIR_NAME_CLEAR_LOG, function()
            obj.luidebug:clearLog()
        end))
    end

    -- Quit
    rootDir:add(Executable.new('quit', function()
        love.event.quit()
    end))


    -- controllers
    --------------------------------------------------------------
    obj.current_dir  = rootDir
    obj.cursor_index = 1


    -- Key Manager
    --------------------------------------------------------------
    obj.key_manager = KeyManager.new()
    obj.key_manager:setKeyConfig('up', 'pageup')
    obj.key_manager:setKeyConfig('down', 'pagedown')
    obj.key_manager:setKeyConfig('ok', 'end')
    obj.key_manager:setKeyConfig('hide', 'home')

    obj.key_manager:setControll(
        'up',
        function(frame)
            if frame == 1 then

                -- Move cursor up
                --------------------------------------------------------------
                obj.cursor_index = obj.cursor_index - 1 > 0
                    and obj.cursor_index - 1
                    or obj.current_dir:getItemCount() + 1

            end
        end)
    obj.key_manager:setControll(
        'down',
        function(frame)
            if frame == 1 then

                -- Move cursor down
                --------------------------------------------------------------
                obj.cursor_index = obj.cursor_index + 1 <= obj.current_dir:getItemCount() + 1
                    and obj.cursor_index + 1
                    or 1

            end
        end)
    obj.key_manager:setControll(
        'ok',
        function(frame)
            if frame == 1 then
                -- Execute or Move Dir
                --------------------------------------------------------------
                local ent = obj.current_dir:getEntryByIndex(obj.cursor_index)
                if not ent then

                    -- Assume selected "return"
                    --------------------------------------------------------------
                    local parent = obj.current_dir:getParent() --[[@as Directory]]
                    if parent == nil then
                        -- returns to root dir
                        obj.display = false
                    else
                        -- Set cursor an index of current directory
                        local current_name = obj.current_dir:getName()
                        obj.cursor_index = parent:getEntryIndex(current_name)

                        obj.current_dir = parent
                    end


                elseif isInstanceOf(ent, Directory) then

                    -- Move Directory
                    --------------------------------------------------------------
                    obj.current_dir = ent

                    -- Set cursor top
                    --------------------------------------------------------------
                    obj.cursor_index = 1

                elseif isInstanceOf(ent, Executable) then

                    --Execute function safely
                    --------------------------------------------------------------
                    local ok, result = xpcall(function()
                        ---@diagnostic disable-next-line: undefined-field
                        return ent:execute()
                    end, function(msg)
                        obj.luidebug:log(debug.traceback(msg))
                        print(debug.traceback(msg))
                        return nil
                    end)

                    obj.luidebug:log(('Exec: %s'):format(tostring(ok)))
                    obj.luidebug:log(result)

                else
                    error('unreachable!')
                end
            end
        end)
    obj.key_manager:setControll(
        'hide',
        function(frame)
            if frame == 1 then
                obj.display = not obj.display
            end
        end)


    return setmetatable(obj, { __index = DebugMenu })
end


--------------------------------------------------------------
-- Export
--------------------------------------------------------------
local Export = {}
local instance = nil

---get an instance
---@return DebugMenu
function Export.getInstance()
    if instance == nil then
        instance = DebugMenu.new(5, 5)
    end

    return instance
end


return Export
