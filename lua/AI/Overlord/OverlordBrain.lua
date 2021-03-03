local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')

-- x = x or v equiv to if not x then x = v end
-- x = (a and b) or c  eqiv. x = a ? b : c
-- numeric for loop condition stuff only gets called once

utils = import('utils.lua')

OverlordAIBrain = Class {

    AliveTicks = 0,
    availableOrderActions = 1,
    availableIntelActions = 1,
    refAiBrain = {},
    Trash = {},

    Facts =
        { Commanders = {}
        },

    RequestStateChangeTo = nil,
    CurrentOverlordState = nil,

    OverlordStates = {},

    DoAction = function(self, action)
    end,

    -- ChooseAction = function(self)
    --     local chosenAction
    --     return chosenAction
    -- end

    Initialize = function(self, aiBrain)
        LOG('* AI-Overlord: OverlordAIBrain() Initializing')
        self.Trash = TrashBag()
        self.refAiBrain = aiBrain
        self.CurrentOverlordState = 'Initialize'
        self.OverlordStates = self:InitializeOverlordStates()
        self.Facts.Commanders = self:InitializeCommandersIntel()
        self:ForkThread(self.Think)
    end,

    InitializeOverlordStates = function(self)
        return {
            Initialize = self.InitializeTick,
            Operate = self.OperateTick,
            Deactivate = self.DeactivateTick,
        }
    end,

    InitializeCommandersIntel = function(self)
        return utils.map(ScenarioInfo.ArmySetup, function(token, army) return {} end)
    end,

    InitializeTick = function(self)
        self:AddInitialEnemyThreat()
        self.RequestStateChangeTo = 'Operate'
    end,

    OperateTick = function(self)
        if IsGameOver() then
            self.RequestStateChangeTo = 'Deactivate'
        end
    end,

    DeactivateTick = function(self)
    end,

    AlwaysTick = function(self)
        self.AliveTicks = self.AliveTicks + 1

        if self.RequestStateChangeTo then
            self.CurrentOverlordState = self.RequestStateChangeTo
            self.RequestStateChangeTo = nil
        end
    end,

    Think = function(self)
        LOG('* AI-Overlord: Think() Started')
        while true do
            self:AlwaysTick()
            if self.OverlordStates[self.CurrentOverlordState] then
                self.OverlordStates[self.CurrentOverlordState](self)
            end
            WaitTicks(1)
        end
        LOG('* AI-Overlord: Think() Stopped')
    end,

    ForkThread = function(self, fn, ...)
        if fn then
            local thread = ForkThread(fn, self, unpack(arg))
            self.Trash:Add(thread)
            return thread
        else
            return nil
        end
    end,

    Destroy = function(self)
        LOG('* AI-Overlord: OnDestroy() called')
        self.aiBrain = nil
        if self.Trash then
            self.Trash:Destroy()
        end
    end,

    IsFactTrue = function(self, fact)
        return self:IsFactValid(fact) and fact.Value
    end,
    
    IsFactValid = function(self, fact)
        return fact and (self.AliveTicks < fact.ExpireAtTick)
    end,

    SetFact = function (self, name, data, expiresOnTick)
        self.Facts[name] = CreateNewFact(data, expiresOnTick)
    end,

    RunStateInitialize = function(self)
        -- TODO: Get the real commanders location at start
        self.Facts.EnemyCommanderLocation = CreateNewFact(true, self.AliveTicks + 3000)
    end,

    AddInitialEnemyThreat = function(self)
        local aiBrain = self.refAiBrain
        local myArmy = ScenarioInfo.ArmySetup[aiBrain.Name]

        if ScenarioInfo.Options.TeamSpawn == 'fixed' then
            --Spawn locations were fixed. We know exactly where our opponents are. 
            
            -- local CommanderLocations = utils.filter(ScenarioInfo.ArmySetup, function(token, army)
            --     local ArmyIsNotMine = (army.ArmyIndex ~= myArmy.ArmyIndex)
            --     local ArmyIsEnemyTeam = (army.Team ~= myArmy.Team)
            --     local ArmyIsEnemyToEveryone = (army.Team == 1) -- TODO: Check this is correct
            --     return ArmyIsNotMine and (ArmyIsEnemyTeam or ArmyIsEnemyToEveryone)
            -- end )
            utils.forEach(ScenarioInfo.ArmySetup, function(token, army)
                local startPos = ScenarioUtils.GetMarker(token).position
                self.Facts.Commanders[token].location = CreateNewFact(startPos, 3000)
            end)
        end
    end,

    --    LOG('* AI-Overlord: OverlordAIBrain:new() - new Brain Created.')
}

function CreateNewFact(value, expiresAtTick)
    newFact =
        { Value = value
        , ExpireAtTick = expiresAtTick
        }
    return newFact
end

function CreateOverlordAIBrain(aiBrain)
    local newBrain = OverlordAIBrain()
    newBrain:Initialize(aiBrain)
    return newBrain
end

-- OverlordState = {}

-- OverlordDifficultyChart =
--     { ['easy'] = { level = 'easy', orderInterval = 50, intelInterval = 50 }
--     , ['medium'] = { level = 'medium', orderInterval = 10, intelInterval = 10 }
--     , ['hard'] = { level = 'hard', orderInterval = 1, intelInterval = 1  }
-- }

-- OverlordCondition = {}

-- Objectives: decision to accomplish something
-- Conditions: criteria that must be met in order to consider objective ready to start
-- Failed condition checks will suggest possible objectives to meet condition

-- information timestamped
-- all information has expiry time

-- Strategies = {
--     T1Rush = {
--         OverlordStrategy =
--         { name = 'T1 Rush'
--         , objectives =
--             { { 'Eliminate Enemy Commander with T1 forces', 100 }
--             , { 'Eliminate Enemy Mexes', 90 }
--             }
--         }
--     },
-- }

-- TacticGroups = {
--     Buildings = {
--         Tactics = {
--         },
--     },
--     UnitProduction = {

--     },
--     Combat = {
--         Tactics = {
--             EliminateEnemyCommander = {
--                 preconditions = {},
--             }
--         },
--     },
-- }

-- Preconditions = {
--     EnemyCommanderLocationIsKnown = function(brain) return true end,
-- }



-- OverlordObjective =
--     { name = 'WinTheMatch'
--     }

-- OverlordObjective =
--     { name = 'AvoidLosingTheMatch'
--     }

-- OverlordObjective =
--     { name = 'EliminateEnemyCommander'
--     , triggerConditions =
--         { { conditionName = 'TargetEnemyCommanderLocationKnown', onFailureGoal = 'FindTargetPlayerCommanderLocation' }
--         , { conditionName = 'StrongEnoughToAttackEnemyCommander', onFailureGoal = 'BuildStrongerAttackForce' }
--         }
--     , actionsOnTrigger =
--         { { 'Focus fire on enemy commander' }
--         }
--     , completionConditions =
--         { { 'IsEnemyCommanderEliminated' }
--         }
--     , baseTacticStrength = 100
--     , tacticStrengthModifiers =
--         { { 'EnemyCommanderIsVulnerable', 3 }
--         }
--     }

-- -- ObjectivesByTags =
-- --     [
-- --         'NewT1LandFactory' => {}
-- --     ]

-- ObjectiveCondition =
--     { name = 'TargetEnemyCommanderLocationKnown'
--     , correctiveActionObjectives =
--         { 'FindTargetEnemyCommanderLocation' }
--     }

-- ObjectiveCondition =
--     { name = 'HasT1EnoughAirFactories'
--     }

-- ObjectiveCondition =
--     { name = 'HasT1EnoughLandFactories'
--     }

-- OverlordObjective =
--     { name = 'FindEnemyCommanderWithAirScout'
--     }

-- OverlordObjective =
--     { name = 'BuildT1AirFactory'
--     }

-- OverlordObjective =
--     { name = 'BuildT1LandFactory'
--     }

-- OverlordObjective =
--     { name = 'BuildT1Mex'
--     }

-- function TargetPlayerCommanderLocationKnown(aiBrain)
--     --aiBrain.enemyPlayer[aiBrain.targetPlayer].commander.location
--     return false, 'EnemyCommanderLocation'
-- end

-- function StrongEnoughToAttackEnemyCommander(aiBrain)
--     -- reason for failure
--     -- 1. Commander on own but not enough forces
--     -- 2. Commander in base bot not enough forces
--     -- 3. Commander support forces too strong
--     return false
-- end

-- FindTargetPlayerCommanderLocation
-- No scout units

-- Falling behind on eco


-- OverlordObjective
--     { name = 'Prevent own Commander from being Eliminiated'
--     , triggerConditions =
--         {
--         , { conditionName = 'TargetPlayerCommanderLocationKnown', onFailureGoal = 'FindPlayerCommanderLocation' }
--         }
--     , actionsOnTrigger =
--         { { 'MoveCommanderToSafeLocation' }
--         }
--     , completionConditions =
--         { { '' }
--         }
--     , baseTacticStrength = 100
--     , tacticStrengthModifiers =
--         { { 'OwnCommanderIsVulnerable', -3 }
--         }
--     }

-- OverlordObjective
--     { name = 'Eliminate Enemy Mexes'
--     , conditions =
--         { { 'Enemy Mex Count At Least', { 1 } }
--         }
--     , actionsOnTrigger =
--         { { '' }
--         }
--     , tacticStrengthModifiers =
--         { { 'EnemyCommanderIsVulnerable', 1 }
--         }
--     }

-- TargetPlayerCommanderLocationKnown
-- Checks last known enemy commander location
-- On failure - other suggested goal

-- FindPlayerCommanderLocation
-- Scout for enemy commander
-- Use air units if available and has air dominance
-- Use land scouts if 

-- Actions
-- build (unitToOrder, structureTobuild)
-- support unit (unitToOrder, unitToSupport)


-- Strategy
-- goal
-- Objectives

-- T1 Rush
-- Destroy Commander
-- Objectives
-- > Eliminate Commander
--   (requires strong T1 force)
-- > Destroy Mexes
-- > Assault Enemy Base
-- > Find More Mexes
--   > Caputure Mex Region
--   > Build Mexes
-- > Build 
-- > Build T1 Factory
--   > use Commander
-- > Build Mexes
