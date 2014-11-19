local Class=require('Class')
local EnvObject=require('EnvObjects.EnvObject')
local Turret=require('EnvObjects.Turret')

local TurretLv2 = Class.create(Turret, MOAIProp.new)

TurretLv2.FIRE_COOLDOWN = 2.5
-- beefier
TurretLv2.HIT_POINTS = 1000
TurretLv2.FIRE_DAMAGE = 150

TurretLv2.tFrames = {
	{ nMin = 0-180, sSprite = 'turret_lv2_frames0005' },
	{ nMin = 45-90, sSprite = 'turret_lv2_frames0004' },
	{ nMin = 75-90, sSprite = 'turret_lv2_frames0003' },
	{ nMin = 105-90, sSprite = 'turret_lv2_frames0002' },
	{ nMin = 135-90, sSprite = 'turret_lv2_frames0001' },
	{ nMin = 270-90, sSprite = 'turret_lv2_frames0005' },
}

return TurretLv2
