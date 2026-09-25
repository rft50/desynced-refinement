-- define and register a custom component, the ID needs to be unique
local c_mod_self_teleport = Comp:RegisterComponent("c_mod_self_teleport", {
	name = "Magical Self Teleporter",
	desc = "Teleport unit to location specified in register",
	texture = "Main/textures/icons/components/Component_UnitTeleporter_01_L.png",
	slot_type = "storage",
	attachment_size = "Internal",
	visual = "v_generic_i",
	activation = "OnFirstRegisterChange",
	registers = { { tip = "Coordinate" } },
})

-- callback called when the component is activated
function c_mod_self_teleport:on_update(comp)
	local coord = comp:GetRegisterCoord(1)
	if coord then
		-- have a coordinate, teleport the owner there
		Map.Defer(function() comp.owner:Place(coord.x, coord.y) end)
	end
end

local c_ore_refiner = Comp:RegisterComponent("c_ore_refiner", {
    attachment_size = "Small", race = "robot", index = 0, name = "Ore Refiner",
	texture = "Main/textures/icons/components/Component_Blight3.png",
	desc = "Uses various resources to get you more ore per ore.",
	visual = "v_blight_converter",
	production_recipe = CreateProductionRecipe({ metalbar = 1 }, {
		c_assembler = 1
	}),
	activation = "OnAnyItemSlotChange",
    registers = { { filter = "refinement_catalyst", tip = "Refinement Catalyst" }, { read_only = true, tip = "Refining" } }
})

function c_ore_refiner:on_update(comp, cause)
	local work_finished = (cause & CC_FINISH_WORK == CC_FINISH_WORK)
	if work_finished then
		comp:SetRegister(2, nil)
		comp:FulfillProcess()
	end

	local catalyst_reg = comp:GetRegister(1)
	local catalyst = catalyst_reg.item_id
	if not IsRefinementCatalyst(catalyst) then
		comp:FlagRegisterError(1)
		comp:SetRegister(2, nil)
		comp:CancelProcess()
		return comp:SetStateSleep(TICKS_PER_SECOND)
	end

	if not work_finished and comp.is_working then return comp:SetStateContinueWork() end

	local owner = comp.owner
	local itemCount = owner.CountItem
	for ore, res in pairs(data.refinement.conversion[catalyst]) do
		if itemCount(owner, ore) >= 4 then
			if comp:PrepareProduceProcess({ [ore] = 4, [catalyst] = 1 }, { [res] = 5 }) then
				comp:SetRegister(2, { id = res, num = 5 })
				return comp:SetStateStartWork(80, true)
			end
		end
	end
end

function c_ore_refiner:get_reg_err(comp)
	if not IsRefinementCatalyst(comp:GetRegister(1).item_id) then
		return "Invalid catalyst"
	end
	return "Not enough room for output"
end

local c_ore_finalizer = Comp:RegisterComponent("c_ore_finalizer", {
	attachment_size = "Small", race = "robot", index = 0, name = "Ore Finalizer",
	texture = "Main/textures/icons/components/Component_Blight3.png",
	desc = "Turns refined ores into their final product.",
	visual = "v_blight_converter",
	production_recipe = CreateProductionRecipe({ metalbar = 1 }, {
		c_assembler = 1
	}),
	activation = "OnAnyItemSlotChange",
    registers = { { read_only = true, tip = "Finalizing" } }
})

function c_ore_finalizer:on_update(comp, cause)
	local work_finished = (cause & CC_FINISH_WORK == CC_FINISH_WORK)
	if work_finished then
		comp:SetRegister(1, nil)
		comp:FulfillProcess()
	end

	if not work_finished and comp.is_working then return comp:SetStateContinueWork() end

	local owner = comp.owner
	local itemCount = owner.CountItem
	for ore, res in pairs(data.refinement.finalize) do
		if itemCount(owner, ore) >= 1 then
			if comp:PrepareProduceProcess({ [ore] = 1 }, { [res] = 1 }) then
				comp:SetRegister(1, { id = res })
				return comp:SetStateStartWork(10, true)
			end
		end
	end
end
