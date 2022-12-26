return {
    controls = {
        left       = { 'axis:leftx-', 'key:a', 'button:dpleft' },
        right      = { 'axis:leftx+', 'key:d', 'button:dpright' },
        up         = { 'axis:lefty-', 'key:w', 'button:dpup' },
        down       = { 'axis:lefty+', 'key:s', 'button:dpdown' },
        tilt_left  = { 'key:q', 'button:leftshoulder' },
        tilt_right = { 'key:e', 'button:rightshoulder' },
        action     = { 'key:j', 'button:a' },
        cancel     = { 'key:k', 'button:b' }
    },
    pairs = {
        move = { 'left', 'right', 'up', 'down' }
    },
    joystick = love.joystick.getJoysticks()[1],
    deadzone = .33,
}
