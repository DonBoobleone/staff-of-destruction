-- Define reusable animation functions
local spell_animations = {}

-- Scaling table for pentagram animations
-- Scale 1.0 = 12 tiles
local PENTAGRAM_SCALES = {0.25, 0.69, 1.0, 1.5}  -- Scales for tiers 1 to 4

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

-- Function to create pentagram animation with specified scale
spell_animations.pentagram_with_scale = function(scale_index)
    local scale = PENTAGRAM_SCALES[scale_index] or 0.5  -- Default to 0.5 if index is invalid
    return {
        filename = "__staff-of-destruction__/graphics/spell-animations/pentagram.png",
        draw_as_glow = true,
        priority = "high",
        width = 768,
        height = 768,
        frame_count = 1,
        animation_speed = 1,
        repeat_count = 120,
        shift = { 0, 0 },
        scale = scale
    }
end

-- Function to get pentagram animation based on spell tier
spell_animations.pentagram_for_tier = function(tier)
    local scale_index = math.max(1, math.min(tier, #PENTAGRAM_SCALES))  -- Clamp tier to valid range
    return spell_animations.pentagram_with_scale(scale_index)
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
    },
    {
        type = "explosion",
        name = "pentagram-tier-1",
        flags = {"not-on-map"},
        animations = {
            spell_animations.pentagram_with_scale(1)
        },
        light = {intensity = 0.7, size = 8},
        smoke = nil,
        correct_camera = true,
        duration = 120
    },
    {
        type = "explosion",
        name = "pentagram-tier-2",
        flags = {"not-on-map"},
        animations = {
            spell_animations.pentagram_with_scale(2)
        },
        light = {intensity = 0.7, size = 8},
        smoke = nil,
        correct_camera = true,
        duration = 120
    },
    {
        type = "explosion",
        name = "pentagram-tier-3",
        flags = {"not-on-map"},
        animations = {
            spell_animations.pentagram_with_scale(3)
        },
        light = {intensity = 0.7, size = 8},
        smoke = nil,
        correct_camera = true,
        duration = 120
    },
    {
        type = "explosion",
        name = "pentagram-tier-4",
        flags = {"not-on-map"},
        animations = {
            spell_animations.pentagram_with_scale(4)
        },
        light = {intensity = 0.7, size = 8},
        smoke = nil,
        correct_camera = true,
        duration = 120
    }
})