if settings.startup["fix-248k-mu-trains"].value then
    local function fix_name(train_name, item_name)
        local train = table.deepcopy(data.raw["locomotive"][train_name])

        train.name = item_name
        train.localised_name = {"", {"entity-name." .. train_name}}
        -- train.localised_description = {"", {"entity-description." .. train_name}}
        data:extend({train})

        data.raw["item-with-entity-data"][item_name].place_result = item_name
    end

    fix_name("el_diesel_train_entity", "el_diesel_train_item")
    fix_name("gr_magnet_train_pre_entity", "gr_magnet_train_pre_item")
    fix_name("gr_magnet_train_entity", "gr_magnet_train_item")
end

if settings.startup["re-balance-248k-krastorio-bots"].value then
    data.raw["logistic-robot"]["fu_robo_logistic_entity"].max_payload_size = 12
end


if settings.startup["add-tib-thrower"].value then
    local tib_thrower = table.deepcopy(data.raw["fluid-turret"]["flamethrower-turret"])

    tib_thrower.name = "chemical-sprayer"
    tib_thrower.attack_parameters.fluid_consumption = 1/15
    tib_thrower.attack_parameters.fluids = {{
        damage_modifier = 1.5,
        type = "liquid-tiberium"
    }}
    tib_thrower.attack_parameters.ammo_type.action.action_delivery.stream = "tiberium-chemical-sprayer-stream"
    tib_thrower.minable.result = tib_thrower.name


    local tib_thrower_item = table.deepcopy(data.raw["item"]["flamethrower-turret"])
    tib_thrower_item.name = tib_thrower.name
    tib_thrower_item.place_result = tib_thrower.name

    local tib_thrower_recipe = table.deepcopy(data.raw["recipe"]["flamethrower-turret"])
    tib_thrower_recipe.name = tib_thrower.name
    tib_thrower_recipe.ingredients = {
        {type = "item", name = "flamethrower-turret", amount = 1},
    }
    tib_thrower_recipe.results = {
        {type = "item", name = tib_thrower_item.name, amount = 1},
    }

    data:extend({ tib_thrower, tib_thrower_item, tib_thrower_recipe })
    table.insert(
        data.raw["technology"]["tiberium-military-1"].effects,
        {
            type = "unlock-recipe",
            recipe = tib_thrower.name
        }
    )
end

if settings.startup["ion-tib-det"].value then
    table.insert(
        data.raw["projectile"]["crosshairs"].action[1].action_delivery.target_effects,
        {
            type = "script",
            effect_id = "ion-tib-det"
        }
    )
    
end