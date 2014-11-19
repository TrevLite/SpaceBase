local GameRules = require('GameRules');
local EnvObject = require('EnvObjects.EnvObject')

function GameRules.getCapacity ()
	local nCapacity = 0
	--local EnvObject = require('EnvObjects.EnvObject')
	local ObjectData = require('EnvObjects.EnvObjectData')
	local Character = require('CharacterConstants')

	for name,data in pairs(ObjectData.tObjects) do
		if data.oxygenLevel then
			nCapacity = nCapacity + EnvObject.getNumberOfOxygenObjects(name) * data.oxygenLevel * 10 / Character.OXYGEN_PER_SECOND
		end
	end
	return math.floor(nCapacity)
end


function EnvObject.getNumberOfOxygenObjects (sType)
	local tObjects,n = EnvObject.getObjectsOfType(sType,true)
	for _,obj in pairs(tObjects) do
		if not obj:_shouldGenerateOxygen() then
			n = n - 1
		end
	end
	return n
end