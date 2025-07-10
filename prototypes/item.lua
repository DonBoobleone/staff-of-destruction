data:extend({
    {
        type = "gun",
        name = "staff-of-destruction",
        icon = "__staff-of-destruction__/graphics/icons/staff-of-destruction.png",
        icon_size = 64,
        subgroup = "gun",
        order = "z[staff-of-destruction]",
        attack_parameters = {
            type = "projectile",
            ammo_category = "explosion-magic",
            movement_slow_down_factor = 1,
            warmup = 0,
            cooldown = 150,
            range = 36,
            damage_modifier = 1,
            ammo_consumption_modifier = 1,
            projectile_creation_distance = 0,
            sound = {
                {
                    filename = "__base__/sound/fight/artillery-shoots-1.ogg",
                    volume = 0.8
                }
            }
        },
        stack_size = 1
    },
    {
        type = "ammo",
        name = "explosion-core",
        icon = "__staff-of-destruction__/graphics/icons/explosion-core.png",
        icon_size = 64,
        ammo_category = "explosion-magic",
        ammo_type = {
            target_type = "position",
            range_modifier = 1.5,
            action = {
                type = "direct",
                action_delivery = {
                    type = "instant",
                    target_effects = {
                        {
                            type = "script",
                            effect_id = "magic-explosion-core-event"
                        }
                    }
                }
            }
        },
        magazine_size = 1000,
        subgroup = "ammo",
        order = "z[explosion-core]",
        stack_size = 1
    }
})