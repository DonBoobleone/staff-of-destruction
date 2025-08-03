local sounds = require("__base__/prototypes/entity/sounds")

-- Shared constants
local SHARED_ROCKET_ANIMATION = {
    filename = "__base__/graphics/entity/rocket/rocket.png",
    draw_as_glow = true,
    frame_count = 1,
    line_length = 1,
    width = 20,
    height = 60,
    shift = { 0, 8 },
    priority = "high"
}
local SHARED_ROCKET_SMOKE = {
    {
        name = "smoke-fast",
        deviation = { 0.15, 0.15 },
        frequency = 1,
        position = { 0, 1 },
        slow_down_factor = 1,
        starting_frame = 3,
        starting_frame_deviation = 5,
        starting_frame_speed = 0,
        starting_frame_speed_deviation = 5
    }
}
local SHARED_SHELL_ANIMATION = {
    filename = "__base__/graphics/entity/artillery-projectile/shell.png",
    draw_as_glow = true,
    frame_count = 1,
    line_length = 1,
    width = 64,
    height = 64,
    shift = { 0, 0 },
    priority = "high",
    scale = 0.5
}
local SHARED_SHELL_SMOKE = {
    {
        name = "smoke-fast",
        deviation = { 0.15, 0.15 },
        frequency = 1,
        position = { 0, 0 },
        slow_down_factor = 1,
        starting_frame = 3,
        starting_frame_deviation = 5,
        starting_frame_speed = 0,
        starting_frame_speed_deviation = 5
    }
}
local SHARED_NUKE_VARS = {
    max_shockwave_movement_distance_deviation = 2,
    max_shockwave_movement_distance = 19,
    shockwave_starting_speed_deviation = 0.075
}
-- Constants for cluster explosive rocket
local CLUSTER_EXPLOSIVE_ROCKET = {
    NAME = "cluster-explosive-rocket",
    CLUSTER_COUNT = 10,
    DISTANCE = 4,
    DISTANCE_DEVIATION = 2.5,
    DIRECTION_DEVIATION = 0.6,
    STARTING_SPEED = 0.3,
    STARTING_SPEED_DEVIATION = 0.3,
    ACCELERATION = 0.01
}
-- Constants for cluster artillery
local CLUSTER_ARTILLERY = {
    NAME = "cluster-artillery",
    CLUSTER_COUNT = 8,
    DISTANCE = 6.5,
    DISTANCE_DEVIATION = 3,
    DIRECTION_DEVIATION = 0.5,
    STARTING_SPEED = 0.5,
    STARTING_SPEED_DEVIATION = 0.4,
    ACCELERATION = 0.01
}
-- Constants for cluster nuke
local CLUSTER_NUKE = {
    NAME = "cluster-nuke",
    CLUSTER_COUNT = 5,
    DISTANCE = 14,
    DISTANCE_DEVIATION = 2,
    DIRECTION_DEVIATION = 0.5,
    STARTING_SPEED = 0.5,
    STARTING_SPEED_DEVIATION = 0.4,
    ACCELERATION = 0.02
}

-- Base rocket projectile creator
local function create_rocket_projectile(name, acceleration, action)
    return {
        type = "projectile",
        name = name,
        flags = { "not-on-map" },
        hidden = true,
        acceleration = acceleration,
        action = action,
        animation = SHARED_ROCKET_ANIMATION,
        smoke = SHARED_ROCKET_SMOKE
    }
end
-- Cluster explosive rocket
local cluster_explosive_rocket = create_rocket_projectile(
    CLUSTER_EXPLOSIVE_ROCKET.NAME,
    CLUSTER_EXPLOSIVE_ROCKET.ACCELERATION,
    {
        {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    {
                        type = "create-entity",
                        entity_name = "big-explosion"
                    },
                    {
                        type = "create-entity",
                        entity_name = "medium-scorchmark-tintable",
                        check_buildability = true
                    }
                }
            }
        },
        {
            type = "cluster",
            cluster_count = CLUSTER_EXPLOSIVE_ROCKET.CLUSTER_COUNT,
            distance = CLUSTER_EXPLOSIVE_ROCKET.DISTANCE,
            distance_deviation = CLUSTER_EXPLOSIVE_ROCKET.DISTANCE_DEVIATION,
            action_delivery = {
                type = "projectile",
                projectile = "explosive-rocket",
                direction_deviation = CLUSTER_EXPLOSIVE_ROCKET.DIRECTION_DEVIATION,
                starting_speed = CLUSTER_EXPLOSIVE_ROCKET.STARTING_SPEED,
                starting_speed_deviation = CLUSTER_EXPLOSIVE_ROCKET.STARTING_SPEED_DEVIATION
            }
        }
    }
)
-- Artillery shell
local artillery_shell = {
    type = "projectile",
    name = "artillery-shell",
    flags = { "not-on-map" },
    acceleration = 0.005,
    turn_speed = 0.01,
    animation = SHARED_SHELL_ANIMATION,
    action = {
        type = "direct",
        action_delivery = {
            type = "instant",
            target_effects = {
                {
                    type = "nested-result",
                    action = {
                        type = "area",
                        radius = 4.0,
                        action_delivery = {
                            type = "instant",
                            target_effects = {
                                {
                                    type = "damage",
                                    damage = { amount = 1000, type = "physical" }
                                },
                                {
                                    type = "damage",
                                    damage = { amount = 1000, type = "explosion" }
                                }
                            }
                        }
                    }
                },
                {
                    type = "create-trivial-smoke",
                    smoke_name = "artillery-smoke",
                    initial_height = 0,
                    speed_from_center = 0.05,
                    speed_from_center_deviation = 0.005,
                    offset_deviation = { { -4, -4 }, { 4, 4 } },
                    max_radius = 3.5,
                    repeat_count = 4 * 4 * 15
                },
                {
                    type = "create-entity",
                    entity_name = "big-artillery-explosion"
                },
                {
                    type = "show-explosion-on-chart",
                    scale = 8 / 32
                }
            }
        }
    },
    smoke = SHARED_SHELL_SMOKE
}
-- Cluster artillery
local cluster_artillery = create_rocket_projectile(
    CLUSTER_ARTILLERY.NAME,
    CLUSTER_ARTILLERY.ACCELERATION,
    {
        {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    {
                        type = "create-entity",
                        entity_name = "big-explosion"
                    },
                    {
                        type = "create-entity",
                        entity_name = "medium-scorchmark-tintable",
                        check_buildability = true
                    }
                }
            }
        },
        {
            type = "cluster",
            cluster_count = CLUSTER_ARTILLERY.CLUSTER_COUNT,
            distance = CLUSTER_ARTILLERY.DISTANCE,
            distance_deviation = CLUSTER_ARTILLERY.DISTANCE_DEVIATION,
            action_delivery = {
                type = "projectile",
                projectile = "artillery-shell",
                direction_deviation = CLUSTER_ARTILLERY.DIRECTION_DEVIATION,
                starting_speed = CLUSTER_ARTILLERY.STARTING_SPEED,
                starting_speed_deviation = CLUSTER_ARTILLERY.STARTING_SPEED_DEVIATION
            }
        }
    }
)
-- Adjust nuke max distance calculation
SHARED_NUKE_VARS.max_shockwave_movement_distance = SHARED_NUKE_VARS.max_shockwave_movement_distance +
SHARED_NUKE_VARS.max_shockwave_movement_distance_deviation / 6

-- big nuclear explosion
local big_nuclear_explosion = {
    type = "projectile",
    name = "big-nuclear-explosion",
    flags = { "not-on-map" },
    acceleration = 0.005,
    turn_speed = 0.003,
    turning_speed_increases_exponentially_with_projectile_speed = true,
    action = {
        {
            type = "direct",
            action_delivery = {
                type = "instant",
                target_effects = {
                    {
                        type = "set-tile",
                        tile_name = "nuclear-ground",
                        radius = 18,
                        apply_projection = true,
                        tile_collision_mask = { layers = { ["water_tile"] = true } }
                    },
                    {
                        type = "destroy-cliffs",
                        radius = 12,
                        explosion = "explosion"
                    },
                    {
                        type = "create-entity",
                        entity_name = "nuke-explosion"
                    },
                    {
                        type = "camera-effect",
                        effect = "screen-burn",
                        duration = 90,
                        ease_in_duration = 6,
                        ease_out_duration = 90,
                        delay = 0,
                        strength = 9,
                        full_strength_max_distance = 400,
                        max_distance = 1600
                    },
                    {
                        type = "play-sound",
                        sound = sounds.nuclear_explosion(0.95),
                        play_on_target_position = false,
                        max_distance = 1600,
                        audible_distance_modifier = 5
                    },
                    {
                        type = "play-sound",
                        sound = sounds.nuclear_explosion_aftershock(0.6),
                        play_on_target_position = false,
                        max_distance = 1200,
                        audible_distance_modifier = 4
                    },
                    {
                        type = "damage",
                        damage = { amount = 400, type = "explosion" }
                    },
                    {
                        type = "create-entity",
                        entity_name = "huge-scorchmark",
                        offsets = { { 0, -0.5 } },
                        check_buildability = true
                    },
                    {
                        type = "invoke-tile-trigger",
                        repeat_count = 1
                    },
                    {
                        type = "destroy-decoratives",
                        include_soft_decoratives = true,
                        include_decals = true,
                        invoke_decorative_trigger = true,
                        decoratives_with_trigger_only = false,
                        radius = 32
                    },
                    {
                        type = "create-decorative",
                        decorative = "nuclear-ground-patch",
                        spawn_min_radius = 15.5,
                        spawn_max_radius = 16.5,
                        spawn_min = 30,
                        spawn_max = 40,
                        apply_projection = true,
                        spread_evenly = true
                    },
                    {
                        type = "nested-result",
                        action = {
                            type = "area",
                            target_entities = false,
                            trigger_from_target = true,
                            repeat_count = 1000,
                            radius = 11,
                            action_delivery = {
                                type = "projectile",
                                projectile = "atomic-bomb-ground-zero-projectile",
                                starting_speed = 0.6 * 0.8,
                                starting_speed_deviation = SHARED_NUKE_VARS.shockwave_starting_speed_deviation
                            }
                        }
                    },
                    {
                        type = "nested-result",
                        action = {
                            type = "area",
                            target_entities = false,
                            trigger_from_target = true,
                            repeat_count = 1000,
                            radius = 50,
                            action_delivery = {
                                type = "projectile",
                                projectile = "atomic-bomb-wave",
                                starting_speed = 0.5 * 0.7,
                                starting_speed_deviation = SHARED_NUKE_VARS.shockwave_starting_speed_deviation
                            }
                        }
                    },
                    {
                        type = "nested-result",
                        action = {
                            type = "area",
                            show_in_tooltip = false,
                            target_entities = false,
                            trigger_from_target = true,
                            repeat_count = 1000,
                            radius = 36,
                            action_delivery = {
                                type = "projectile",
                                projectile = "atomic-bomb-wave-spawns-cluster-nuke-explosion",
                                starting_speed = 0.5 * 0.7,
                                starting_speed_deviation = SHARED_NUKE_VARS.shockwave_starting_speed_deviation
                            }
                        }
                    },
                    {
                        type = "nested-result",
                        action = {
                            type = "area",
                            show_in_tooltip = false,
                            target_entities = false,
                            trigger_from_target = true,
                            repeat_count = 700,
                            radius = 6,
                            action_delivery = {
                                type = "projectile",
                                projectile = "atomic-bomb-wave-spawns-fire-smoke-explosion",
                                starting_speed = 0.5 * 0.65,
                                starting_speed_deviation = SHARED_NUKE_VARS.shockwave_starting_speed_deviation
                            }
                        }
                    },
                    {
                        type = "nested-result",
                        action = {
                            type = "area",
                            show_in_tooltip = false,
                            target_entities = false,
                            trigger_from_target = true,
                            repeat_count = 1000,
                            radius = 11,
                            action_delivery = {
                                type = "projectile",
                                projectile = "atomic-bomb-wave-spawns-nuke-shockwave-explosion",
                                starting_speed = 0.5 * 0.65,
                                starting_speed_deviation = SHARED_NUKE_VARS.shockwave_starting_speed_deviation
                            }
                        }
                    },
                    {
                        type = "nested-result",
                        action = {
                            type = "area",
                            show_in_tooltip = false,
                            target_entities = false,
                            trigger_from_target = true,
                            repeat_count = 300,
                            radius = 36,
                            action_delivery = {
                                type = "projectile",
                                projectile = "atomic-bomb-wave-spawns-nuclear-smoke",
                                starting_speed = 0.5 * 0.65,
                                starting_speed_deviation = SHARED_NUKE_VARS.shockwave_starting_speed_deviation
                            }
                        }
                    },
                    {
                        type = "nested-result",
                        action = {
                            type = "area",
                            show_in_tooltip = false,
                            target_entities = false,
                            trigger_from_target = true,
                            repeat_count = 10,
                            radius = 11,
                            action_delivery = {
                                type = "instant",
                                target_effects = {
                                    {
                                        type = "create-entity",
                                        entity_name = "nuclear-smouldering-smoke-source",
                                        tile_collision_mask = { layers = { ["water_tile"] = true } }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        },
        {
            type = "cluster",
            cluster_count = CLUSTER_NUKE.CLUSTER_COUNT,
            distance = CLUSTER_NUKE.DISTANCE,
            distance_deviation = CLUSTER_NUKE.DISTANCE_DEVIATION,
            action_delivery = {
                type = "projectile",
                projectile = "atomic-rocket",
                direction_deviation = CLUSTER_NUKE.DIRECTION_DEVIATION,
                starting_speed = CLUSTER_NUKE.STARTING_SPEED,
                starting_speed_deviation = CLUSTER_NUKE.STARTING_SPEED_DEVIATION
            }
        }
    },
    animation = SHARED_ROCKET_ANIMATION,
    smoke = SHARED_ROCKET_SMOKE
}

data:extend({
    cluster_explosive_rocket,
    artillery_shell,
    cluster_artillery,
    big_nuclear_explosion
})
