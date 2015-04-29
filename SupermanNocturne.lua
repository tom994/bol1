local version = "1.0"
local author = "Tom94"
 
 
function Update1()
local version = "1.0"
local author = "Tom94"
 
 
 
local autoupdateenabled = true
local UPDATE_SCRIPT_NAME = "SupermanNocturne"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Tom994/bol1/master/SupermanNocturne.lua"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
 
local ServerData
if autoupdateenabled then
        GetAsyncWebResult(UPDATE_HOST, UPDATE_PATH, function(d) ServerData = d end)
        function update()
                if ServerData ~= nil then
                        local ServerVersion
                        local send, tmp, sstart = nil, string.find(ServerData, "local version = \"")
                        if sstart then
                                send, tmp = string.find(ServerData, "\"", sstart+1)
                        end
                        if send then
                                ServerVersion = tonumber(string.sub(ServerData, sstart+1, send-1))
                        end
 
                        if ServerVersion ~= nil and tonumber(ServerVersion) ~= nil and tonumber(ServerVersion) > tonumber(version) then
                                DownloadFile(UPDATE_URL.."?nocache"..myHero.charName..os.clock(), UPDATE_FILE_PATH, function () print("<font color=\"#6699FF\"><b>"..UPDATE_SCRIPT_NAME..":</b> successfully updated. Reload (double F9) Please. ("..version.." => "..ServerVersion..")</font>") end)    
                        elseif ServerVersion then
                                print("<font color=\"#6699FF\"><b>"..UPDATE_SCRIPT_NAME..":</b> You have got the latest version: <u><b>"..ServerVersion.."</b></u></font>")
                        end            
                        ServerData = nil
                end
        end
        AddTickCallback(update)
end
end
 
 
 
 
if myHero.charName ~= "Nocturne" then return end
 
 
 
if VIP_USER then
    print("<font color='#FF000'> Cool you are VIP =)")
else
    print("<font color='FF0000'> Hey VIP is really a good thing :P")
end
 
 
require "SxOrbWalk"
require "VPrediction"
 
 
 
local ts
ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 3500, DAMAGE_PHYSICAL)
--- if you want to use the ultimate ability manuel change the range into like 700-1000 max. for better spellcasting
--- it will not ult people if they away then 1000 range maybe just in ks mode :|
--- ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 850/1000--------
local VP
 
 
local Qrange, Qwidth, Qspeed, Qdelay = 1125, 60, 1600, .5
local Erange = 500
local Ewidth = nil 
local Espeed = nil 
local Edelay = 0.5
local Qready, Wready, Eready, Rready = false

local ignite = nil
local rrange = 3500

 
 
 
 
function OnLoad()
        VP = VPrediction()
        Summoners()
        Update1()
        Config = scriptConfig("Superman Nocturne", "Superman Nocturne")
        Config:addSubMenu("Keys", "keys")
        Config.keys:addParam("Combo", "combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        Config.keys:addParam("Laneclear", "laneclear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("V"))
        Config.keys:addParam("Jungleclear", "jungleclear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("N"))
        Config.keys:addParam("Herass", "Herass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("C"))
 
 
 
        -----Combo-----------------
        Config:addSubMenu("Combo", "Combo")
        Config.Combo:addParam("Useq", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("Usew", "Use W in Combo (better do it manuel)", SCRIPT_PARAM_ONOFF, false)
        Config.Combo:addParam("Usee", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("User", "Use R in Combo [K ONOFF]", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte ("K"))
        Config.Combo:permaShow("User")
 
 
 
       
        -----Herass-----------
        Config:addSubMenu("Herass", "Herass")
        Config.Herass:addParam("Herass1", "Use Q in Herass", SCRIPT_PARAM_ONOFF, true)
        Config.Herass:addParam("Herass2", "Use E in Herass", SCRIPT_PARAM_ONOFF, true)
 
 
 
 
        --------jungleclear-----------
        Config:addSubMenu("Jungleclear", "Jungleclear")
        Config.Jungleclear:addParam("Jungq", "Use Q in Jungleclear", SCRIPT_PARAM_ONOFF, true)
        Config.Jungleclear:addParam("Junge", "Use E in Jungleclear", SCRIPT_PARAM_ONOFF, true)
 
 
 
 
        -------Laneclear--------
        Config:addSubMenu("Laneclear", "Laneclear")
        Config.Laneclear:addParam("laneq", "Use Q in Laneclear", SCRIPT_PARAM_ONOFF, true)
        Config.Laneclear:addParam("lanee", "Use E in Laneclear", SCRIPT_PARAM_ONOFF, false)
 
 
 
 
        Config:addSubMenu("KillSteal", "KillSteal")
        Config.KillSteal:addParam("Qsteal", "KillSteal with Q", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("Rsteal", "KillSteal with R", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("ignite", "KillSteal with Ignite", SCRIPT_PARAM_ONOFF, true)
 
 
 
        Config:addSubMenu("Use Items", "items")
        Config.items:addParam("item1", "use youmus", SCRIPT_PARAM_ONOFF, true)
        Config.items:addParam("useblade", "Use Botrk", SCRIPT_PARAM_ONOFF, true)
        Config.items:addParam("usehydra", "Use Hydra", SCRIPT_PARAM_ONOFF, true)




     -----------Extra Option-------------
 
 
        Config:addParam("info", "Version:", SCRIPT_PARAM_INFO, ""..version.."")
        Config:addParam("info2", "Author:", SCRIPT_PARAM_INFO, ""..author.."")
 
        print("<font color='#FF999'> [Superman Nocturne Loaded] <font color='#FF5555'> By Tom94")
 
 
 
 
        Config:addSubMenu("Drawings", "ddDraw")
        Config.ddDraw:addParam("drawq", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
        Config.ddDraw:addParam("drawe", "Draw E range", SCRIPT_PARAM_ONOFF, true)
        Config.ddDraw:addParam("drawr", "Draw R range", SCRIPT_PARAM_ONOFF, true)
 
 
 
 
        Config:addSubMenu("Orbwalker", "Orbwalker")
        SxOrb:LoadToMenu(Config.Orbwalker)
 
       Config:addSubMenu("AutoW","AutoW")
       Config.AutoW:addSubMenu("maybe somday^^", "tm")



 
        Config:addSubMenu("Target Selector", "TS")
				TargetSelector.name = "Nocturne"
        Config.TS:addTS(ts)
end

 
 
 
 
 
function Summoners()
        if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
                ignite = SUMMONER_1
                elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
                        ignite = SUMMONER_2
                end
 end
 
 
 
 
 
 
 
 function OnTick()
        ts:update()
        if Config.keys.Combo and Config.Combo.User then
                Ulti()
                                end
                                Ignite()
                                if Config.keys.Combo and Config.items.item1 then
                                youmus()
                                end
        if Config.keys.Herass then
            herass()
        end
         blade1()
         blade2()
         hydra()
         Comboo()
                 hydra2()
        GetRRange()
                Checks()
                if Config.keys.Herass and Config.Herass.Herass2 then
                herass2()
                end
                if Config.keys.Combo and Config.Combo.Usee then
                    ExtraE()
                end
                if Config.KillSteal.Qsteal then
                    KillstealgG() end
                    if Config.KillSteal.Rsteal then
                        KillstealgG()
                    end
end


function Checks()
QREADY = (myHero:CanUseSpell(_Q) == READY)
WREADY = (myHero:CanUseSpell(_W) == READY)
EREADY = (myHero:CanUseSpell(_E) == READY)
RREADY = (myHero:CanUseSpell(_R) == READY)
end
 
 
 
 
function GetRRange()
        if myHero:GetSpellData(_R).level == 1 then
                return 2000
                elseif myHero:GetSpellData(_R).level == 2 then
                        return 2750
                        elseif myHero:GetSpellData(_R).level == 3 then
                                return 3500
                        end
end
 
 
 
function hydra()
    if Config.keys.Combo and Config.items.usehydra then
        if ValidTarget(ts.target, 400) then
            if (GetInventorySlotItem(3077) ~= nil) then
                if (myHero:CanUseSpell(GetInventorySlotItem(3077)) == READY) then
                    CastSpell(GetInventorySlotItem(3077))
                end
                                                        end
                                                end
                                        end
end
 
 
 
 function hydra2()
 if Config.keys.Combo and Config.items.usehydra then
 if ValidTarget(ts.target, 400) then
 if (GetInventorySlotItem(3074) ~= nil) then
 if (myHero:CanUseSpell(GetInventorySlotItem(3074)) == READY) then
CastSpell(GetInventorySlotItem(3074))
 end
 end
 end
 end
 end
 
 

 
function Ulti()
  local RRange = GetRRange()
  if myHero:CanUseSpell(_R) == READY and GetDistance(ts.target) <= RRange then
    CastSpell(_R, ts.target)
    CastSpell(_R, ts.target)
  end
end
 
 
 
 
 

function Ignite()
local iDmg = (50 + (20 * myHero.level))
        for i, enemy in ipairs(GetEnemyHeroes()) do
                if GetDistance(enemy, myHero) < 600 and ValidTarget(enemy, 600) and Config.KillSteal.ignite then
                        if myHero:CanUseSpell(ignite) == READY then
                                if enemy.health < iDmg then
                                        CastSpell(ignite, enemy)
                                                                                end
            end
    end
end
end
 
 
 
 
 
function youmus()
        if ValidTarget(ts.target) and not (ts.target.dead) and (ts.target.visible) then
        if Config.keys.Combo and Config.items.item1 then
            if myHero:GetDistance(ts.target) < 500 then
                if (GetInventorySlotItem(3142) ~= nil) then
                    if (myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY) then
                        CastSpell(GetInventorySlotItem(3142), ts.target)
                    end
                end
            end
        end
    end
end
 
 
 
 

function blade1()
        if Config.keys.Combo and Config.items.useblade  then
        if ValidTarget(ts.target, 500) then
            if (GetInventorySlotItem(3144) ~= nil) then
                if (myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY) then
                    CastSpell(GetInventorySlotItem(3144), ts.target)
                end
            end
        end
    end
end
 
 
 
 
 
 

function blade2()
        if Config.keys.Combo and Config.items.useblade then
        if ValidTarget(ts.target, 500) then
            if (GetInventorySlotItem(3153) ~= nil) then
                if (myHero:CanUseSpell(GetInventorySlotItem(3153)) == READY) then
                    CastSpell(GetInventorySlotItem(3153), ts.target)
                end
            end
        end
    end
end
 
 
 
 
 
 

function OnDraw()
   local RRange = GetRRange()
    if Config.ddDraw.drawq and QREADY then
                        DrawCircle(myHero.x, myHero.y, myHero.z, 1200, 0xFF000)
                end
    if RREADY and Config.ddDraw.drawr then
      DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xFF000)
    end
        if Config.ddDraw.drawe and EREADY then
        DrawCircle(myHero.x, myHero.y, myHero.z, 425, 0xFF000)
        end
end
 
 
 

function herass()
    if Config.keys.Herass then
        if QREADY and ValidTarget(ts.target, Qrange) then
            if Config.Herass.Herass1 then
            local CastPosition, HitChance, Position = VP:GetLineCastPosition(ts.target, Qdelay, Qwidth, Qrange, Qspeed, myHero, false)
            if HitChance >= 2 then
                CastSpell(_Q, CastPosition.x, CastPosition.z)
            end
    end
    end
end
end





function herass2()
if ValidTarget(ts.target) then
if EREADY and GetDistance(ts.target) <= Erange then
CastSpell(_E, ts.target)
end
end
end






function Comboo()
    if Config.keys.Combo and Config.Combo.Useq then
        if QREADY and ValidTarget(ts.target, Qrange) then
        local CastPosition, HitChance, Position = VP:GetLineCastPosition(ts.target, Qdelay, Qwidth, Qrange, Qspeed, myHero, false)
        if HitChance >= 2 then
        CastSpell(_Q, CastPosition.x, CastPosition.z)
    end
    if Config.keys.Combo and Config.Combo.Usee then
        if ValidTarget(ts.target) then
            if EREADY and GetDistance(ts.target) <= Erange then
                CastSpell(_E, ts.target)
            end
            if Config.keys.Combo and Config.Combo.Usew then
                if ValidTarget(ts.target) then
                    if WREADY and GetDistance(ts.target) <= 500 then
                        CastSpell(_W)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
end





function ExtraE()
if ValidTarget(ts.target) then
if EREADY and GetDistance(ts.target) <= Erange then
CastSpell(_E, ts.target)
end
end
end






function KillstealgG()
        for i, enemy in pairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) and not enemy.dead then
            RDMG = getDmg("R", enemy, myHero)
            if enemy.health < RDMG then
                if GetDistance(enemy) <= rrange then
                    if Config.KillSteal.Rsteal then
                        CastSpell(_R, enemy)
                    end
                end
            end
        end
    end
end