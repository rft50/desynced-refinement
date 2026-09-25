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

data.refinement.conversion = {
    refinement_catalyst_sand = {
        metalore = "metalore_refinement_sand"
    }
}

data.refinement.finalize = {
    metalore_refinement_sand = "metalbar"
}

function IsRefinementCatalyst(key)
    local item_def = data.items[key]
    return item_def and (item_def.tag == "refinement_catalyst")
end

data.component_register_filters.refinement_catalyst = function(def, cat)
    return def.tag == "refinement_catalyst"
end

data.items.refinement_catalyst_sand = {
    tag = "refinement_catalyst", index = 1, name = "Sand Refinement Catalyst",
    desc = "Silica Sand that has been processed to improve ore yields",
    stack_size = 20,
    slot_type = "storage",
    visual = "v_metalore",
    texture = "Refinement/textures/items/metalore A.png",
    production_recipe = CreateProductionRecipe({ silica = 1 }, { c_assembler = 30, c_refinery = 15, c_advanced_refinery = 5 }, 5)
}

data.items.metalore_refinement_sand = {
    tag = "refinement_product", index = 1, name = "Sanded Metal Ore",
    stack_size = 20,
    slot_type = "storage",
    visual = "v_metalore",
    texture = "Refinement/textures/items/metalore D1.png"
}