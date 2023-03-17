
-- cmd /c %command%

-- removes turret bonus damage from tech tree.
local function remove_turrets(tech, i, turrets)
    local effect = data.raw["technology"][tech].effects[i]

    for turret, k in pairs(turrets) do
        if effect.type == "turret-attack" and effect.turret_id == turret then
            --print("!!!CF debug: found ", turret)
            table.remove(data.raw["technology"][tech].effects, i)
            return true
        end
    end

    return false
end

-- removes turret bonus damage from tech tree.
local function remove_tech(techs, kind)
    for k, tech in ipairs(techs) do
        --print("!!!CF debug: removing ", tech)

        local i = 1
        --print("!!!CF debug: ", tech)
        --print("!!!CF debug: ", serpent.block(data.raw["technology"][tech].effects))
        
        local len = #data.raw["technology"][tech].effects
        while i <= len do
            if remove_turrets(tech, i, data.raw[kind]) then
                len = len - 1
            else
                i = i + 1
            end
        end
    end
end

-- gives 50% damage buff to gun turrets
local function boost_turret_damage(turrets)
    for i, turret in ipairs(turrets) do
        data.raw["ammo-turret"][turret]["attack_parameters"]["damage_modifier"] = 1.5
    end
end

-- gives 25% damage buff to gun turrets
local function boost_vehicle_damage(vehicles_guns)
    for i, gun in ipairs(vehicles_guns) do
        data.raw.gun[gun]["attack_parameters"]["damage_modifier"] = 1.25
    end
end

local function ends_with(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

---------------------------------------------------------------------------------------------------

-- adds base game techs that give gun turret damage to list.
local function base_ammo_techs(techs)
    for i = 1, 7 do
        table.insert(techs, "physical-projectile-damage-" .. i)
    end
end

local function base_fluid_techs(techs)
    for i = 1, 7 do
        table.insert(techs, "refined-flammables-" .. i)
    end
end

-- adds base game turrets to get bonus damage to list.
local function base_turrets(turrets)
    table.insert(turrets, "gun-turret")
end

-- adds base game vehicles to get bonus damage to list.
local function base_vehicle_guns(turrets)
    table.insert(turrets, "tank-machine-gun")
    table.insert(turrets, "vehicle-machine-gun")
end

-- adds krastorio techs that give gun turret damage to list.
local function krastorio_ammo_techs(techs)
    table.insert(techs, "physical-projectile-damage-11")
    table.insert(techs, "physical-projectile-damage-16")
end

local function krastorio_fluid_techs(techs)
    table.insert(techs, "refined-flammables-11")
    table.insert(techs, "refined-flammables-16")
end

-- adds modular turrets to get bonus damage to list.
local function modular_turrets(turrets)
    table.insert(turrets, "scattergun-turret")
end

-- adds hero_turrets to get bonus damage to list.
local function hero_turrets(turrets)
    local new_turrets = {}

    for new, i in pairs(data.raw["ammo-turret"]) do
        for i, base in ipairs(turrets) do
            if ends_with(new, base) then
                table.insert(new_turrets, new)
            end
        end
    end

    return new_turrets
end

---------------------------------------------------------------------------------------------------

if settings.startup["re-balance-turrets"].value then
    local ammo_techs = {}
    local fluid_techs = {}
    local turrets = {}
    local vehicle = {}

    base_ammo_techs(ammo_techs)
    base_fluid_techs(fluid_techs)
    base_turrets(turrets)
    base_vehicle_guns(vehicle)

    if mods["Krastorio2"] then
        --print("!!!CF debug: Krastorio2")
        krastorio_ammo_techs(ammo_techs)
        krastorio_fluid_techs(fluid_techs)
        
        
    end

    if mods["scattergun_turret"] then
        --print("!!!CF debug: scattergun_turret")
        modular_turrets(turrets)
    end

    if mods["heroturrets"] then
        --print("!!!CF debug: heroturrets")
        turrets = hero_turrets(turrets)
    end

    --for k,i in pairs(data.raw["ammo-turret"]) do print("!!!CF debug:", k) end

    -- make changes
    remove_tech(ammo_techs, "ammo-turret")
    remove_tech(fluid_techs, "fluid-turret")

    boost_turret_damage(turrets)
    boost_vehicle_damage(vehicle)
end


-- increases the range of rounds so hero turrets don't out range their own ammo.
if settings.startup["fix-ammo-range"].value then
     -- print("!!!CF debug: ", serpent.block(data.raw.ammo, {maxlevel = 4}))
    for key, ammo in pairs(data.raw.ammo) do
            
        if ammo.ammo_type.category == "bullet" and ammo.ammo_type.action.type ~= "direct" then
            ammo.ammo_type.action[1].action_delivery[1].max_range = 55
        elseif ammo.ammo_type.category == "shotgun-shell" then
            -- print("!!!CF debug: " .. key, serpent.block(ammo, {maxlevel = 6}))
            ammo.ammo_type.action[2].action_delivery.max_range = 24
        end
    end
end

-- add flames to krastorio laser artillery
if settings.startup["thermal-laser-artillery"].value then
    print("!!!CF debug: ", serpent.block(data.raw["projectile"]["laser-projectile"], {maxlevel = 7}))
    print("!!!CF debug: ", serpent.block(data.raw["ammo"]["atomic-bomb"], {maxlevel = 7}))
    table.insert(
        data.raw["projectile"]["laser-projectile"].action.action_delivery.target_effects,
        {
            type = "nested-result",
            action = {
                type = "area",
                radius = .5,
                action_delivery = {
                    type = "instant",
                    target_effects = {
                        type = "create-fire",
                        entity_name = "fire-flame",
            
                        show_in_tooltip = true,
                        initial_ground_flame_count = 10
                    }
                }
            }
        }
        
    )
    table.insert(
        data.raw["projectile"]["laser-projectile"].action.action_delivery.target_effects,
        {
            type = "create-fire",
            entity_name = "fire-flame",

            show_in_tooltip = true,
            initial_ground_flame_count = 200
        }
    )
    table.insert(
        data.raw["projectile"]["laser-projectile"].action.action_delivery.target_effects,
        {
            type = "create-sticker",
            sticker = "fire-sticker",
            show_in_tooltip = true
        }
    )
end

-----------------------------------------------------------------------------------------------------
-- add additional liquid tib recipes 
if settings.startup["add-liquid-tib-recipes"].value then
    local pure_reactant = table.deepcopy(data.raw["recipe"]["tiberium-primed-reactant-pure"])
    
    pure_reactant.name = "tiberium-primed-reactant-liquid"
    pure_reactant.ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 30},
    }
    data:extend{pure_reactant}
    table.insert(
        data.raw["technology"]["tiberium-transmutation-tech"].effects,
        {
            type = "unlock-recipe",
            recipe = pure_reactant.name
        }
    )

    local liquid_oil = table.deepcopy(data.raw["recipe"]["tiberium-tranmutation-to-crude-oil"])

    liquid_oil.name = "liquid-tiberium-tranmutation-to-crude-oil"
    liquid_oil.ingredients = {
        {type = "fluid", name = "liquid-tiberium", amount = 10},
    }

    data:extend{liquid_oil}
    table.insert(
        data.raw["technology"]["tiberium-liquid-centrifuging"].effects,
        {
            type = "unlock-recipe",
            recipe = liquid_oil.name
        }
    )

    if mods["Krastorio2"] then
        local liquid_mineral = table.deepcopy(data.raw["recipe"]["tiberium-tranmutation-to-mineral-water"])

        liquid_mineral.name = "liquid-tiberium-tranmutation-to-mineral-water"
        liquid_mineral.ingredients = {
            {type = "fluid", name = "liquid-tiberium", amount = 10},
        }

        data:extend{liquid_mineral}
        table.insert(
            data.raw["technology"]["tiberium-liquid-centrifuging"].effects,
            {
                type = "unlock-recipe",
                recipe = liquid_mineral.name
            }
        )
    end
end

-- add tib resistances to walls
if settings.startup["add-tib-resistance"].value then
    table.insert(
        data.raw["wall"]["stone-wall"].resistances,
        {
            type = "tiberium",
            decrease = 0,
            percent = 100
        }
    )

    if mods["scattergun_turret"] then
        table.insert(
            data.raw["ammo-turret"]["scattergun-turret"].resistances,
            {
                type = "tiberium",
                decrease = 0,
                percent = 100
            }
        )
    end
end

--------------------------------------------------------------------------------------------------------------

-- remove some of the resistances
if settings.startup["re-balance-rampant-crystals"].value then
    data.raw["radar"]["targetDummyFire-rampant"].resistances = nil
    data.raw["radar"]["targetDummyLaser-rampant"].resistances = nil
    data.raw["radar"]["targetDummyPhysical-rampant"].resistances = nil
    data.raw["radar"]["targetDummyPlasma-rampant"].resistances = nil
end

-- remove some of the resistances
if settings.startup["re-balance-rampant-eggs"].value then
    for i = 1, 10 do
        data.raw["combat-robot"]["arachnids-egg-v1-t" .. i .. "-drone-rampant"].resistances = {
            {
                type = "fire",
                decrease = 0,
                percent = -200
            }
        }
    end
end