-- MyMod v1
-- by Trev_lite
--
-- Mod loader based version so standard game files are not overwritten
--
--

local modname = "MyMod"
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



-------------------------------------------------------------------------------
-- GameRules.lua changes
-------------------------------------------------------------------------------
local GameRules = require('GameRules')


-------------------------------------------------------------------------------
-- Character.lua changes
-------------------------------------------------------------------------------
local Character = require('Character')
local Malady = require('Malady')

Character.isIncapacitated = function (self)
	return Malady.isIncapacitated(self)
end

Character._shouldAttackLethal = function (self, rTarget)
    local bLethal = true
        local bTargetIsCharacter = rTarget and ObjectList.getObjType(rTarget) == ObjectList.CHARACTER 
	    if self.tStats.nJob == Character.EMERGENCY then
            if g_ERBeacon.eViolence == g_ERBeacon.VIOLENCE_LETHAL or self:hasUtilityStatus(Character.STATUS_RAMPAGE_VIOLENT) then
                bLethal = true
            elseif g_ERBeacon.eViolence == g_ERBeacon.VIOLENCE_NONLETHAL then
                bLethal = false
            else
                bLethal = not rTarget or not bTargetIsCharacter or self:_hates(rTarget)
            end
			-- security use lethal force for those marked, ignoring beacon state
			if bTargetIsCharacter and rTarget.tStatus.bMarkedForExecution then
				bLethal = true
			end
			-- MDBALANCEMOD: ignore all other states if the target is a parasite
			if bTargetIsCharacter and rTarget.nRace == Character.RACE_MONSTER then
				bLethal = true
			end
            if bTargetIsCharacter and bLethal then
                -- security only try to incapacitate brawlers
                for otherTag,_ in pairs(rTarget.tStatus.tBrawlingWith) do
					local rOther = ObjectList.getObject(otherTag)
                    -- only if they're attacking a citizen
                    if rOther and not self:_hates(rOther) then
                        bLethal = false
                    end
                end
            end
        else
            -- brawlers never try to kill their opponent
            if bTargetIsCharacter and not self:_hates(rTarget) and self:isBrawling(rTarget) then
                bLethal = false
            end
        end
    return bLethal
end

Character.shouldTargetForAttack = function (self, rTarget)
    if rTarget == self or rTarget:isDead() or self.tStatus.bCuffed then return false end
    
    local nFactionBehavior = self:getFactionBehavior()
    if nFactionBehavior == Character.FACTION_BEHAVIOR.Citizen or nFactionBehavior == Character.FACTION_BEHAVIOR.Friendly then
        -- Friendly characters don't attack imprisoned or cuffed people.
        if rTarget.tStatus.bCuffed or rTarget:inPrison() then return false end
    else
        -- added this to stop prisoners from attacking friendlies
        if self:inPrison() then return false end
    end
	
	-- only security targets marked
	if self.tStats.nJob == Character.EMERGENCY and rTarget.tStatus.bMarkedForExecution then
		return true
	end
	-- marked citizens fight back once attacked
	if self.tStatus.bMarkedForExecution and rTarget.tStats.nJob == Character.EMERGENCY then
		if self:retrieveMemory(Character.MEMORY_TOOK_DAMAGE_RECENTLY) then
			return true
		end
	end
	
    if self:hasUtilityStatus(Character.STATUS_RAMPAGE_VIOLENT) then return true end
    
    local bIncapacitated = Malady.isIncapacitated(rTarget)

    local bHates = self:_hates(rTarget)
    if bHates then
        if nFactionBehavior ~= Character.FACTION_BEHAVIOR.Citizen and nFactionBehavior ~= Character.FACTION_BEHAVIOR.Friendly then
            return true
        end
        return not bIncapacitated or g_ERBeacon.eViolence == EmergencyBeacon.VIOLENCE_LETHAL
    end
    
    -- brawlers only try to incapacitate their opponent
    if self:isBrawling(rTarget) then
		-- stop brawling, don't kill em!
        if bIncapacitated or rTarget:isDead() then
			self:stopBrawling(rTarget)
            return false
        else
            return true
        end
        -- if we get incapacitated, stop brawling
        if Malady.isIncapacitated(self) then
			self:stopBrawling(rTarget)
            return false
        end
    end

    if rTarget:hasUtilityStatus(Character.STATUS_RAMPAGE) and rTarget.tStatus.bRampageObserved then 
        if bIncapacitated then 
            return g_ERBeacon.eViolence == EmergencyBeacon.VIOLENCE_LETHAL 
        end
        return true
    end

    if (rTarget:hasUtilityStatus(Character.STATUS_RAMPAGE) or rTarget.tStatus.tAssignedToBrig) and not bIncapacitated then
        if rTarget:getCurrentTaskTag('NonThreatening') then return false end
        -- Target should be in brig but isn't there, isn't cuffed, isn't incapacitated.
        -- They're probably doing survival-level stuff. But if we're beaconed onto them
        -- let's go ahead and beat them up.
        if g_ERBeacon.rTargetObject == rTarget and self:getJob() == Character.EMERGENCY then
            return true
        end
    end
        
    return false
end

-------------------------------------------------------------------------------
-- Turret.lua changes
-------------------------------------------------------------------------------
local Turret = require('EnvObjects.Turret')

Turret.isHostileTo = function (self, rChar)
    if rChar:isDead() then return false end
    -- MDBALANCEMOD: Added this If to stop turret from targeting incapacitated targets.
    if rChar:isIncapacitated() then return false end
    if not self:isFunctioning() then return false end
    if self:_fireOnEveryone() then return true end
    if Base.isFriendly(self,rChar) then return false end
    if rChar.tStatus.bCuffed then return false end
    if rChar:inPrison() then
        return false 
    end
    if self.bWasFriendly and Base.isFriendlyToPlayer(rChar) then return false end

    return true
end

-------------------------------------------------------------------------------
-- OptionData.lua changes
-------------------------------------------------------------------------------
local OptionData = require('Utility.OptionData')

OptionData.tAdvertisedActivities.DropOffCorpse.ScoreMods = {Priority = OptionData.tPriorities.SURVIVAL_NORMAL}


print(">>>>"..modname..", "..modversion.." Loaded<<<<")
