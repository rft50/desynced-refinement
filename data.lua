local package = ...

-- files loaded when mod is initializing
package.includes = {
	"items.lua",
	"components.lua",
	"techs.lua"
}

data.refinement = {}

-- called when mod is initializing
function package:init()
end