table.insert(data.tech_categories, {
    name = "Refinement",
    initial_tech = "t_refinement_root",
    sub_categories = { "Refinement" }
})

data.techs.t_refinement_root = {
    name = "Refinement",
    desc = "Improving ore yields by adding traces of other materials",
    texture = "Main/textures/tech/uplink.png",
    require_tech = { "t_robotics10" },
    category = "Story"
}

data.techs.t_refinement_basic = {
    order = 1,
    name = "Basic Refinement",
    desc = "Using Silica Sand to improve ore yields",
    texture = "Main/skin/Icons/Special/Technologies/Robots.png",
    uplink_recipe = CreateUplinkRecipe({ metalbar = 1, silicon = 1 }, 50),
    progress_count = 10,
    require_tech = { "t_robotics10" },
    category = "Refinement",
    unlocks = {
        "c_ore_refiner",
        "c_ore_finalizer",
        "refinement_catalyst_sand",
        "metalore_refinement_sand"
    }
}

-- blight catalyst, created with blight extraction
-- virus catalyst, created with infected obsidian
-- refinery gas catalyst, multiple potential avenues
-- refinery gas could be the product of unstable matter, but it could also be the product of refining in a higher refinery type, and in either case it could also be a later tech research item

-- maybe add diatomic, trinity, and polyphonic refinement as constraints to multi-refinement?