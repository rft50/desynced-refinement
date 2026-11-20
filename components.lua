local c_ore_refiner = Comp:RegisterComponent("c_ore_refiner", {
    attachment_size = "Small", race = "robot", index = 0, name = "Ore Refiner",
	texture = "Main/textures/icons/components/Component_Blight3.png",
	desc = "Uses various resources to get you more ore per ore.",
	visual = "v_blight_converter",
	production_recipe = CreateProductionRecipe({ metalbar = 5, silicon = 5 }, {
		c_assembler = 40
	}),
	activation = "OnAnyItemSlotChange",
    registers = { { filter = "refinement_catalyst", tip = "Refinement Catalyst" }, { read_only = true, tip = "Refining" } },
	power = -5
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
	local catalyst_key = data.refinement.catalysts[catalyst]

	if not work_finished and comp.is_working then return comp:SetStateContinueWork() end

	local makes_gas = self.refinement_gas
	local gas_count = comp.extra_data.refinement_gas_progress or 0
	if gas_count >= 8 then
		if comp.owner:AddItem("refinement_gas", 1, true) then
			comp.extra_data.refinement_gas_progress = gas_count - 8
		end
	end

	local owner = comp.owner
	local itemCount = owner.CountItem
	local speed = self.refinement_speed or 1
	for ore, res in pairs(data.refinement.conversion[catalyst_key]) do
		if itemCount(owner, ore) >= 4 then
			if #data.items[res].refinement_keys <= RefinementLimit(comp.faction) then
				if comp:PrepareProduceProcess({ [ore] = 4, [catalyst] = 1 }, { [res] = 5 }) then
					comp:SetRegister(2, { id = res, num = 5 })
					if makes_gas then
						comp.extra_data.refinement_gas_progress = gas_count + 1
					end
					return comp:SetStateStartWork(80 / speed, true)
				end
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

local c_ore_refiner_advanced = c_ore_refiner:RegisterComponent("c_ore_refiner_advanced", {
    attachment_size = "Medium", race = "robot", index = 1, name = "Advanced Ore Refiner",
	texture = "Main/textures/icons/components/Component_Blight1.png",
	desc = "Uses various resources to get you more ore per ore. Produces Refinery Gas every few operations.",
	visual = "v_blight_magnifier",
	production_recipe = CreateProductionRecipe({ refined_crystal = 5, icchip = 5, c_ore_refiner = 1 }, {
		c_advanced_assembler = 100
	}),
	activation = "OnAnyItemSlotChange",
    registers = { { filter = "refinement_catalyst", tip = "Refinement Catalyst" }, { read_only = true, tip = "Refining" } },
	power = -10,
	slots = { gas = 1 },
	refinement_speed = 2,
	refinement_gas = true
})

local c_ore_finalizer = Comp:RegisterComponent("c_ore_finalizer", {
	attachment_size = "Small", race = "robot", index = 2, name = "Ore Finalizer",
	texture = "Main/textures/icons/components/Component_Blight3.png",
	desc = "Turns refined ores into their final product.",
	visual = "v_blight_converter",
	production_recipe = CreateProductionRecipe({ metalplate = 5, silicon = 5 }, {
		c_assembler = 40
	}),
	activation = "OnAnyItemSlotChange",
    registers = { { read_only = true, tip = "Finalizing" } },
	power = -10
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
