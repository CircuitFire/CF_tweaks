data:extend({
    {
        type = "bool-setting",
        name = "re-balance-turrets",
        setting_type = "startup",
        default_value = true,
    },
    {
        type = "bool-setting",
        name = "fix-ammo-range",
        setting_type = "startup",
        default_value = true,
        hidden = true,
        forced_value = false
    },
    {
        type = "bool-setting",
        name = "thermal-laser-artillery",
        setting_type = "startup",
        default_value = true,
        hidden = true,
        forced_value = false
    },
    {
        type = "bool-setting",
        name = "add-liquid-tib-recipes",
        setting_type = "startup",
        default_value = true,
        hidden = true,
        forced_value = false
    },
    {
        type = "bool-setting",
        name = "add-tib-resistance",
        setting_type = "startup",
        default_value = true,
        hidden = true,
        forced_value = false
    },
    {
        type = "bool-setting",
        name = "add-tib-thrower",
        setting_type = "startup",
        default_value = true,
        hidden = true,
        forced_value = false
    },
    {
        type = "bool-setting",
        name = "re-balance-rampant-eggs",
        setting_type = "startup",
        default_value = true,
        hidden = true,
        forced_value = false
    },
    {
        type = "bool-setting",
        name = "re-balance-rampant-crystals",
        setting_type = "startup",
        default_value = true,
        hidden = true,
        forced_value = false
    },
    {
        type = "bool-setting",
        name = "fix-248k-mu-trains",
        setting_type = "startup",
        default_value = true,
        hidden = true,
        forced_value = false
    },
    {
        type = "bool-setting",
        name = "re-balance-248k-krastorio-bots",
        setting_type = "startup",
        default_value = true,
        hidden = true,
        forced_value = false
    },
    {
        type = "bool-setting",
        name = "ion-tib-det",
        setting_type = "startup",
        default_value = true,
        hidden = true,
        forced_value = false
    },
    {
        type = "bool-setting",
        name = "ion-tib-node-det",
        setting_type = "startup",
        default_value = true,
        hidden = true,
        forced_value = false
    },
})

local function enable(name)
    data.raw["bool-setting"][name].hidden = nil
end

if mods["Krastorio2"] then
    enable("thermal-laser-artillery")
    if mods["heroturrets"] then
        enable("fix-ammo-range")
    end
    if mods["248k"] then
        enable("re-balance-248k-krastorio-bots")
    end
end

if mods["248k"] then
    if mods["MultipleUnitTrainControl"] then
        enable("fix-248k-mu-trains")
    end
end

if mods["Factorio-Tiberium"] then
    enable("add-liquid-tib-recipes")
    enable("add-tib-resistance")
    enable("add-tib-thrower")
    if mods["Kux-OrbitalIonCannon"] then
        enable("ion-tib-det")
        enable("ion-tib-node-det")
    end
end

if mods["RampantFixed"] then
    enable("re-balance-rampant-crystals")
    if mods["Arachnids"] then
        enable("re-balance-rampant-eggs")
    end
end