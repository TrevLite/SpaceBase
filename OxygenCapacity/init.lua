-- Oxygen Capacity Mod v1
-- Modified by Trev_lite
--
-- Mod loader based version so standard game files are not overwritten
--
--

local modname = "Oxygen Capacity"
local modversion = "v1"

--Add mod name to app version so shows on title and menu screens
local str = MOAIEnvironment.appVersion
local i = string.find(str, '\n')
--add newline if not found
if not i then str = str..'\n' end
--add spacer if previous mod name exists (based on chars existing after newline)
if i and string.len(string.sub(str, i+1)) > 0 then str = str..' - ' end
--add this mod's name
str = str..modname..' '..modversion
MOAIEnvironment.appVersion = str


--Private variable to enble additional debugging messages in "moai_log_Space.txt"
--located in the game's installation folder with space.exe
local bDebugFlag = false


--need to fix hint about 8minutes of oxygen in tank

local GameRules = require('GameRules');
local EnvObject = require('EnvObjects.EnvObject')
local CharacterConstants = require('CharacterConstants')

-------------------------------------------------------------------------------
-- GameRules.lua changes
-------------------------------------------------------------------------------
function GameRules.getCapacity ()
	local nCapacity = 0
	--local EnvObject = require('EnvObjects.EnvObject')
	local ObjectData = require('EnvObjects.EnvObjectData')

	for name,data in pairs(ObjectData.tObjects) do
		if data.oxygenLevel then
			nCapacity = nCapacity + EnvObject.getNumberOfOxygenObjects(name) * data.oxygenLevel * 10 / CharacterConstants.OXYGEN_PER_SECOND
		end
	end
	return math.floor(nCapacity)
end

-------------------------------------------------------------------------------
-- EnvObject.lua changes
-------------------------------------------------------------------------------
function EnvObject.getNumberOfOxygenObjects (sType)
	local tObjects,n = EnvObject.getObjectsOfType(sType,true)
	for _,obj in pairs(tObjects) do
		if not obj:_shouldGenerateOxygen() then
			n = n - 1
		end
	end
	return n
end


-------------------------------------------------------------------------------
-- CharacterConstants.lua changes
-------------------------------------------------------------------------------
CharacterConstants.SPACESUIT_MAX_OXYGEN = 10 * 60 * CharacterConstants.OXYGEN_PER_SECOND


print(">>>>"..modname..", "..modversion.." Loaded<<<<")
