local new_category = "explosion-magic"

for _, tech in pairs(data.raw.technology) do
    if tech.name:match("^stronger%-explosives%-%d+$") then
        local level = tonumber(tech.name:match("%d+"))
        local modifier = 0
        if level == 1 or level == 2 then
            modifier = 0
        elseif level == 3 then
            modifier = 0.3
        elseif level == 4 then
            modifier = 0.4
        elseif level == 5 then
            modifier = 0.5
        elseif level == 6 then
            modifier = 0.6
        elseif level >= 7 then
            modifier = 0.5
        end
        if modifier > 0 then
            tech.effects = tech.effects or {}
            table.insert(tech.effects, {
                type = "ammo-damage",
                ammo_category = new_category,
                modifier = modifier
            })
        end
    end
end
