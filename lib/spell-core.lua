local SpellCore = {}

-- Constants
local MANA_UNIT = 1  -- 1 Mana = 1 Joule

function SpellCore.get_available_mana(player)
    if not player or not player.valid then return 0 end
    local armor_inventory = player.get_inventory(defines.inventory.character_armor)
    if not armor_inventory or not armor_inventory[1].valid_for_read then return 0 end
    local armor = armor_inventory[1]
    if not armor.grid then return 0 end
    return armor.grid.available_in_batteries
end

function SpellCore.get_max_mana(player)
    if not player or not player.valid then return 0 end
    local armor_inventory = player.get_inventory(defines.inventory.character_armor)
    if not armor_inventory or not armor_inventory[1].valid_for_read then return 0 end
    local armor = armor_inventory[1]
    if not armor.grid then return 0 end
    return armor.grid.battery_capacity
end

function SpellCore.get_mana_regen(player)
    if not player or not player.valid then return 0 end
    local armor_inventory = player.get_inventory(defines.inventory.character_armor)
    if not armor_inventory or not armor_inventory[1].valid_for_read then return 0 end
    local armor = armor_inventory[1]
    if not armor.grid then return 0 end
    return armor.grid.generator_energy
end

function SpellCore.drain_energy(player, amount)
    if not player or not player.valid then return end
    local armor_inventory = player.get_inventory(defines.inventory.character_armor)
    if not armor_inventory or not armor_inventory[1].valid_for_read then return end
    local armor = armor_inventory[1]
    if not armor.grid then return end
    
    local total_energy = SpellCore.get_available_mana(player)
    if total_energy <= 0 or amount > total_energy then return end
    
    local remaining_percentage = (total_energy - amount) / total_energy
    for _, equipment in pairs(armor.grid.equipment) do
        if equipment.type == "battery-equipment" then
            equipment.energy = equipment.energy * remaining_percentage
        end
    end
end

function SpellCore.calculate_spell_tier(mana, min_mana_cost, max_tier, tier_exponent)
    if mana < min_mana_cost then return 0 end
    local tier = 1
    local current_cost = min_mana_cost
    while mana >= current_cost * tier_exponent and tier < max_tier do
        current_cost = current_cost * tier_exponent
        tier = tier + 1
    end
    return tier
end

function SpellCore.casting_animation(surface, position, animation_name)
    if not surface or not surface.valid then return false end
    surface.create_entity({
        name = animation_name or "explosion",  -- Fallback to base if missing
        position = position,
        force = "player"
    })
    return true
end

function SpellCore.create_projectile_on_target(surface, target_position, projectile_name)
    if not surface or not surface.valid then return false end
    surface.create_entity({
        name = projectile_name,
        position = target_position,
        target = target_position,
        speed = 1,
        force = "player"
    })
    return true
end

return SpellCore