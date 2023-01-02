local Loader = {}

function Loader:systems(data)
    local systems = {}

    for i = 1, #data do
        systems[i] = require('nocs.systems.' .. data[i])
    end

    return systems
end


function Loader:entities(data)
    local entities = {}

    for i = 1, #data do
        local comp_data = love.lume.deepclone(data[i])
        local entity_name = comp_data._name
        entities[i] = require('nocs.entities.' .. entity_name)(comp_data)
        entities[i]._name = entity_name
    end

    return entities
end


return Loader
