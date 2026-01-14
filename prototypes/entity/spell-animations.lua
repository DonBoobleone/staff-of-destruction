-- prototypes/entity/spell-animations.lua
local spell_animations = {}

-- Scaling table for pentagram animations
-- Scale 1.0 = 12 tiles (approximate reference)
local PENTAGRAM_SCALES = {0.25, 0.66, 0.85, 1.5, 2.4}  -- Tiers 1–5

spell_animations.magic_swirl = function()
    return {
        filename = "__staff-of-destruction__/graphics/spell-animations/h3-magic-swirl.png",
        draw_as_glow = true,
        priority = "extra-high",
        width = 90,
        height = 94,
        frame_count = 19,
        animation_speed = 0.2,
        shift = {0, 0}
    }
end

-- Animated pentagram using the new 6×6 sprite sheet (36 frames total)
spell_animations.pentagram_with_scale = function(scale_index)
    local scale = PENTAGRAM_SCALES[scale_index] or 0.5
    return {
        filename = "__staff-of-destruction__/graphics/spell-animations/pentagram.png",
        draw_as_glow = true,
        priority = "high",
        width = 560,
        height = 560,
        frame_count = 36,
        line_length = 6,
        animation_speed = 0.33,
        shift = {0, 0},
        scale = scale
    }
end

-- Retained for possible use elsewhere in the mod
spell_animations.pentagram_for_tier = function(tier)
    local scale_index = math.max(1, math.min(tier, #PENTAGRAM_SCALES))
    return spell_animations.pentagram_with_scale(scale_index)
end

-- Tier configuration (scale index + light parameters)
local pentagram_tier_configs = {
    {scale_index = 1, intensity = 0.7, size = 8},
    {scale_index = 2, intensity = 0.7, size = 8},
    {scale_index = 3, intensity = 0.7, size = 8},
    {scale_index = 4, intensity = 0.8, size = 12},
    {scale_index = 5, intensity = 0.9, size = 18},
}

data:extend({
    {
        type = "explosion",
        name = "magic-swirl",
        flags = {"not-on-map"},
        animations = {spell_animations.magic_swirl()},
        light = {intensity = 0.5, size = 4},
        smoke = "smoke",
        correct_camera = true
    }
})

-- Generate pentagram explosions for each tier (DRY)
for tier, config in ipairs(pentagram_tier_configs) do
    data:extend({
        {
            type = "explosion",
            name = "pentagram-tier-" .. tier,
            flags = {"not-on-map"},
            animations = {spell_animations.pentagram_with_scale(config.scale_index)},
            light = {intensity = config.intensity, size = config.size},
            smoke = nil,
            correct_camera = true
        }
    })
end