LorePlay = LorePlay or {}

LorePlay.Appearance = "Appearance"
LorePlay.Hats = "Hat"
LorePlay.Costumes = "Costume"
LorePlay.Skins = "Skin"
LorePlay.Polymorphs = "Polymorph"
LorePlay.Hair = "Hair"
LorePlay.FacialAcc = "Facial Accessory"
LorePlay.FacialHair = "Facial Hair"
LorePlay.BodyMarkings = "Body Marking"
LorePlay.HeadMarkings = "Head Marking"
LorePlay.Jewelry = "Jewelry"
LorePlay.Personalities = "Personality"
LorePlay.VanityPets = "Vanity Pet"
LorePlay.City = "City"
LorePlay.Housing = "Housing"
LorePlay.Dungeon = "Dungeon"
LorePlay.Adventure = "Adventure"
LorePlay.Total = "Total"
LorePlay.player = "player"

local Appearance = LorePlay.Appearance
local Hats = LorePlay.Hats
local Costumes = LorePlay.Costumes
local Skins = LorePlay.Skins
local Polymorphs = LorePlay.Polymorphs
local Hair = LorePlay.Hair
local FacialAcc = LorePlay.FacialAcc
local FacialHair = LorePlay.FacialHair
local BodyMarkings = LorePlay.BodyMarkings
local HeadMarkings = LorePlay.HeadMarkings
local Jewelry = LorePlay.Jewelry
local Personalities = LorePlay.Personalities
local VanityPets = LorePlay.VanityPets
local City = LorePlay.City
local Housing = LorePlay.Housing
local Dungeon = LorePlay.Dungeon
local Adventure = LorePlay.Adventure
local Total = LorePlay.Total
local player = LorePlay.player


LorePlay.stringToColTypeTable = {
	[Hats] = COLLECTIBLE_CATEGORY_TYPE_HAT,
	[Costumes] = COLLECTIBLE_CATEGORY_TYPE_COSTUME,
	[Skins] = COLLECTIBLE_CATEGORY_TYPE_SKIN,
	[Hair] = COLLECTIBLE_CATEGORY_TYPE_HAIR,
	[Polymorphs] = COLLECTIBLE_CATEGORY_TYPE_POLYMORPH,
	[FacialAcc] = COLLECTIBLE_CATEGORY_TYPE_FACIAL_ACCESSORY,
	[FacialHair] = COLLECTIBLE_CATEGORY_TYPE_FACIAL_HAIR_HORNS,
	[BodyMarkings] = COLLECTIBLE_CATEGORY_TYPE_BODY_MARKING,
	[HeadMarkings] = COLLECTIBLE_CATEGORY_TYPE_HEAD_MARKING,
	[Jewelry] = COLLECTIBLE_CATEGORY_TYPE_PIERCING_JEWELRY,
	[Personalities] = COLLECTIBLE_CATEGORY_TYPE_PERSONALITY,
	[VanityPets] = COLLECTIBLE_CATEGORY_TYPE_VANITY_PET
}
