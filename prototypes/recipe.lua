data:extend({
    {
        type = "recipe",
        name = "staff-of-destruction",
        enabled = false,
        energy_required = 30,
        ingredients = {
            { type = "item", name = "low-density-structure", amount = 20 },
            { type = "item", name = "processing-unit", amount = 100 },
            { type = "item", name = "battery",         amount = 200 }
        },
        results = {
            {type = "item", name = "staff-of-destruction", amount = 1}
        }
    },
    {
        type = "recipe",
        name = "explosion-core",
        enabled = false,
        energy_required = 10,
        ingredients = {
            { type = "item", name = "explosives",     amount = 500 },
            { type = "item", name = "uranium-235",    amount = 100 },
            { type = "item", name = "energy-shield-equipment",    amount = 1 }
        },
        results = {
            {type = "item", name = "explosion-core", amount = 1}
        }
    }
})
