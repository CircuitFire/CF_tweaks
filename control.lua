

if settings.startup["ion-tib-det"].value then
    script.on_event(defines.events.on_script_trigger_effect, function(event)
        --game.print("event: " .. event.effect_id )
        if event.effect_id ~= "ion-tib-det" then return end

        --game.print("event: " .. serpent.block(event))
        local position = event.target_position
        local surface = game.surfaces[event.surface_index]
    
        --spawn tib rockets on every tib ore
        for _, ore in pairs(surface.find_entities_filtered{
            position = position,
            radius = settings.startup["ion-cannon-radius"].value,
            name = {"tiberium-ore", "tiberium-ore-blue"}
        }) do
            surface.create_entity{
                name = "tiberium-rocket",
                speed = 1,
                position = ore.position,
                target = ore.position,
            }
            ore.destroy()
        end

        --spawn tib nukes on every tib ore node
        if settings.startup["ion-tib-node-det"].value then
            for _, node in pairs(surface.find_entities_filtered{
                position = position,
                radius = settings.startup["ion-cannon-radius"].value,
                name = {"tibGrowthNode"}
            }) do
                surface.create_entity{
                    name = "tiberium-nuke",
                    speed = 1,
                    position = node.position,
                    target = node.position,
                }
                node.destroy()
            end
        end
    end)
end