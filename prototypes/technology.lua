data:extend({
    {
        type = "technology",
        name = "staff-of-destruction",
        icon = "__staff-of-destruction__/graphics/icons/staff-of-destruction.png",
        icon_size = 64,
        effects = {
            {type = "unlock-recipe", recipe = "staff-of-destruction"},
            {type = "unlock-recipe", recipe = "explosion-core"}
        },
        prerequisites = {"military-3", "uranium-processing", "energy-shield-equipment"},
        unit = {
            count = 500,
            ingredients = {
                {"automation-science-pack", 1},
                {"logistic-science-pack", 1},
                {"military-science-pack", 1},
                {"chemical-science-pack", 1},
                {"utility-science-pack", 1}
            },
            time = 60
        },
        order = "e-m"
    }
})