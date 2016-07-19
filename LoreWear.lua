local LoreWear = LorePlay

local collectiblesMenu
local Appearance, Costumes, Hats, Polymorphs, Skins = 3, 1, 2, 3, 4 -- DLC = 1, Upgrade = 2, Appearance = 3, Assistants = 4, etc. Subcategories are also sequential 

local function BuildCollectiblesMenuTable()	
	collectiblesMenu = {
		[Appearance] = { --Appearance 
			[Costumes] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_COSTUME)
			[Hats] =  GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_HAT)
			[Polymorphs] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_POLYMORPH)
			[Skins] = GetTotalCollectiblesByCategoryType(COLLECTIBLE_CATEGORY_TYPE_SKIN)
		}
	}

	local id = GetCollectibleId(Appearance,Costumes,15)
	--d(GetCollectibleCategoryInfo(3))
	--d(GetCollectibleInfo(index))
	UseCollectible(id)
end


function LoreWear.InitializeLoreWear()
	BuildCollectiblesMenuTable()
end

LorePlay = LoreWear