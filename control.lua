local SpellCore = require("lib.spell-core")

-- Constants for Explosion Magic configuration
local EXPLOSION_MAGIC = {
    MIN_MANA_COST = 1000000,  -- 1 MJ
    TIER_EXPONENT = 10,
    PROJECTILES = {
        "explosive-rocket",         -- Tier 1: 1 MJ
        "artillery-projectile",     -- Tier 2: 10 MJ
        "atomic-rocket",            -- Tier 3: 100 MJ
        "big-nuclear-explosion"     -- Tier 4: 1000 MJ
    },
    MAX_TIER = 4,  -- Derived from projectiles table
    CASTING_ANIMATION = "magic-swirl",
    EVENT_NAME = "magic-explosion-core-event"
}

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
    
    -- Play casting animation
    local surface = player.surface
    if surface and surface.valid then
        SpellCore.casting_animation(surface, event.source_position, EXPLOSION_MAGIC.CASTING_ANIMATION)
    else
        log("Invalid surface for casting animation.")
        return
    end
    
    -- Schedule projectile after cooldown
    local casting_time = get_cooldown_of_active_gun(player)
    local delay_ticks = game.tick + casting_time
    local target_position = event.target_position
    local projectile_name = EXPLOSION_MAGIC.PROJECTILES[spell_tier]
    
    -- One-time tick handler (avoids persistent registration)
    local function delayed_projectile_creation(tick_event)
        if tick_event.tick ~= delay_ticks then return end
        SpellCore.create_projectile_on_target(surface, target_position, projectile_name)
        script.on_event(defines.events.on_tick, nil)  -- Unregister immediately
    end
    
    script.on_event(defines.events.on_tick, delayed_projectile_creation)
end)