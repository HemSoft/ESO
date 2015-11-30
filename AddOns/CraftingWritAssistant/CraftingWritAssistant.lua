--[[ 
This Add-on is not created by, affiliated with or sponsored by ZeniMax Media Inc. or its affiliates. The Elder Scrolls® and related logos are registered trademarks or trademarks of ZeniMax Media Inc. in the United States and/or other countries. All rights reserved.
You can read the full terms at https://account.elderscrollsonline.com/add-on-terms

 The grids in this application are borrowed from the ScrollListExample from Librairan, and this addon was built with some great help from our ESOUI community.
  ]]
local LAM = LibStub:GetLibrary("LibAddonMenu-2.0")


CraftingWritAssistant = {}
CraftingWritAssistant.name = "CraftingWritAssistant"

CraftingWritAssistant.Default = {
	OffsetX = 0,
	OffsetY = 0,   
	ShowCraftingWritWindowAtStation = true,
	SaveWindowLocation = true,
	ShowCraftingWritWindowAtGuildBank = false,
	ShowCraftingWritWindowAtBank = false,
	ShowIngredientsAtProvisioning = true
}

CraftingWritAssistant.CurrentCraftingWritSteps = {}
CraftingWritAssistant.CurrentCraftingType = {}
CraftingWritAssistant.AutoSelectionInProgress = false


local function SetToolTip(ctrl, text, placement)
    ctrl:SetHandler("OnMouseEnter", function(self)
        ZO_Tooltips_ShowTextTooltip(self, placement, text)
    end)
    ctrl:SetHandler("OnMouseExit", function(self)
        ZO_Tooltips_HideTextTooltip()
    end)
end

function trimstring(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function hex2rgb(hex)
    hex = hex:gsub("#","")
    return tonumber("0x"..hex:sub(1,2),16)/255, tonumber("0x"..hex:sub(3,4),16)/255, tonumber("0x"..hex:sub(5,6),16)/255
end

function DisplaySelectedWritInformation(selectedWrit)
	local craftSkill = GetCraftingWritTypeFromQuestName(selectedWrit)
	--d(craftSkill)
	--d(selectedWrit)
   CraftingWritAssistant.BindandShowData(craftSkill)	
end

function OnCraftingWritAssistSelect(_, selectedWrit, choice)  	
	if CraftingWritAssistant.AutoSelectionInProgress ~= true then
		DisplaySelectedWritInformation(selectedWrit)	
	end				
end	

function SetSelectedItemWritDropdown(selectedText)
	CraftingWritAssistant.CraftingWritAssistantCharSelect.dropdown:SetSelectedItem(selectedText)
end
function ClearWritNameDropdown()
	CraftingWritAssistant.CraftingWritAssistantCharSelect.dropdown:ClearItems()
end
function EnableWritNameDropdown(enabled)
	CraftingWritAssistant.CraftingWritAssistantCharSelect.dropdown:SetEnabled(enabled)
end

function BindActiveQuestingWritDropDown()
	ClearWritNameDropdown()
	--local firstFoundWritName = ""

	for i=1, GetNumJournalQuests() do
		   local questType = GetJournalQuestType(i)			
		   if questType == QUEST_TYPE_CRAFTING then					
				--string questName, string backgroundText, string activeStepText, integer activeStepType, string activeStepTrackerOverrideText, 
				--boolean completed, boolean tracked, integer questLevel, boolean pushed, integer questType, integer instanceDisplayType			
				local questName = GetJournalQuestName(i)
				--d(questName)
				--if(firstFoundWritName == "") then
				--	firstFoundWritName = questName
				--end
				
				local dropDownItem = CraftingWritAssistant.CraftingWritAssistantCharSelect.dropdown:CreateItemEntry(questName, OnCraftingWritAssistSelect)
				CraftingWritAssistant.CraftingWritAssistantCharSelect.dropdown:AddItem(dropDownItem)
						
		   end
	end

	--if(firstFoundWritName ~= "") then
	--	SetSelectedItemWritDropdown(firstFoundWritName)
	--end	

end

--build primary window
function CraftingWritAssistant.CreatePrimaryWindow()	
		
	local ySpacingSteps = 25
	
	--create controls
	for i = 1, 4 do
		  local stepInfoControl = CreateControlFromVirtual("CraftingWritAssistantStepItem", CraftingWritStepList, "CraftingWritAssistantStepItem", i)
		  
		  stepInfoControl:ClearAnchors()
		  stepInfoControl:SetAnchor(TOPLEFT, CraftingWritStepList, TOPLEFT, 0, ySpacingSteps)  
		  
		  local addInfoControl = CreateControlFromVirtual("CraftingWritAssistantAddInfoItem", CraftingWritStepList, "CraftingWritAssistantAddInfoItem", i)
		  
		  addInfoControl:ClearAnchors()
		  addInfoControl:SetAnchor(TOPLEFT, CraftingWritStepList, TOPLEFT, 400, ySpacingSteps)  
		  
		  ySpacingSteps = ySpacingSteps + 20
	end
	
	CraftingWritAssistant.CraftingWritAssistantCharSelect = WINDOW_MANAGER:CreateControlFromVirtual("CraftingWritAssistantCharSelect", CraftingWritAssistantWindow, "ZO_StatsDropdownRow")
    CraftingWritAssistant.CraftingWritAssistantCharSelect:SetAnchor(TOPRIGHT, CraftingWritAssistantWindow, TOPRIGHT, -120, 14)
	
	local craftingWritAssitDropdown = CraftingWritAssistant.CraftingWritAssistantCharSelect:GetNamedChild("Dropdown")
    craftingWritAssitDropdown:SetWidth(180)	
		
	BindActiveQuestingWritDropDown()
			
	CraftingWritAssistantWindow:ClearAnchors()
	
	--if CraftingWritAssistant.savedVariables.OffsetX ~= 0 and  CraftingWritAssistant.savedVariables.OffsetY ~= 0 then
	-- Some might like to set the default position to 0,0 so let them if the "remember position" option is on. ;) -Phinix
	
	if CraftingWritAssistant.savedVariables.SaveWindowLocation == true then
		CraftingWritAssistantWindow:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, CraftingWritAssistant.savedVariables.OffsetX, CraftingWritAssistant.savedVariables.OffsetY)		
	else
		CraftingWritAssistantWindow:SetAnchor(TOP, GuiRoot, TOP, 0, 50)			
	end
	
	
end


function CraftingWritAssistant.SaveWindowLocation()
	if CraftingWritAssistant.savedVariables.SaveWindowLocation == true then
		CraftingWritAssistant.savedVariables.OffsetX = CraftingWritAssistantWindow:GetLeft()
		CraftingWritAssistant.savedVariables.OffsetY = CraftingWritAssistantWindow:GetTop()	
	end
end

function CraftingWritAssistant.CreateOptionsWindow()

   local panel = {
		type = "panel",
		name = "Crafting Writ Assistant",
		author = "@Argusus",
		version = ".04b",
		slashCommand = "/cwasettings",
		registerForRefresh = true
	}
	
	local optionsData = {
		[1] = {
		type = "checkbox",
		name = "Display at crafting station",
		tooltip = "Display at crafting station?",
		getFunc = function() return CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtStation end,
		setFunc = function(value) CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtStation = value end
		},
		[2] = {
		type = "checkbox",
		name = "Remember window position",
		tooltip = "Remember last window position?",
		getFunc = function() return CraftingWritAssistant.savedVariables.SaveWindowLocation end,
		setFunc = function(value) CraftingWritAssistant.savedVariables.SaveWindowLocation = value end
		},
		[3] = {
		type = "checkbox",
		name = "Display at Guild Bank",
		tooltip = "This will display the writ window at your guild bank",
		getFunc = function() return CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtGuildBank end,
		setFunc = function(value) CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtGuildBank = value end
		},
		[4] = {
		type = "checkbox",
		name = "Display at Bank",
		tooltip = "This will display the writ window at your bank",
		getFunc = function() return CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtBank end,
		setFunc = function(value) CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtBank = value end
		},
		[5] = {
		type = "checkbox",
		name = "Display Provisioning Ingredients?",
		tooltip = "This will display ingredients for provisioning writs",
		getFunc = function() return CraftingWritAssistant.savedVariables.ShowIngredientsAtProvisioning end,
		setFunc = function(value) CraftingWritAssistant.savedVariables.ShowIngredientsAtProvisioning = value end
		}
		}
				
	LAM:RegisterAddonPanel("CraftingWritAssistantPanel", panel)
	LAM:RegisterOptionControls("CraftingWritAssistantPanel", optionsData)

end

function GetCraftingWritNameFromCraftingType(craftingType)

local returnValue

if craftingType == CRAFTING_TYPE_WOODWORKING then
	returnValue = "Woodworker Writ"
end

if craftingType == CRAFTING_TYPE_CLOTHIER then
	returnValue = "Clothier Writ"
end

if craftingType == CRAFTING_TYPE_BLACKSMITHING then
	returnValue = "Blacksmith Writ"
end

if craftingType == CRAFTING_TYPE_ENCHANTING then
	returnValue = "Enchanter Writ"
end

if craftingType == CRAFTING_TYPE_PROVISIONING then
	returnValue = "Provisioner Writ"
end

if craftingType == CRAFTING_TYPE_ALCHEMY then
    returnValue = "Alchemist Writ"
end


return returnValue
end

function GetCraftingWritTypeFromQuestName(questName)

local returnValue

if PlainStringFind(questName, "Woodwork") then
	returnValue = CRAFTING_TYPE_WOODWORKING
end

if PlainStringFind(questName, "Cloth") then
	returnValue = CRAFTING_TYPE_CLOTHIER
end

if PlainStringFind(questName, "Blacksmith") then
	returnValue = CRAFTING_TYPE_BLACKSMITHING
end

if PlainStringFind(questName, "Enchant") then
	returnValue = CRAFTING_TYPE_ENCHANTING
end

if PlainStringFind(questName, "Provision") then
	returnValue = CRAFTING_TYPE_PROVISIONING
end

if PlainStringFind(questName, "Alchemist") then
    returnValue = CRAFTING_TYPE_ALCHEMY
end

return returnValue
end

function trim2(s)
  return s:match "^%s*(.-)%s*$"
end

function BindProvisioningDetails(craftingType)

if craftingType == CRAFTING_TYPE_PROVISIONING then
		
	--clean up recipe name
	local writRecipes = {}
	for i = 1, 4 do
		local currentStepInfo = CraftingWritAssistant.CurrentCraftingWritSteps[craftingType].steps[i]
		if currentStepInfo ~= nil then	
			local stringIndex = string.find(currentStepInfo, " ") 
			if stringIndex ~= nil then
				stringIndex = stringIndex + 1
			end
			--TODO: Fix error here when finishing a provision quest
			local endIndex = string.find(currentStepInfo, ":")			
			if endIndex ~= nil then
				endIndex = endIndex - 1
			end
					
			if stringIndex ~= nil and endIndex ~= nil then			
				local recipeParsedName = trim2(string.sub(currentStepInfo,stringIndex, endIndex))
				table.insert(writRecipes, recipeParsedName) 		
				--d(recipeParsedName)
			end				
			
		end
	end
		
	--default text to unknown
	for i = 1, #writRecipes do		
		local additionalInfoText = GetControl("CraftingWritAssistantAddInfoItem"..tostring(i), "Description")
		additionalInfoText:SetText("Unknown Recipe")
		additionalInfoText:SetColor(1, 0.2, 0.2, 1)   -- Red		
	end
		
	for i = 1, GetNumRecipeLists() do
		--returns: string name, integer numRecipes, textureName upIcon, 
		--textureName downIcon, textureName overIcon, textureName disabledIcon, string createSound
		local listName, numRecipes = GetRecipeListInfo(i)
		for x = 1, numRecipes do
		--Returns: boolean known, string name, integer numIngredients, integer provisionerLevelReq, integer qualityReq, integer ProvisionerSpecialIngredientType specialIngredientType	
		local known, recipeName, numIngredients = GetRecipeInfo(i,x)
		
		if known == true then	
										
			for y = 1, #writRecipes do				
				if recipeName == writRecipes[y] then
					
					local additionalInfoText = GetControl("CraftingWritAssistantAddInfoItem"..tostring(y), "Description")			
										
					--d(writRecipes[y].." - Found")				
						local listOfIngred = ""
						for z = 1, numIngredients do
							local ingredName = GetRecipeIngredientItemInfo(i,x,z)
							--Returns: string name, textureName icon, integer requiredQuantity, integer sellPrice, integer quality
							--local ingredName = GetRecipeIngredientItemLink(i,x,z, LINK_STYLE_BRACKETS)
							--d(ingredName)	
							listOfIngred = listOfIngred .. ingredName .. ","
						end							
					--trim last ","
					listOfIngred = string.sub(listOfIngred, 1, -2)
					additionalInfoText:SetText(listOfIngred)
					additionalInfoText:SetColor(0.2, 1, 0.2, 1)   -- Green
					--additionalInfoText:SetMouseEnabled(true)						
					--	additionalInfoText:SetHandler("OnMouseUp", function(self, button, upInside, ctrl, alt, shift, command)
					--			if upInside then					
					--				ZO_LinkHandler_OnLinkClicked(displayLink, button, self)
					--			end
					--	end)					
					--d(listOfIngred)
				end
			end		
		end
				
		end	
		
	end
else
	--clear controls
	for i = 1, 4 do		
		local additionalInfoText = GetControl("CraftingWritAssistantAddInfoItem"..tostring(i), "Description")
		additionalInfoText:SetText("")	
	end
	
end

end --end function

function LoadCraftingWritJournalData()

for i=1, GetNumJournalQuests() do
	   local questType = GetJournalQuestType(i)
		-- d(questType)		
	   if questType == QUEST_TYPE_CRAFTING then
					
			--string questName, string backgroundText, string activeStepText, integer activeStepType, string activeStepTrackerOverrideText, 
			--boolean completed, boolean tracked, integer questLevel, boolean pushed, integer questType, integer instanceDisplayType
			
			--local questName,backgroundText,activeStepText = GetJournalQuestInfo(i)
			local questName = GetJournalQuestInfo(i)
			
			local craftingType = GetCraftingWritTypeFromQuestName(questName)
			--d(questName)			
			--d(craftingType)
			 
			 CraftingWritAssistant.CurrentCraftingWritSteps[craftingType] = {}
			   						
					local craftingWritDetails = { name = questName, steps = {}}
					
					--d(craftingWritDetails)								
					for x=1, GetJournalQuestNumSteps(i) do
																  
						   for y=1, GetJournalQuestNumConditions(i,x) do
						   -- string conditionText, integer current, integer max, boolean isFailCondition, boolean isComplete, boolean isCreditShared
							   local conditionText,current = GetJournalQuestConditionInfo(i,x,y)								  
								  if conditionText ~= "" then
									 table.insert(craftingWritDetails.steps,conditionText)
								  end
						   end
					end
				CraftingWritAssistant.CurrentCraftingWritSteps[craftingType] = craftingWritDetails
	   end
end

end

-- do all this when the addon is loaded
function CraftingWritAssistant.OnAddOnLoaded(eventCode, addOnName)

	if addOnName ~= CraftingWritAssistant.name then return end

		CraftingWritAssistant.savedVariables = ZO_SavedVars:NewAccountWide("CraftingWritAssistantVars", 1, nil, CraftingWritAssistant.Default)
		
		if CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtGuildBank == nil then
			 CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtGuildBank = false
		end
		
		if CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtBank == nil then
			 CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtBank = false
		end
		
		if CraftingWritAssistant.savedVariables.ShowIngredientsAtProvisioning == nil then
			 CraftingWritAssistant.savedVariables.ShowIngredientsAtProvisioning = true
		end
		
						
		
		-- Register Keybinding
		ZO_CreateStringId("SI_BINDING_NAME_SHOWWINDOW_CraftingWritAssistant", "Toggle Writ Assistant")

		CraftingWritAssistant.CreatePrimaryWindow()
		CraftingWritAssistant.CreateOptionsWindow()
		--d("Loaded")

end

function CraftingWritAssistant.BindandShowData(craftSkill)	


local numberOfWritQuests = CraftingWritAssistant.CraftingWritAssistantCharSelect.dropdown:GetNumItems()
--d(numberOfWritQuests)
--d(craftSkill)

if craftSkill == nil or craftSkill == "" then
	if numberOfWritQuests > 0 then
		CraftingWritAssistant.AutoSelectionInProgress = true
		CraftingWritAssistant.CraftingWritAssistantCharSelect.dropdown:SelectItemByIndex(1)
		local selectedWrit = CraftingWritAssistant.CraftingWritAssistantCharSelect.dropdown:GetSelectedItem()
		--d("Auto select Item:"..selectedWrit)
		craftSkill = GetCraftingWritTypeFromQuestName(selectedWrit)
		--d("Auto Writ Type:"..craftSkill)
		CraftingWritAssistant.AutoSelectionInProgress = false	
		EnableWritNameDropdown(true)
		--ActiveWritLabel:SetText(selectedWrit)		
		--CraftingWritAssistant.CraftingWritAssistantCharSelect.dropdown:SelectItemByIndex(1)
	else
		d("No Active Writs")
		ActiveWritLabel:SetText("No Active Writs")	
		EnableWritNameDropdown(false)				
		for i = 1, 4 do			
			local label = GetControl("CraftingWritAssistantStepItem"..tostring(i), "Description")							
			label:SetText("")			
		end
		for i = 1, 4 do		
			local additionalInfoText = GetControl("CraftingWritAssistantAddInfoItem"..tostring(i), "Description")
			additionalInfoText:SetText("")		
		end
		CraftingWritAssistantWindow:SetHidden(true) 
		CraftingWritAssistant.ToggleSlotUpdateEvent(false) 
		return
	end

end
--d("BindandShowData")
if craftSkill == CRAFTING_TYPE_ALCHEMY or
 craftSkill == CRAFTING_TYPE_BLACKSMITHING or
 craftSkill == CRAFTING_TYPE_CLOTHIER or
 craftSkill == CRAFTING_TYPE_ENCHANTING or
 craftSkill == CRAFTING_TYPE_PROVISIONING or
 craftSkill == CRAFTING_TYPE_WOODWORKING then
 
 
--		for i = 1, 4 do			
--			local label = GetControl("CraftingWritAssistantStepItem"..tostring(i), "Description")							
--			label:SetText("")			
--		end
--		for i = 1, 4 do		
--			local additionalInfoText = GetControl("CraftingWritAssistantAddInfoItem"..tostring(i), "Description")
--			additionalInfoText:SetText("")		
--		end
 
	CraftingWritAssistant.CurrentCraftingType = craftSkill
		
	LoadCraftingWritJournalData()
	
	if(CraftingWritAssistant.CurrentCraftingWritSteps[craftSkill] ~= nil) then
		
		ActiveWritLabel:SetText(CraftingWritAssistant.CurrentCraftingWritSteps[craftSkill].name)		
		
		--bind steps	
		for i = 1, 4 do
			local currentStepInfo = CraftingWritAssistant.CurrentCraftingWritSteps[craftSkill].steps[i]
		
			local label = GetControl("CraftingWritAssistantStepItem"..tostring(i), "Description")
					
			if currentStepInfo ~= nil then					 
				 --if string.find(currentStepInfo, "Deliver") then
				--	 label:SetText("")
				-- else
					label:SetText(currentStepInfo)
				 --end
			else
				 label:SetText("")
			end

		end
		
		if CraftingWritAssistant.savedVariables.ShowIngredientsAtProvisioning == true then	
			if craftSkill == CRAFTING_TYPE_PROVISIONING then	
				local currentStepInfo = CraftingWritAssistant.CurrentCraftingWritSteps[craftSkill].steps[1]
				--d("Binding details")
				--no need to rebind if we are in the "deliver" stage of the quest
				if string.find(currentStepInfo, "Deliver") then
					for i = 1, 4 do		
						local additionalInfoText = GetControl("CraftingWritAssistantAddInfoItem"..tostring(i), "Description")
						additionalInfoText:SetText("")		
					end
				else
					BindProvisioningDetails(craftSkill)	
				end
							
			end
		end	
		--EnableWritNameDropdown(true)
		CraftingWritAssistantWindow:SetHidden(false) 
	--else 
		--d("CurrentCraftingWritSteps[craftSkill] is nil, no steps found")
	end
end
	
end

function CraftingWritAssistant.CraftingStationEnter(eventCode, craftSkill, sameStation)
	if CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtStation == true then		
		local writName = GetCraftingWritNameFromCraftingType(craftSkill)
		--d(writName)
		SetSelectedItemWritDropdown(writName)
		EnableWritNameDropdown(false)
		CraftingWritAssistant.BindandShowData(craftSkill)
	end	
end

function CraftingWritAssistant.CraftingStationLeft(eventCode)	
	--local craftSkill = GetCraftingInteractionType()
	--d(CraftingWritAssistant.CurrentCraftingType)
	EnableWritNameDropdown(true)
	--CraftingWritAssistant.CurrentCraftingWritSteps[CraftingWritAssistant.CurrentCraftingType] = nil
    CraftingWritAssistantWindow:SetHidden(true) 	
end

function CraftingWritAssistant.CraftingCompleted(eventCode, craftSkill)	
	if CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtStation == true then
		CraftingWritAssistant.BindandShowData(craftSkill)
	end	
end

function CraftingWritAssistant.ShowPrimaryWindow()	
		
    if (CraftingWritAssistantWindow:IsHidden()) then 
		 BindActiveQuestingWritDropDown()
		 EnableWritNameDropdown(true)
		 CraftingWritAssistant.BindandShowData()
		
		 --CraftingWritAssistantWindow:SetHidden(false) 
	 else
		 CraftingWritAssistantWindow:SetHidden(true) 
	 end
end


function CraftingWritAssistant.CloseWindowIfNeeded()	
	if CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtBank == true then
		CraftingWritAssistantWindow:SetHidden(true) 	
		CraftingWritAssistant.ToggleSlotUpdateEvent(false) 	
	end	
	
	if CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtGuildBank == true then
		CraftingWritAssistantWindow:SetHidden(true) 	
		CraftingWritAssistant.ToggleSlotUpdateEvent(false) 	
	end	
end

function CraftingWritAssistant.DisplayWindowAtBank()	
	if CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtBank == true then
		if (CraftingWritAssistantWindow:IsHidden()) then 
			 CraftingWritAssistant.ToggleSlotUpdateEvent(true) 
			 BindActiveQuestingWritDropDown()
			 CraftingWritAssistant.BindandShowData()						
		 end
	end	
end

function CraftingWritAssistant.DisplayWindowAtGuildBank()	
	if CraftingWritAssistant.savedVariables.ShowCraftingWritWindowAtGuildBank == true then
		if (CraftingWritAssistantWindow:IsHidden()) then 
		     CraftingWritAssistant.ToggleSlotUpdateEvent(true) 
			 BindActiveQuestingWritDropDown()
			 CraftingWritAssistant.BindandShowData()						
		 end
	end	
end

function CraftingWritAssistant.InventorySlotUpdate(eventCode, bagId, slotId, isNewItem, itemSoundCategory, updateReason)
   --if updateReason == INVENTORY_UPDATE_REASON_DURABILITY_CHANGE then return end
   if updateReason ~= INVENTORY_UPDATE_REASON_DEFAULT then return end
 
   if bagId == BAG_BACKPACK then     
      local itemType = GetItemType(bagId, slotId)    
	  
	  --creating a table to look up to see if we need to refresh writ panel
	  local itemTypesToCheck = {ITEMTYPE_DRINK, ITEMTYPE_FOOD, ITEMTYPE_GLYPH_ARMOR, ITEMTYPE_GLYPH_JEWELRY, ITEMTYPE_GLYPH_WEAPON, ITEMTYPE_ENCHANTING_RUNE_ASPECT, 
	  ITEMTYPE_ENCHANTING_RUNE_ESSENCE, ITEMTYPE_ENCHANTING_RUNE_POTENCY, ITEMTYPE_ALCHEMY_BASE,ITEMTYPE_REAGENT }
	 	 	 
	 -- d("item update")
	 -- d(itemType)
	  	
		for key, value in pairs(itemTypesToCheck) do
			if value == itemType then 
				--d("Item Type watched Found")
				 BindActiveQuestingWritDropDown()
				 CraftingWritAssistant.BindandShowData()	
				 return			
			end				
		end	
end
end

function CraftingWritAssistant.ToggleSlotUpdateEvent(enabled) 
	
	if enabled == true then
		--d("Binding: enabled")
		EVENT_MANAGER:RegisterForEvent(CraftingWritAssistant.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, CraftingWritAssistant.InventorySlotUpdate)
	else
		--d("Binding: DISabled")
		EVENT_MANAGER:UnregisterForEvent(CraftingWritAssistant.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
	end
end


SLASH_COMMANDS["/cwa"] = CraftingWritAssistant.ShowPrimaryWindow
SLASH_COMMANDS["/writ"] = CraftingWritAssistant.ShowPrimaryWindow


EVENT_MANAGER:RegisterForEvent(CraftingWritAssistant.name, EVENT_OPEN_BANK, CraftingWritAssistant.DisplayWindowAtBank)

EVENT_MANAGER:RegisterForEvent(CraftingWritAssistant.name, EVENT_CLOSE_BANK, CraftingWritAssistant.CloseWindowIfNeeded)

EVENT_MANAGER:RegisterForEvent(CraftingWritAssistant.name, EVENT_OPEN_GUILD_BANK, CraftingWritAssistant.DisplayWindowAtGuildBank)

EVENT_MANAGER:RegisterForEvent(CraftingWritAssistant.name, EVENT_CLOSE_GUILD_BANK, CraftingWritAssistant.CloseWindowIfNeeded)

EVENT_MANAGER:RegisterForEvent(CraftingWritAssistant.name, EVENT_CRAFT_COMPLETED, CraftingWritAssistant.CraftingCompleted)

-- (integer eventCode, integer craftSkill, bool sameStation)
EVENT_MANAGER:RegisterForEvent(CraftingWritAssistant.name, EVENT_CRAFTING_STATION_INTERACT, CraftingWritAssistant.CraftingStationEnter)

-- (integer eventCode)
EVENT_MANAGER:RegisterForEvent(CraftingWritAssistant.name, EVENT_END_CRAFTING_STATION_INTERACT, CraftingWritAssistant.CraftingStationLeft)

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(CraftingWritAssistant.name, EVENT_ADD_ON_LOADED, CraftingWritAssistant.OnAddOnLoaded)
