local SpellCore = require("script.spell-core")

-- Constants for Explosion Magic configuration
local EXPLOSION_MAGIC = {
    MIN_MANA_COST = 1000000, -- 1 MJ
    TIER_EXPONENT = 10,
    PROJECTILES = {
        "explosion-magic",          -- Tier 1: 1 MJ
        "cluster-explosion-magic",  -- Tier 2: 10 MJ
        "cluster-artillery",        -- Tier 3: 100 MJ
        "atomic-rocket",            -- Tier 4: 1 GJ
        "cluster-nuclear-explosion" -- Tier 5: 10 GJ

    },
    MAX_TIER = 5,                                -- Derived from projectiles table
    CASTING_ANIMATION = "magic-swirl",
    TARGET_ANIMATION_PREFIX = "pentagram-tier-", -- Prefix for tiered pentagram animations
    EVENT_NAME = "magic-explosion-core-event"
}

-- Create animation with validation
local function create_spell_animation(surface, position, animation_name, tier)
    local final_animation_name = animation_name
    if animation_name == EXPLOSION_MAGIC.TARGET_ANIMATION_PREFIX and tier then
        final_animation_name = animation_name .. tier -- Append tier number for pentagram
    end
    if not SpellCore.casting_animation(surface, position, final_animation_name) then
        log(string.format("Failed to create animation '%s' at position (%f, %f)",
            final_animation_name, position.x, position.y))
        return false
    end
    return true
end

-- Helper function to get active gun cooldown
local function get_cooldown_of_active_gun(player)
    if not player.character then return 0 end
    local gun_index = player.character.selected_gun_index
    if not gun_index then return 0 end
    local gun_inventory = player.get_inventory(defines.inventory.character_guns)
    local active_gun = gun_inventory[gun_index]
    if not active_gun or not active_gun.valid_for_read then return 0 end
    return active_gun.prototype.attack_parameters.cooldown or 0
end

-- Helper function to get active gun damage bonus
local function get_damage_bonus_of_active_gun(player)
    if not player.character then return 0 end
    local gun_index = player.character.selected_gun_index
    if not gun_index then return 0 end
    local gun_inventory = player.get_inventory(defines.inventory.character_guns)
    local active_gun = gun_inventory[gun_index]
    if not active_gun or not active_gun.valid_for_read then return 0 end
    return active_gun.prototype.attack_parameters.damage_modifier
end

-- Event handler for spell casting
script.on_event(defines.events.on_script_trigger_effect, function(event)
    if event.effect_id ~= EXPLOSION_MAGIC.EVENT_NAME then return end

    local player = event.source_entity and event.source_entity.player
    if not player or not player.valid then
        log("Invalid player for explosion magic event.")
        return
    end

    local available_mana = SpellCore.get_available_mana(player)
    local spell_tier = SpellCore.calculate_spell_tier(
        available_mana,
        EXPLOSION_MAGIC.MIN_MANA_COST,
        EXPLOSION_MAGIC.MAX_TIER,
        EXPLOSION_MAGIC.TIER_EXPONENT
    )

    if spell_tier == 0 then
        player.print("Not Enough Mana!")
        return
    end

    -- Calculate cost and drain mana
    local mana_cost = EXPLOSION_MAGIC.MIN_MANA_COST * (EXPLOSION_MAGIC.TIER_EXPONENT ^ (spell_tier - 1))
    SpellCore.drain_energy(player, mana_cost)

    -- Play casting animations
    local surface = player.surface
    if surface and surface.valid then
        create_spell_animation(surface, event.source_position, EXPLOSION_MAGIC.CASTING_ANIMATION)
        create_spell_animation(surface, event.target_position, EXPLOSION_MAGIC.TARGET_ANIMATION_PREFIX, spell_tier)
    else
        log("Invalid surface for casting animation.")
        return
    end

    -- Calculate damage modifiers
    local force = game.forces["player"]
    local weapon_damage_bonus = get_damage_bonus_of_active_gun(player)
    local research_damage_bonus = force.get_ammo_damage_modifier("explosion-magic")
    local damage_bonus = weapon_damage_bonus + research_damage_bonus -- Additive or multiply with weapons?

    --[[ --debug only
    if script.active_mods["debugadapter"] then
        player.print(string.format("damage bonus= %.2f", damage_bonus))
    end ]]

    -- Schedule projectile after cooldown
    local casting_time = get_cooldown_of_active_gun(player)
    local delay_ticks = game.tick + casting_time
    local target_position = event.target_position
    local projectile_name = EXPLOSION_MAGIC.PROJECTILES[spell_tier]

    -- One-time tick handler (avoids persistent registration)
    local function delayed_projectile_creation(tick_event)
        if tick_event.tick ~= delay_ticks then return end
        SpellCore.create_projectile_on_target(surface, target_position, projectile_name, damage_bonus, player)
        script.on_event(defines.events.on_tick, nil) -- Unregister immediately
    end

    script.on_event(defines.events.on_tick, delayed_projectile_creation)
end)

--[[ --event logger
script.on_event(defines.events.on_entity_damaged, function(event)
    if not event.entity or not event.entity.valid then return end
    local cause_name = event.cause and event.cause.valid and event.cause.name or "unknown"
    local damage_type = event.damage_type and event.damage_type.name or "unknown"
    game.print(string.format("Entity '%s' damaged: %.2f final amount (original %.2f) of type '%s' by '%s'", event.entity.name, event.final_damage_amount, event.original_damage_amount, damage_type, cause_name))
end) ]]
