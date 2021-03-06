local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')

-- x = x or v equiv to if not x then x = v end
-- x = (a and b) or c  eqiv. x = a ? b : c
-- numeric for loop condition stuff only gets called once

utils = import('utils.lua')

OverlordAIBrain = Class {

    availableOrderActions = 1,
    availableIntelActions = 1,
    refAiBrain = {},
    Trash = {},

    Facts =
        { Commanders = {}
        , Armies = {}
        },

    RequestStateChangeTo = nil,
    CurrentOverlordState = nil,

    CurrentAction = nil,

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
        LOG('* AI-Overlord: ThinkInitializeTick()')
        self:GetInitialCommanderStartPositions(self.Facts.Commanders)
        self.RequestStateChangeTo = 'Operate'
        FindListOfPossibleBuildUnits(self.refAiBrain)
        MakeResouceStrategicPoints()
    end,

    OperateTick = function(self)
        if IsGameOver() then
            self.RequestStateChangeTo = 'Deactivate'
        end
    end,

    DeactivateTick = function(self)
    end,

    AlwaysTick = function(self)
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

    GetInitialCommanderStartPositions = function(self, commanders)
        --local aiBrain = self.refAiBrain
        --local myArmy = ScenarioInfo.ArmySetup[aiBrain.Name]

        if ScenarioInfo.Options.TeamSpawn == 'fixed' then
            --Spawn locations were fixed. We know exactly where our opponents are. 
            
            -- local CommanderLocations = utils.filter(ScenarioInfo.ArmySetup, function(token, army)
            --     local ArmyIsNotMine = (army.ArmyIndex ~= myArmy.ArmyIndex)
            --     local ArmyIsEnemyTeam = (army.Team ~= myArmy.Team)
            --     local ArmyIsEnemyToEveryone = (army.Team == 1) -- TODO: Check this is correct
            --     return ArmyIsNotMine and (ArmyIsEnemyTeam or ArmyIsEnemyToEveryone)
            -- end )
            --utils.forEach(ScenarioInfo.ArmySetup, function(token, army)
            commanders:ForEach(function(token, commander)
                local startPos = ScenarioUtils.GetMarker(token).position
                commander.Location = CreateNewFact(startPos, GetGameTick() + 3000)
                --self.Facts.Commanders[token].location = CreateNewFact(startPos, 3000)
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

function BuildT1Factory()
end

function ChooseStructureLocation()
end

function ChooseUnitToBuildStructure(brain)
    -- ? ACU or engineer
    -- ? build an engineer or send one over
    -- ? build factory, then build engineer
    -- if no engineers
    -- if only ACU
    -- if no factories
    local availableBuilders = FindListOfPossibleBuildUnits(brain)
                                :Filter( function(k, v) return UnitCanBuildStructure(brain, v) end )
                                :Map( function(k, v) return {unit = v, score = SuitabilityOfUnitBuildingStructure(brain, v)} end );

    return next(availableBuilders)
end

function UnitCanBuildStructure(brain, unit, structure)
    return true
end

function FindListOfPossibleBuildUnits(brain, structureToBuild, locationToBuild)
    -- LOG('* AI-Overlord unit list: ' .. v.UnitId)
    return utils.map(brain:GetListOfUnits(categories.ENGINEER, false), function(k, v) return v end )
end

function FindListOfPossibleBuildSites(structureToBuild)
end

function SuitabilityOfStructureBeingBuiltAtLocation(structureToBuild, locationToBuild)
end

function SuitabilityOfUnitBuildingStructure(structureToBuild, locationToBuild, unitToCheck)
    return 1
end

function SuitabilityOfFactoryBuildingAnEngineer(structureToBuild, locationToBuild, unitToCheck)
end

BuildingAT1Factory =
    { Preconditons =
        { 'HasChosenStructureLocation'
        , 'HasSelectedUnitToBuildStructure'
        }
    , Activate = BuildT1Factory
    }

HasChosenStructureLocation =
    { Activate = ChooseStructureLocation
    }

HasSelectedUnitToBuildStructure =
    { Activate = ChooseUnitToBuildStructure
    }
    -- local nearbyByResources = table.getn(baseResource.Nearby) 
    -- if nearbyByResources == 1 then
    -- elseif nearbyByResources == 1 then
function MakeResouceStrategicPoints()
    local resourceProximityChart = GetResourceIndexAndProximityGraph(GetResources())

    -- TODO: what about strange shapes, like long lines of Mex Points?
    -- TODO: what about items near, but on vastly different heights?
    -- TODO: what about items near, but cannot be reach from each other?

    -- build chains
    -- find centre point of chains
    -- possibleLocations = resourceProximityChart:map(function(baseKey, proxyEntry)
    --     return
    --         { Resource = proxyEntry.Resource
    --         , Points = table.getn()
    --         , RelativeLocation = proxyEntry.Nearby:reduce({0, 0, 0}, function(k, rv, v)
    --             return
    --                 { rv[1] + v.RelativePosition[1]
    --                 , rv[2] + v.RelativePosition[2]
    --                 , rv[3] + v.RelativePosition[3]
    --                 }
    --             end)
    --         }
    -- end)

    -- find possible locations that are too close to each other

    -- collapse locations down to the few that are needed.

end

function GetResources()
    -- v.type == "Mass" or "Hydrocarbon?"
    -- v.position[1]-x,[2]-y,[3]-z
    -- v.size
    LOG('* AI-Overlord: Master table length: '..table.getn(Scenario.MasterChain._MASTERCHAIN_.Markers))

    -- utils.map(ScenarioUtils.GetMarkers(), function(k,v) return v end):ForEach(
    --     function(k,v)
    --         utils.forEach(v,
    --             function(k, v)
    --                 --if (type(v) ~= "table") then
    --                     LOG('* AI-Overlord: Checking Resource Attribute: '..k..' value:'..tostring(v))
    --                 --end
    --             end
    --         )
    --     end
    -- )

    return utils.filter(ScenarioUtils.GetMarkers(), function (k, v) return v.resource end)
end

function GetResourceIndexAndProximityGraph(resources)
    local distanceThreshold = 25*25

    resources:ForEach(function(k,v) LOG('* AI-Overlord: Resource: '..k ..' value type: '..v.type..
                                        ' at ('..v.position[1]..','..v.position[2]..','..v.position[3]..')') end)

    -- resources:map(function(baseKey, baseResource)
    --     return { Resource = baseResource
    --            , Nearby = resources:map(function(k, v) return GetRelativePosition(baseResource, v) end)
    --                                :filter(function (k, v) return (v.distanceSqr <= distanceThreshold) end) } -- or (v.distanceSqr == 0)
    --     end)
end

function GetRelativePosition(base, target)
    local lat = target.position[1] - base.position[1]
    local alt = target.position[2] - base.position[2]
    local long = target.position[3] - base.position[3]
    local distanceSqr = lat*lat + long*long
    return { Resource = target, RelativePosition = {lat, alt, long}, DistanceSpr = distanceSqr }
end

--#region


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
