screenWidth= 1080
screenHeight=540 
timeScale=1
colorfulMode = true

local flags = {
    fullscreen = false,
    fullscreentype = "desktop",
    vsync = false,
    msaa = 0 ,
    stencil = true,
    depth = 1,
    resizable = false,
    borderless = true,
    centered = true,
    display = 1,
    minWidth = 1,
    minHeight = 1
}
    
function love.conf(t)
    print("love.conf(t) is enabled")
    t.window.highdpi = true

    t.window.title = "Pong Game"         -- The window title (string)
    t.window.icon = nil                 -- Filepath to an image to use as the window's icon (string)
    t.window.width = screenWidth                -- The window width (number)
    t.window.height = screenHeight               -- The window height (number)
    t.window.borderless = false         -- Remove all border visuals from the window (boolean)
    t.window.resizable = true          -- Let the window be user-resizable (boolean)
    t.window.minwidth = 340               -- Minimum window width if the window is resizable (number)
    t.window.minheight = 200              -- Minimum window height if the window is resizable (number)
    t.window.fullscreen = false         -- Enable fullscreen (boolean)
    t.window.fullscreentype = "desktop" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
    t.window.vsync = 1                  -- Vertical sync mode (number)
    t.window.msaa = 0                   -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.depth = nil                -- The number of bits per sample in the depth buffer
    t.window.stencil = nil              -- The number of bits per sample in the stencil buffer
    t.window.display = 1                -- Index of the monitor to show the window in (number)
    t.window.highdpi = false            -- Enable high-dpi mode for the window on a Retina display (boolean)
    t.window.usedpiscale = true         -- Enable automatic DPI scaling when highdpi is set to true as well (boolean)
    t.window.x = nil                    -- The x-coordinate of the window's position in the specified display (number)
    t.window.y = nil                    -- The y-coordinate of the window's position in the specified display (number)

end

function getWidth()
    return screenWidth
end

function getHeight()
    return screenHeight
end

