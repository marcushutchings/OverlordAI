WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * AI-Overlord: offset aibrain.lua' )

local lastCall = 0

WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * AI-Overlord: offset aibrain.lua' )

local utils = import("/mods/overlordai/lua/AI/Overlord/utils.lua")
local overlordBrain = import("/mods/overlordai/lua/AI/Overlord/OverlordBrain.lua")

local OverlordSavedAIBrainClass = AIBrain
AIBrain = Class(OverlordSavedAIBrainClass) {

    OnCreateAI = function(self, planName)
        local per = ScenarioInfo.ArmySetup[self.Name].AIPersonality

        if not string.find(per, 'overlord') then
            -- hand over to existing functions as this is not a overlord ai
            OverlordSavedAIBrainClass.OnCreateAI(self, planName)
            return
        end

        -- Flag this brain as a possible brain to have skirmish systems enabled on
        self.SkirmishSystems = true

        --self.CurrentPlan = self.AIPlansList[self:GetFactionIndex()][1]
        --self:ForkThread(self.InitialAIThread)

        self:CreateBrainShared(planName)
        self:InitializeEconomyState()
        self.IntelData = {
            ScoutCounter = 0,
        }

        -- Flag enemy starting locations with threat?
        if ScenarioInfo.type == 'skirmish' then
            --self:AddInitialEnemyThreatSorian(200, 0.005, 'Economy')
            self:AddInitialEnemyThreat(200, 0.005)
        end

        self.BrainType = 'AI'

        LOG('* AI-Overlord: OnCreateAI() found AI-Overlord  Name: ('..self.Name..') - personality: ('..per..') ')
        self.overlord = true
        --self:ForkThread(self.ParseIntelThreadSwarm)

        self.overlordObservationTickDelay = 1
        self.overlordActionTickDelay = 1

        --self.overloadAiBrain = ovrlrdBrain.OverlordAIBrain:new()
        simpleFunction()
    end,

    InitializeSkirmishSystems = function(self)
        local per = ScenarioInfo.ArmySetup[self.Name].AIPersonality

        if not string.find(per, 'overlord') then
            -- hand over to existing functions as this is not a overlord ai
            OverlordSavedAIBrainClass.InitializeSkirmishSystems(self)
            return
        end
    end,

    OverlordGetObservationTickDelay = function(self)
        return self.overlordObservationTickDelay
    end,
}

function simpleFunction ()
    LOG('* AI-Overlord: OnCreateAI() found AI-Overlord  Name: Simple Function')
    overlordBrain.simpleBrainFunction()
end