table.insert(data.categories, {
    name = "Refinement Catalysts",
    tab = "item",
    defs = data.items,
    filter_field = "tag",
    filter_val = "refinement_catalyst"
})

table.insert(data.categories, {
    name = "Refinement Product",
    tab = "item",
    defs = data.items,
    filter_field = "tag",
    filter_val = "refinement_product"
})

data.refinement.ores = {} -- filled later, ore = product

data.refinement.catalysts = {} -- filled later, item = tag AND is an array of tags for ipairs iteration in consistent order

data.refinement.conversion = {} -- filled later, catalyst tag = { ore = refined }

data.refinement.finalize = {} -- filled later, refined = product

data.refinement.all_refinement_steps = {} -- filled later

data.refinement.prefixes = {
    sand = "Sanded",
    blight = "Blighted",
    virus = "Virused",
    gas = "Gassed"
}

function IsRefinementCatalyst(key)
    local item_def = data.items[key]
    return item_def and (item_def.tag == "refinement_catalyst")
end

data.component_register_filters.refinement_catalyst = function(def, cat)
    return def.tag == "refinement_catalyst"
end

data.items.refinement_silicon_mix = {
    tag = "resource", index = 101, name = "Silicon Mix",
    desc = "Silica prepared for refinement into Silicon",
    stack_size = 20,
    slot_type = "storage",
    visual = "v_silica",
    texture = "Main/textures/icons/items/silicon.png",
    production_recipe = CreateProductionRecipe({ silica = 2 }, { c_fabricator = 80, c_refinery = 40, c_advanced_refinery = 15 })
}
data.items.refinement_crystal_powder_mix = {
    tag = "resource", index = 102, name = "Crystal Powder Mix",
    desc = "Crystals and Silica prepared for refinement into Crystal Powder",
    stack_size = 20,
    slot_type = "storage",
    visual = "v_crystal_powder",
    texture = "Main/textures/icons/items/crystalpowder.png",
    production_recipe = CreateProductionRecipe({ crystal = 3, silica = 1 }, { c_fabricator = 240, c_refinery = 120, c_advanced_refinery = 40 })
}
data.items.refinement_aluminumrods_mix = {
    tag = "resource", index = 103, name = "Aluminum Rod Mix",
    desc = "Laterite and Metal Ore prepared for refinement into Aluminum Rod",
    stack_size = 20,
    slot_type = "storage",
    visual = "v_crystal_powder",
    texture = "Main/textures/icons/items/aluminumcops.png",
    production_recipe = CreateProductionRecipe({ laterite = 3, metalore = 1 }, { c_fabricator = 240, c_refinery = 120, c_advanced_refinery = 40 })
}
data.items.refinement_obsidian_brick_mix = {
    tag = "resource", index = 104, name = "Obsidian Brick Mix",
    desc = "Obsidian and Silica prepared for refinement into Obsician Brick",
    stack_size = 20,
    slot_type = "storage",
    visual = "v_obsidian_brick",
    texture = "Main/textures/icons/items/obsidianbrick.png",
    production_recipe = CreateProductionRecipe({ obsidian = 2, silica = 1 }, { c_fabricator = 360, c_refinery = 180, c_advanced_refinery = 60 })
}

data.items.refinement_catalyst_sand = {
    tag = "refinement_catalyst", index = 1, name = "Sand Refinement Catalyst",
    desc = "Silica Sand that has been processed to improve ore yields",
    stack_size = 20,
    slot_type = "storage",
    visual = "v_silica",
    texture = "Refinement/textures/items/silica_cat.png",
    production_recipe = CreateProductionRecipe({ silica = 1 }, { c_assembler = 30, c_refinery = 15, c_advanced_refinery = 5 }, 5)
}
data.items.refinement_catalyst_blight = {
    tag = "refinement_catalyst", race = "blight", index = 2, name = "Blight Refinement Catalyst",
    desc = "Blight Extraction that has been refined and portioned for refinement",
    stack_size = 100,
    slot_type = "gas",
    texture = "Refinement/textures/items/blight_extraction_cat.png",
    production_recipe = CreateProductionRecipe({ blight_extraction = 1 }, { c_assembler = 30, c_refinery = 15, c_advanced_refinery = 5 }, 5)
}
data.items.refinement_catalyst_virus = {
    tag = "refinement_catalyst", race = "virus", index = 3, name = "Virus Refinement Catalyst",
    desc = "Infected Obsidian that has been refined and portioned for refinement",
    stack_size = 20,
    slot_type = "virus",
    texture = "Refinement/textures/items/obsidian_infected_cat.png",
    production_recipe = CreateProductionRecipe({ obsidian_infected = 1 }, { c_assembler = 30, c_refinery = 15, c_advanced_refinery = 5 }, 5)
}
data.items.refinement_gas = {
    tag = "refinement_catalyst", index = 4, name = "Refinement Gas",
    desc = "Gas from advanced refinement. Can be used for refinement.",
    stack_size = 100,
    slot_type = "gas",
    texture = "Refinement/textures/items/refinement_gas.png"
}

data.refinement.data_func = function(base, keys)
    local num = 0
    for _, value in pairs(keys) do
        if value == "sand" then num = num + 1 end
        if value == "blight" then num = num + 2 end
        if value == "virus" then num = num + 4 end
        if value == "gas" then num = num + 8 end
    end

    local id = base.."_ref"..num
    local prefix = ""
    for i = 1, #keys, 1 do
        if i == 1 then
            prefix = data.refinement.prefixes[keys[i]]
        else
            prefix = prefix.." "..data.refinement.prefixes[keys[i]]
        end
    end

    local name = prefix.." "..data.items[base].name

    return {
        num = num,
        id = id,
        name = name,
        texture = "Refinement/textures/items/"..base..num..".png"
    }
end

function GetOrAddRefinementItemDefinition(base, keys)
    local item_data = data.refinement.data_func(base, keys)
    if not data.items[item_data.id] then
        local base_item = data.items[base]
        data.items[item_data.id] = {
            tag = "refinement_product", index = item_data.num, name = item_data.name,
            stack_size = 20,
            slot_type = "storage",
            visual = base_item.visual,
            texture = item_data.texture,
            refinement_base = base,
            refinement_keys = keys
        }
        data.refinement.finalize[item_data.id] = data.refinement.ores[base]
        table.insert(data.refinement.all_refinement_steps, item_data.id)
    end
    return item_data.id
end

function AddRefinementOre(base, product)
    data.refinement.ores[base] = product
    data.items[base].refinement_base = base
    data.items[base].refinement_keys = {}

    for _, ref in ipairs(data.refinement.catalysts) do
        AddRefinementCatalyst(nil, ref, base)
    end
end

function AddRefinementCatalyst(item, key, only_for_base)
    if item then
        table.insert(data.refinement.catalysts, key)
        data.refinement.catalysts[item] = key
        data.refinement.conversion[key] = {}
    end

    local edge_copy = Tool.Copy(data.refinement.conversion)
    local did_edgework = false

    for edge, edge_data in pairs(edge_copy) do
        for ore, ref in pairs(edge_data) do
            local ore_data = data.items[ore]
            if only_for_base and not (ore_data.refinement_base == only_for_base) then
                goto continue
            end
            did_edgework = true

            local new_ore_key = Tool.Copy(ore_data.refinement_keys)
            table.insert(new_ore_key, key)
            local new_ore = GetOrAddRefinementItemDefinition(ore_data.refinement_base, new_ore_key)
            data.refinement.conversion[key][ore] = new_ore

            local ref_data = data.items[ref]
            local new_ref_key = Tool.Copy(ref_data.refinement_keys)
            table.insert(new_ref_key, key)
            local new_ref = GetOrAddRefinementItemDefinition(ref_data.refinement_base, new_ref_key)
            data.refinement.conversion[key][ref] = new_ref

            data.refinement.conversion[edge][new_ore] = new_ref
            ::continue::
        end
    end

    if not did_edgework then -- no edgework means first instance of ore, safe to assume only_for_base is something?
        for ore, _ in pairs(data.refinement.ores) do
            if only_for_base and not ore == only_for_base then
                goto continue
            end
            local ref = GetOrAddRefinementItemDefinition(ore, {key})
            data.refinement.conversion[key][ore] = ref
            ::continue::
        end
    end
end

AddRefinementOre("metalore", "metalbar")
AddRefinementCatalyst("refinement_catalyst_sand", "sand")
AddRefinementOre("refinement_silicon_mix", "silicon")
AddRefinementCatalyst("refinement_catalyst_blight", "blight")
AddRefinementOre("refinement_crystal_powder_mix", "crystal_powder")
AddRefinementCatalyst("refinement_catalyst_virus", "virus")
AddRefinementOre("refinement_aluminumrods_mix", "aluminiumrod")
AddRefinementCatalyst("refinement_gas", "gas")
AddRefinementOre("refinement_obsidian_brick_mix", "obsidian_brick")