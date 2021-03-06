function Update1()
local version = "1.3"
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
                                DownloadFile(UPDATE_URL.."?nocache"..myHero.charName..os.clock(), UPDATE_FILE_PATH, function () print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> successfully updated. Reload (double F9) Please. ("..version.." => "..ServerVersion..")</font>") end)    
                        elseif ServerVersion then
                                print("<font color=\"#FFFF00\"><b>"..UPDATE_SCRIPT_NAME..":</b> You have got the latest version: <u><b>"..ServerVersion.."</b></u></font>")
                        end            
                        ServerData = nil
                end
        end
        AddTickCallback(update)
end
end

if myHero.charName ~= "Nocturne" then return end

require "SxOrbWalk"
require "VPrediction"
local ts
ts = TargetSelector(TARGET_MOST_AD, 3500, DAMAGE_PHYSICAL)
--- if you want to use the ultimate ability manuel change the range into like 700-1000 max. for better spellcasting
--- it will not ult people if they away then 1000 range maybe just in ks mode :|
--- ts = TargetSelector(TARGET_MOST_AD, 3500, DAMAGE_PHYSICAL), 850/1000--------
---- and also should set Use R /Rks  off
local VP
local Qrange, Qwidth, Qspeed, Qdelay = 1125, 60, 1600, .5
local Qrange, Qwidth, Qspeed, Qdelay = 1125, 60, 1600, .5
local Erange = 500
local version = "1.3"
local author = "Tom94"
local ignite = nil
local lSequence = {1,2,3,1,1,4,1,3,1,3,4,3,3,2,2,4,2,2}



function OnLoad()
        VP = VPrediction()
        Summoners()
        Update1()
        Config = scriptConfig("[Superman Nocturne]", "Superman Nocturne")
        Config:addSubMenu("[Superman Nocturne]: Keys", "keys")
        Config.keys:addParam("Combo", "combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
                                Config.keys:permaShow("Combo")
        Config.keys:addParam("Laneclear", "laneclear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("X"))
        Config.keys:addParam("Jungleclear", "jungleclear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("X"))
        Config.keys:addParam("Herass", "Herass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte ("C"))

        -----Combo-----------------
        Config:addSubMenu("[Superman Nocturne]: Combo", "Combo")
        Config.Combo:addParam("Useq", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("Usew", "Use W in Combo (better do it manually)", SCRIPT_PARAM_ONOFF, false)
        Config.Combo:addParam("Usee", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
        Config.Combo:addParam("User", "Use R in Combo [K ONOFF]", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte ("K"))
        Config.Combo:permaShow("User")
 
        -----Herass-----------
        Config:addSubMenu("[Superman Nocturne]: Herass", "Herass")
        Config.Herass:addParam("Herass1", "Use Q in Herass", SCRIPT_PARAM_ONOFF, true)
        Config.Herass:addParam("Herass2", "Use E in Herass", SCRIPT_PARAM_ONOFF, true)
 

        --------jungleclear-----------
        Config:addSubMenu("[Superman Nocturne]: Jungleclear", "Jungleclear")
        Config.Jungleclear:addParam("Jungq", "Use Q in Jungleclear", SCRIPT_PARAM_ONOFF, true)

        -------Laneclear--------
        Config:addSubMenu("[Superman Nocturne]: Laneclear", "Laneclear")
        Config.Laneclear:addParam("laneq", "Use Q in Laneclear", SCRIPT_PARAM_ONOFF, true)
                
                

        Config:addSubMenu("[Superman Nocturne]: KillSteal", "KillSteal")
        Config.KillSteal:addParam("Qsteal", "KillSteal with Q", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("Rsteal", "KillSteal with R", SCRIPT_PARAM_ONOFF, true)
        Config.KillSteal:addParam("ignite", "KillSteal with Ignite", SCRIPT_PARAM_ONOFF, true)
 
        Config:addSubMenu("[Superman Nocturne]: Use Items", "items")
        Config.items:addParam("useitem5", "Use Items", SCRIPT_PARAM_ONOFF, true)
        EnemyMinions = minionManager(MINION_ENEMY, Qrange, myHero, MINION_SORT_MAXHEALTH_DEC)
        jungleMinions = minionManager(MINION_JUNGLE, Qrange, myHero, MINION_SORT_MAXHEALTH_DEC)

        
 
 
        Config:addParam("info", "Version:", SCRIPT_PARAM_INFO, ""..version.."")
        Config:addParam("info2", "Author:", SCRIPT_PARAM_INFO, ""..author.."")
 
        print("<font color='#FF999'> [Superman Nocturne Loaded] <font color='#FF5555'> By Tom94")
 
        Config:addSubMenu("[Superman Nocturne]: Drawings", "ddDraw")
        Config.ddDraw:addParam("drawq", "Draw Q range", SCRIPT_PARAM_ONOFF, true)
        Config.ddDraw:addParam("drawe", "Draw E range", SCRIPT_PARAM_ONOFF, true)
        Config.ddDraw:addParam("drawr", "Draw R range", SCRIPT_PARAM_ONOFF, true)
        Config.ddDraw:addParam("drawaa", "Draw AA", SCRIPT_PARAM_ONOFF, false)
 
        Config:addSubMenu("[Superman Nocturne]: Orbwalker", "Orbwalker")
        SxOrb:LoadToMenu(Config.Orbwalker)
 
        Config:addSubMenu("[Superman Nocturne]: AutoW","AutoW")
        Config.AutoW:addParam("autoe", "Auto E on Target", SCRIPT_PARAM_ONOFF, true)
        Config.AutoW:addSubMenu("maybe somday", "tm")
             
        Config:addSubMenu("[Superman Nocturne]: Auto Level Skills", "autolevel")
        Config.autolevel:addParam("autolvl", "Auto Level Skills", SCRIPT_PARAM_ONOFF, false)

        Config:addSubMenu("[Superman Nocturne]: Selector", "TS")
        Config.TS:addParam("ff20", "Focus Selected target", SCRIPT_PARAM_ONOFF, false)
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
        Ulti() end
        Ignite()
        Comboo()
        GetRRange()
        if Config.keys.Herass then
        herass() end
        if Config.keys.Herass and Config.Herass.Herass2 then
        herass2() end   
        if Config.KillSteal.Qsteal then
        KillstealgG() end
        if Config.KillSteal.Rsteal  then
        KillstealgG() end                   
        if Config.autolevel.autolvl then
        autoLevelSetSequence(lSequence) end                                       
        if Config.keys.Jungleclear then
        jjungleclear() end
        EnemyMinions:update()
        jungleMinions:update()
        if Config.keys.Laneclear then
        llaneclear() end
        if Config.AutoW.autoe then
        autoe() end
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


function Ulti()
  local RRange = GetRRange()
  if (ts.target ~= nil) and myHero:CanUseSpell(_R) == READY then
  if ValidTarget(ts.target) and GetDistance(ts.target, myHero) <= RRange then
  CastSpell(_R, ts.target) end
  CastSpell(_R, ts.target) end
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


function OnDraw()
   local RRange = GetRRange()
    if Config.ddDraw.drawq and myHero:CanUseSpell(_Q) == READY then
        DrawCircle(myHero.x, myHero.y, myHero.z, 1200, 0xFF000)
        end
    if myHero:CanUseSpell(_R) == READY  and Config.ddDraw.drawr then
      DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xFF000)
    end
        if Config.ddDraw.drawe and myHero:CanUseSpell(_E) == READY then
        DrawCircle(myHero.x, myHero.y, myHero.z, 425, 0xFF000)
        end
        if Config.ddDraw.drawaa then
        DrawCircle(myHero.x, myHero.y, myHero.z, 126, 0xFF000)
        end
end


function herass()
        if (ts.target ~= nil) and myHero:CanUseSpell(_Q) == READY then
        if ValidTarget(ts.target, Qrange) and GetDistance(ts.target, myHero) <= Qrange and Config.keys.Herass and Config.Herass.Herass1 then
        local CastPosition, HitChance, Position = VP:GetLineCastPosition(ts.target, Qdelay, Qwidth, Qrange, Qspeed, myHero, false)
        if HitChance >= 2 then
        CastSpell(_Q, CastPosition.x, CastPosition.z)
end
end
end
end


function herass2()
    if (ts.target ~= nil) and myHero:CanUseSpell(_E) == READY then
    if ValidTarget(ts.target) and GetDistance(ts.target, myHero) <= Erange then
    CastSpell(_E, ts.target)
end
end
end


function Comboo()
    if (ts.target ~= nil) and myHero:CanUseSpell(_Q) == READY then
    if ValidTarget(ts.target, Qrange) and GetDistance(ts.target, myHero) <= Qrange and Config.keys.Combo and Config.Combo.Useq then
    local CastPosition, HitChance, Position = VP:GetLineCastPosition(ts.target, Qdelay, Qwidth, Qrange, Qspeed, myHero, false)
    if HitChance >= 2 then
    CastSpell(_Q, CastPosition.x, CastPosition.z)
    end
    if (ts.target ~= nil) and myHero:CanUseSpell(_E) == READY then
    if ValidTarget(ts.target, Erange) and GetDistance(ts.target, myHero) <= Erange and Config.keys.Combo and Config.Combo.Usee then
    CastSpell(_E, ts.target)
    end
    if (ts.target ~= nil) and myHero:CanUseSpell(_W) == READY then
    if ValidTarget(ts.target, 200) and Config.keys.Combo and Config.Combo.Usew then
    CastSpell(_W)
end
end
end
end
end
end


function KillstealgG()
for i, enemy in pairs(GetEnemyHeroes()) do
if ValidTarget(enemy) and not enemy.dead and myHero:CanUseSpell(_R) == READY  then
RDMG = getDmg("R", enemy, myHero)
if enemy.health < RDMG then
if GetDistance(enemy) <= GetRRange() then
if Config.KillSteal.Rsteal then
CastSpell(_R, enemy)
CastSpell(_R, enemy)
end
if ValidTarget(enemy) and not enemy.dead and myHero:CanUseSpell(_Q) == READY then
QDMG = getDmg("Q", enemy, myHero)
if enemy.health < QDMG then
if GetDistance(enemy) <= Qrange then
local CastPosition, HitChance, CastPosition = VP:GetLineCastPosition(ts.target, Qdelay, Qwidth, Qrange, Qspeed, myHero, false)
if HitChance >= 2 then
CastSpell(_Q, CastPosition.x, CastPosition.z)
end
end
end
end
end
end
end
end
end


function jjungleclear()
for i, jungleMinion in pairs(jungleMinions.objects) do
if jungleMinion ~= nil then
if GetDistance(jungleMinion) <= Qrange then
if myHero:CanUseSpell(_Q) == READY and Config.Jungleclear.Jungq then
CastSpell(_Q, jungleMinion.x, jungleMinion.z)
end
end
end
end
end


function llaneclear()
if jungleMinion == nil then
for i, minion in pairs(EnemyMinions.objects) do
if minion ~= nil then
if myHero:CanUseSpell(_Q) == READY and Config.Laneclear.laneq and GetDistance(minion) <= Qrange then
CastSpell(_Q, minion.x, minion.z)
end
end
end
end
end



function autoe()
if myHero:CanUseSpell(_E) == READY and ValidTarget(ts.target, Erange) then
CastSpell(_E, ts.target)
end
end
