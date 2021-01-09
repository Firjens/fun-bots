class('BotSpawner')

local BotManager = require('botManager')
local Globals = require('globals')

local ringSpacing = 25
local ringNrOfBots = 0

function BotSpawner:__init()
    self._ringSpacing = 25
    self._ringNrOfBots = 0
    Events:Subscribe('Bot:RespawnBot', self, self._onRespawnBot)
end


function BotSpawner:_onRespawnBot(botname)
    
end

function BotSpawner:getBotTeam(player)
    local team = TeamId.Team1
    if Config.spawnInSameTeam then
        team = player.teamId
    else
        if player.teamId == TeamId.Team1 then
            team = TeamId.Team2
        end
    end
    return team
end

function BotSpawner:spawnBotRow(player, length, spacing)
    for i = 1, length do
        local name = BotManager:findNextBotName()
        if name ~= nil then
            local yaw = player.input.authoritativeAimingYaw
            local transform = getYawOffsetTransform(player.soldier.transform, yaw, i * spacing)
            local bot = BotManager:createBot(name, self:getBotTeam())
            bot:setVarsRow(player)
            self.spawnBot(bot, transform, true)
        end
    end
end

-- Tries to find first available kit
-- @param teamName string Values: 'US', 'RU'
-- @param kitName string Values: 'Assault', 'Engineer', 'Support', 'Recon'
function BotSpawner:_findKit(teamName, kitName)

    local gameModeKits = {
        '', -- Standard
        '_GM', --Gun Master on XP2 Maps
        '_GM_XP4', -- Gun Master on XP4 Maps
        '_XP4', -- Copy of Standard for XP4 Maps
        '_XP4_SCV' -- Scavenger on XP4 Maps
    }

    for kitType=1, #gameModeKits do
        local properKitName = string.lower(kitName)
        properKitName = properKitName:gsub("%a", string.upper, 1)

        local fullKitName = string.upper(teamName)..properKitName..gameModeKits[kitType]
        local kit = ResourceManager:SearchForDataContainer('Gameplay/Kits/'..fullKitName)
        if kit ~= nil then
            return kit
        end
    end

    return
end

function BotSpawner:_setAttachments(unlockWeapon, attachments)
    for _, attachment in pairs(attachments) do
        local unlockAsset = UnlockAsset(ResourceManager:SearchForDataContainer(attachment))
        unlockWeapon.unlockAssets:add(unlockAsset)
    end
end

function BotSpawner:getKitApperanceCustomization(team, kit, color)
    -- Create the loadouts
    local soldierKit = nil
    local appearance = nil
    local soldierCustomization = CustomizeSoldierData()

    local m1911 = ResourceManager:SearchForDataContainer('Weapons/M1911/U_M1911_Tactical')
    local knife = ResourceManager:SearchForDataContainer('Weapons/Knife/U_Knife')

	soldierCustomization.activeSlot = WeaponSlot.WeaponSlot_0
	soldierCustomization.removeAllExistingWeapons = true

    local primaryWeapon = UnlockWeaponAndSlot()
    primaryWeapon.slot = WeaponSlot.WeaponSlot_0

    local gadget01 = UnlockWeaponAndSlot()
    gadget01.slot = WeaponSlot.WeaponSlot_2

    local gadget02 = UnlockWeaponAndSlot()
    gadget02.slot = WeaponSlot.WeaponSlot_5

	local secondaryWeapon = UnlockWeaponAndSlot()
	secondaryWeapon.weapon = SoldierWeaponUnlockAsset(m1911)
    secondaryWeapon.slot = WeaponSlot.WeaponSlot_1

	local meleeWeapon = UnlockWeaponAndSlot()
	meleeWeapon.weapon = SoldierWeaponUnlockAsset(knife)
    meleeWeapon.slot = WeaponSlot.WeaponSlot_7

    if kit == 1 then --assault
        local m416 = ResourceManager:SearchForDataContainer('Weapons/M416/U_M416')
        local m416Attachments = { 'Weapons/M416/U_M416_Kobra', 'Weapons/M416/U_M416_Silencer' }
        primaryWeapon.weapon = SoldierWeaponUnlockAsset(m416)
        self._setAttachments(primaryWeapon, m416Attachments)
        gadget01.weapon = SoldierWeaponUnlockAsset(ResourceManager:SearchForDataContainer('Weapons/Gadgets/Medicbag/U_Medkit'))
        gadget02.weapon = SoldierWeaponUnlockAsset(ResourceManager:SearchForDataContainer('Weapons/Gadgets/Defibrillator/U_Defib'))
        
    elseif kit == 2 then --engineer
        local asval = ResourceManager:SearchForDataContainer('Weapons/ASVal/U_ASVal')
        local asvalAttachments = { 'Weapons/ASVal/U_ASVal_Kobra', 'Weapons/ASVal/U_ASVal_ExtendedMag' }
        primaryWeapon.weapon = SoldierWeaponUnlockAsset(asval)
        self._setAttachments(primaryWeapon, asvalAttachments)
        gadget01.weapon = SoldierWeaponUnlockAsset(ResourceManager:SearchForDataContainer('Weapons/Gadgets/Repairtool/U_Repairtool'))
        gadget02.weapon = SoldierWeaponUnlockAsset(ResourceManager:SearchForDataContainer('Weapons/SMAW/U_SMAW'))

    elseif kit == 3 then --support
        local m249 = ResourceManager:SearchForDataContainer('Weapons/M249/U_M249')
        local m249Attachments = { 'Weapons/M249/U_M249_Eotech', 'Weapons/M249/U_M249_Bipod' }
        primaryWeapon.weapon = SoldierWeaponUnlockAsset(m249)
        self._setAttachments(primaryWeapon, m249Attachments)
        gadget01.weapon = SoldierWeaponUnlockAsset(ResourceManager:SearchForDataContainer('Weapons/Gadgets/Ammobag/U_Ammobag'))
        gadget02.weapon = SoldierWeaponUnlockAsset(ResourceManager:SearchForDataContainer('Weapons/Gadgets/Claymore/U_Claymore'))
        
    else    --recon
        local l96 = ResourceManager:SearchForDataContainer('Weapons/XP1_L96/U_L96')
        local l96Attachments = { 'Weapons/XP1_L96/U_L96_Rifle_6xScope' }
        primaryWeapon.weapon = SoldierWeaponUnlockAsset(l96)
        self._setAttachments(primaryWeapon, l96Attachments)
        gadget01.weapon = SoldierWeaponUnlockAsset(ResourceManager:SearchForDataContainer('Weapons/Gadgets/RadioBeacon/U_RadioBeacon'))
        --no second gadget
    end


    if team == TeamId.Team1 then -- US
        if kit == 1 then --assault
            appearance = ResourceManager:SearchForDataContainer('Persistence/Unlocks/Soldiers/Visual/MP/Us/MP_US_Assault_Appearance_'..color)
            soldierKit = self._findKit('US', 'Assault')
        elseif kit == 2 then --engineer
            appearance = ResourceManager:SearchForDataContainer('Persistence/Unlocks/Soldiers/Visual/MP/Us/MP_US_Engi_Appearance_'..color)
            soldierKit = self._findKit('US', 'Engineer')
        elseif kit == 3 then --support
            appearance = ResourceManager:SearchForDataContainer('Persistence/Unlocks/Soldiers/Visual/MP/Us/MP_US_Support_Appearance_'..color)
            soldierKit = self._findKit('US', 'Support')
        else    --recon
            appearance = ResourceManager:SearchForDataContainer('Persistence/Unlocks/Soldiers/Visual/MP/Us/MP_US_Recon_Appearance_'..color)
            soldierKit = self._findKit('US', 'Recon')
        end
    else -- RU
        if kit == 1 then --assault
            appearance = ResourceManager:SearchForDataContainer('Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Assault_Appearance_'..color)
            soldierKit = self._findKit('RU', 'Assault')
        elseif kit == 2 then --engineer
            appearance = ResourceManager:SearchForDataContainer('Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Engi_Appearance_'..color)
            soldierKit = self._findKit('RU', 'Engineer')
        elseif kit == 3 then --support
            appearance = ResourceManager:SearchForDataContainer('Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Support_Appearance_'..color)
            soldierKit = self._findKit('RU', 'Support')
        else    --recon
            appearance = ResourceManager:SearchForDataContainer('Persistence/Unlocks/Soldiers/Visual/MP/RU/MP_RU_Recon_Appearance_'..color)
            soldierKit = self._findKit('RU', 'Recon')
        end
    end

    soldierCustomization.weapons:add(primaryWeapon)
    soldierCustomization.weapons:add(secondaryWeapon)
    soldierCustomization.weapons:add(gadget01)
    soldierCustomization.weapons:add(gadget02)
	soldierCustomization.weapons:add(meleeWeapon)

    return soldierKit, appearance, soldierCustomization
end

function BotSpawner:_modifyWeapon(soldier)
    soldier.weaponsComponent.currentWeapon.secondaryAmmo = 9999
    soldier.weaponsComponent.currentWeapon.weaponFiring.gunSway.minDispersionAngle = 0
    soldier.weaponsComponent.currentWeapon.weaponFiring.gunSway.dispersionAngle = 0
    soldier.weaponsComponent.currentWeapon.weaponFiring.gunSway.randomAngle = 0
    soldier.weaponsComponent.currentWeapon.weaponFiring.gunSway.randomRadius = 0
    soldier.weaponsComponent.currentWeapon.weaponFiring.gunSway.suppressionMinDispersionAngleFactor = 0
    soldier.weaponsComponent.currentWeapon.weaponFiring.gunSway.crossHairDispersionFactor = 0
    soldier.weaponsComponent.currentWeapon.weaponFiring.recoilAngleZ = 0
    soldier.weaponsComponent.currentWeapon.weaponFiring.recoilAngleY = 0
    soldier.weaponsComponent.currentWeapon.weaponFiring.recoilAngleX = 0
    soldier.weaponsComponent.currentWeapon.weaponFiring.recoilTimer = 0.0
    soldier.weaponsComponent.currentWeapon.weaponFiring.recoilFovAngle = 0
end

function BotSpawner:spawnBot(bot, trans, setKit)
    local botColor = Colors[Config.botColor]
    local kitNumber = Config.botKit

    if setKit or Config.botNewLoadoutOnSpawn then
        if Config.botColor == 0 then
            botColor = Colors[MathUtils:GetRandomInt(1, #Colors)]
        end
        if kitNumber == 0 then
            kitNumber = MathUtils:GetRandomInt(1, 4)
        end
        bot.color = botColor
        bot.kit = kitNumber
    else
        botColor = bot.color
        kitNumber = bot.kit
    end

    bot:setKitAndColor(kitNumber, botColor)
    bot:resetSpawnVars()

      -- create kit and appearance
    local soldierBlueprint = ResourceManager:SearchForDataContainer('Characters/Soldiers/MpSoldier')
    local soldierCustomization = nil
    local soldierKit = nil
    local appearance = nil
    soldierKit, soldierCustomization, appearance = self:getKitApperanceCustomization()
    
	-- Create the transform of where to spawn the bot at.
	local transform = LinearTransform()
    transform = trans

	-- And then spawn the bot. This will create and return a new SoldierEntity object.
    BotManager:spawnBot(bot, transform, CharacterPoseType.CharacterPoseType_Stand, soldierBlueprint, soldierKit, { appearance })
    bot.player.soldier:ApplyCustomization(soldierCustomization)
end





-- Singleton.
if g_BotSpawner == nil then
	g_BotSpawner = BotSpawner()
end

return g_BotSpawner