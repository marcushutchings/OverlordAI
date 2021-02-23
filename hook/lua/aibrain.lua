WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * AI-Overlord: offset aibrain.lua' )

local lastCall = 0

OverlordSavedAIBrainClass = AIBrain
AIBrain = Class(OverlordSavedAIBrainClass) {

    OnCreateAI = function(self, planName)
        OverlordSavedAIBrainClass.OnCreateAI(self, planName)
        local per = ScenarioInfo.ArmySetup[self.Name].AIPersonality

        if string.find(per, 'overlord') then
            LOG('* AI-Overlord: OnCreateAI() found AI-Overlord  Name: ('..self.Name..') - personality: ('..per..') ')
            self.overlord = true
            --self:ForkThread(self.ParseIntelThreadSwarm)

            self.overlordObservationTickDelay = 1
            self.overlordActionTickDelay = 1
        end
    end,

    OverlordGetObservationTickDelay = function(self)
        return self.overlordObservationTickDelay
    end,
}