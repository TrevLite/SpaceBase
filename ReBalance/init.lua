-- ReBalance v1
-- by Trev_lite
--
-- Mod loader based version so standard game files are not overwritten
--
--

local modname = "ReBalance"
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

GameRules.STARTING_MATTER = 5000
GameRules.MAT_MINE_ROCK_MIN = 90
GameRules.MAT_MINE_ROCK_MAX = 150
GameRules.MAT_MINE_ROCK_MIN_LVL2 = 120
GameRules.MAT_MINE_ROCK_MAX_LVL2 = 180
GameRules.MAT_CORPSE_MIN = 150
GameRules.MAT_CORPSE_MAX = 200


-------------------------------------------------------------------------------
-- CharacterConstants.lua changes
-------------------------------------------------------------------------------
local CharacterConstants = require('CharacterConstants')

CharacterConstants.CHAT_COOLDOWN = 20
CharacterConstants.DUTY_AFFINITY_DISLIKE = -2.1
CharacterConstants.DUTY_AFFINITY_MORALE_MAX = 0.5
CharacterConstants.MORALE_NEEDS_LOW = -30
CharacterConstants.MORALE_NEEDS_DECREASE = -0.09
CharacterConstants.MORALE_NEEDS_HIGH = 25
CharacterConstants.MORALE_NEEDS_INCREASE = 0.11
CharacterConstants.MORALE_LOW_OXYGEN_THRESHOLD = 400
CharacterConstants.MORALE_NICE_CHAT = 0.2
CharacterConstants.MORALE_MET_NEW_CITIZEN = 6
CharacterConstants.MORALE_MINE_ASTEROID = 0.5
CharacterConstants.MORALE_MAINTAIN_OBJECT = 0.2
CharacterConstants.MORALE_MAINTAIN_PLANT = 0.2
CharacterConstants.MORALE_REPAIR_OBJECT = 0.2
CharacterConstants.MORALE_BUILD_BASE = 0.4
CharacterConstants.MORALE_DID_HOBBY = 1
CharacterConstants.MORALE_WOKE_UP_BED = 4
CharacterConstants.MORALE_DELIVERED_FOOD = 0.2
CharacterConstants.ANGER_EMBRIGGENED_UNJUST = 40
CharacterConstants.REPLICATOR_FOOD = 2
CharacterConstants.ANGER_REDUCTION_PER_MORALE_TICK = 1.1
CharacterConstants.SHIFT_COOLDOWN = 310
CharacterConstants.SLEEP_DURATION = 190


-------------------------------------------------------------------------------
-- EnvObject.lua changes
-------------------------------------------------------------------------------
local EnvObject = require('EnvObjects.EnvObject')

EnvObject.MIN_PCT_HEALED_PER_MAINTAIN = 5
EnvObject.MAX_PCT_HEALED_PER_MAINTAIN = 25


-------------------------------------------------------------------------------
-- Mine.lua changes
-------------------------------------------------------------------------------
local Mine = require('Utility.Tasks.Mine')

Mine.MINING_MIN_DURATION = 10
Mine.MINING_MAX_DURATION = 20


-------------------------------------------------------------------------------
-- ResearchInLab.lua changes
-------------------------------------------------------------------------------
local ResearchInLab = require('Utility.Tasks.ResearchInLab')

ResearchInLab.nSessionDuration = 10
ResearchInLab.nMinAmountPerResearch = 5
ResearchInLab.nMaxAmountPerResearch = 25


print(">>>>"..modname..", "..modversion.." Loaded<<<<")
