 -----------------------------------------------------------------------------------------------
-- Client Lua Script for Erns_Junk_Repair
-- Copyright (c) NCsoft. All rights reserved
-----------------------------------------------------------------------------------------------
--[[
	Ern's Junk Repair
	<Erns_Junk_Repair.lua>
	Original Creation Date:	3/21/2014
	Contact:  Ern.Warcraft@gmail.com
	
	Refer to LICENSE.txt for the Apache License, Version 2.0.
	
	Copyright 2012-2014 Aaron Sayles.  All rights reserved.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]
 
require "Window"
require "string"
require "math"
require "Sound"
require "Item"
require "Money"
require "GameLib"
 
-----------------------------------------------------------------------------------------------
-- Erns_Junk_Repair Module Definition
-----------------------------------------------------------------------------------------------
local Erns_Junk_Repair = {} 
 
-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------
function Erns_Junk_Repair:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self 

    return o
end

function Erns_Junk_Repair:Init()
    Apollo.RegisterAddon(self, false, "", {"Vendor"})
end
 

-----------------------------------------------------------------------------------------------
-- Erns_Junk_Repair OnLoad
-----------------------------------------------------------------------------------------------
function Erns_Junk_Repair:OnLoad()
    -- load our form file
	self.xmlDoc = XmlDoc.CreateFromFile("Erns_Junk_Repair.xml")
	self.xmlDoc:RegisterCallback("OnDocLoaded", self)
	print("Ern's Junk Repair Up and Running!")
end

-----------------------------------------------------------------------------------------------
-- Erns_Junk_Repair OnDocLoaded
-----------------------------------------------------------------------------------------------
function Erns_Junk_Repair:OnDocLoaded()
	if self.xmlDoc ~= nil and self.xmlDoc:IsLoaded() then
		-- Get reference to Carbine's Vendor addon
		self.mainVendor = Apollo.GetAddon("Vendor")
		
		-- if the xmlDoc is no longer needed, you should set it to nil
		self.xmlDoc = nil
		
		Apollo.RegisterEventHandler("InvokeVendorWindow", "VendorOpen", self)
	end
end

-----------------------------------------------------------------------------------------------
-- Erns_Junk_Repair Functions
-----------------------------------------------------------------------------------------------
function Erns_Junk_Repair:VendorOpen()

	RepairAllItemsVendor()	--Repair all items!

	local inventory = GameLib.GetPlayerUnit():GetInventoryItems()

	local iCount = 0

	for _, val in pairs(inventory) do
		if val.itemInBag:GetItemCategory() == 94 then	--Junk Items
			SellItemToVendorById(val.itemInBag:GetInventoryId(), val.itemInBag:GetStackCount())
			iCount = iCount + 1
		end
	end
	
	--Display message
	if iCount > 0 then
		self.mainVendor:ShowAlertMessageContainer("Ern's Junk Repair sold " .. iCount .. " junk items and repaired all items.", false)
	end

end

-----------------------------------------------------------------------------------------------
-- Erns_Junk_Repair Instance
-----------------------------------------------------------------------------------------------
local Erns_Junk_RepairInst = Erns_Junk_Repair:new()
Erns_Junk_RepairInst:Init()
