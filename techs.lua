table.insert(data.tech_categories, {
    name = "Refinement",
    discovery_tech = "t_refinement_root",
    initial_tech = "t_refinement_basic",
    sub_categories = { "Refinement", "Advanced Refinement" }
})

data.techs.t_refinement_root = {
    name = "Refinement",
    desc = "Improving ore yields by adding traces of other materials",
    texture = "Main/textures/tech/uplink.png",
    require_tech = { "t_robotics10" },
    category = "Story",
    unlocks = data.refinement.all_refinement_steps
}

function RefinementLimit(faction)
    local limit = 1
    if faction:IsUnlocked("t_refinement_catlim2") then limit = limit + 1 end
    if faction:IsUnlocked("t_refinement_catlim3") then limit = limit + 1 end
    if faction:IsUnlocked("t_refinement_catlim4") then limit = limit + 1 end
    return limit
end

data.techs.t_refinement_basic = {
    order = 1,
    name = "Basic Refinement",
    desc = "Using Silica Sand to improve ore yields",
    texture = "Main/skin/Icons/Special/Technologies/Robots.png",
    uplink_recipe = CreateUplinkRecipe({ metalbar = 1, silicon = 1 }, 50),
    progress_count = 10,
    require_tech = { "t_robotics10" },
    category = "Story",
    unlocks = {
        "c_ore_refiner",
        "c_ore_finalizer",
        "refinement_catalyst_sand",
        "refinement_silicon_mix"
    }
}

-- REFINEMENT

data.techs.t_refinement_virus = {
    order = 1,
    name = "Virus Refinement",
    desc = "Using Infected Obsidian to improve ore yields",
    texture = "Main/skin/Icons/Special/Technologies/Virus.png",
    uplink_recipe = CreateUplinkRecipe({ silica = 5, obsidian_infected = 5 }, 500),
    progress_count = 10,
    require_tech = { "t_refinement_basic" },
    category = "Refinement",
    unlocks = {
        "refinement_catalyst_virus"
    }
}

data.techs.t_refinement_catlim2 = {
    order = 2,
    name = "Binary Catalyst Refinement",
    desc = "Allows ores to be processed with two refinement processes",
    texture = "Main/skin/Icons/Special/Technologies/Robots.png",
    uplink_recipe = CreateUplinkRecipe({ metalbar = 20, silicon = 20 }, 500),
    progress_count = 20,
    require_tech = { "t_refinement_basic" },
    category = "Refinement"
}

data.techs.t_refinement_blight = {
    order = 3,
    name = "Blight Refinement",
    desc = "Using Blight Extraction to improve ore yields",
    texture = "Main/skin/Icons/Special/Technologies/Blight.png",
    uplink_recipe = CreateUplinkRecipe({ metalore = 5, blight_extraction = 5 }, 500),
    progress_count = 10,
    require_tech = { "t_refinement_basic" },
    category = "Refinement",
    unlocks = {
        "refinement_catalyst_blight"
    }
}

-- row 2

data.techs.t_refinement_advanced = {
    name = "Advanced Refinement",
    desc = "A faster and more advanced refinery that can capture a byproduct gas",
    texture = "Main/skin/Icons/Special/Technologies/Robots.png",
    uplink_recipe = CreateUplinkRecipe({ crystal_powder = 5, metalbar = 20 }, 500),
    progress_count = 20,
    require_tech = { "t_refinement_catlim2" },
    category = "Refinement",
    unlocks = {
        "c_ore_refiner_advanced",
        "refinement_gas"
    }
}

-- Advanced Refinement
data.techs.t_refinement_crystal_powder = {
    order = 1,
    name = "Crystal Powder Refinement",
    desc = "Preparing Crystals and Silica to improve yields",
    texture = "Main/skin/Icons/Special/Technologies/Robots.png",
    uplink_recipe = CreateUplinkRecipe({ silica = 20, crystal = 20, crystal_powder = 10 }, 500),
    progress_count = 20,
    require_tech = { "t_refinement_catlim2" },
    category = "Advanced Refinement",
    unlocks = {
        "refinement_crystal_powder_mix"
    }
}

data.techs.t_refinement_aluminumrods = {
    order = 2,
    name = "Aluminum Rod Refinement",
    desc = "Preparing Laterite and Metal Ore to improve yields",
    texture = "Main/skin/Icons/Special/Technologies/Robots.png",
    uplink_recipe = CreateUplinkRecipe({ laterite = 20, metalore = 20, aluminiumrod = 10 }, 500),
    progress_count = 20,
    require_tech = { "t_refinement_catlim2" },
    category = "Advanced Refinement",
    unlocks = {
        "refinement_aluminumrods_mix"
    }
}

data.techs.t_refinement_catlim3 = {
    order = 3,
    name = "Ternary Catalyst Refinement",
    desc = "Allows ores to be processed with three refinement processes",
    texture = "Main/skin/Icons/Special/Technologies/Robots.png",
    uplink_recipe = CreateUplinkRecipe({ metalbar = 20, silicon = 20, refinement_gas = 10 }, 1000),
    progress_count = 30,
    require_tech = { "t_refinement_catlim2" },
    category = "Advanced Refinement"
}

data.techs.t_refinement_obsidian_brick = {
    order = 4,
    name = "Obsidian Brick Refinement",
    desc = "Preparing Obsidian and Silica to improve yields",
    texture = "Main/skin/Icons/Special/Technologies/Robots.png",
    uplink_recipe = CreateUplinkRecipe({ obsidian = 20, silica = 20, obsidian_brick = 10 }, 500),
    progress_count = 20,
    require_tech = { "t_refinement_catlim2" },
    category = "Advanced Refinement",
    unlocks = {
        "refinement_obsidian_brick_mix"
    }
}

-- row 2

data.techs.t_refinement_catlim4 = {
    name = "Quaternary Catalyst Refinement",
    desc = "Allows ores to be processed with four refinement processes",
    texture = "Main/skin/Icons/Special/Technologies/Robots.png",
    uplink_recipe = CreateUplinkRecipe({ refinement_gas = 20 }, 2000),
    progress_count = 50,
    require_tech = { "t_refinement_catlim3" },
    category = "Advanced Refinement"
}