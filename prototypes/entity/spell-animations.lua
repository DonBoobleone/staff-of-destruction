-- Define reusable animation functions
local spell_animations = {}

spell_animations.magic_swirl = function()
    return {
        filename = "__staff-of-destruction__/graphics/spell-animations/h3-magic-swirl.png",
        draw_as_glow = true,
        priority = "extra-high",
        width = 90,
        height = 94,
        frame_count = 19,
        animation_speed = 0.2,
        shift = { 0, 0 }
    }
end

data:extend({
    {
        type = "explosion",
        name = "magic-swirl",
        flags = {"not-on-map"},
        animations = {
            spell_animations.magic_swirl()
        },
        light = {intensity = 0.5, size = 4},
        smoke = "smoke",
        correct_camera = true
    }
})
