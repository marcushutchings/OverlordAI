
-- x = x or v equiv to if not x then x = v end
-- x = (a and b) or c  eqiv. x = a ? b : c
-- numeric for loop condition stuff only gets called once

OverlordAIBrain = Class {

    availableOrderActions = 1,
    availableIntelActions = 1,

    -- DoAction = function(self, action)
    -- end

    -- ChooseAction = function(self)
    --     local chosenAction
    --     return chosenAction
    -- end


    --    LOG('* AI-Overlord: OverlordAIBrain:new() - new Brain Created.')
}

simpleBrainFunction = function()
    LOG('* AI-Overlord: OnCreateAI() found AI-Overlord  Name: Simple Brain Function')
end

-- OverlordState = {}

-- OverlordDifficultyChart =
--     { ['easy'] = { level = 'easy', orderInterval = 50, intelInterval = 50 }
--     , ['medium'] = { level = 'medium', orderInterval = 10, intelInterval = 10 }
--     , ['hard'] = { level = 'hard', orderInterval = 1, intelInterval = 1  }
-- }

-- OverlordCondition = {}

-- OverlordAction = {}

-- OverlordRuleSet =
--     { name = 'opening'
--     , Rule =
--         { name = ''
--         , conditions =
--             {
--             }
--         , actions =
--             {
--             }
--         }
--     }

-- Objectives: decision to accomplish something
-- Conditions: criteria that must be met in order to consider objective ready to start
-- Failed condition checks will suggest possible objectives to meet condition

-- information timestamped
-- all information has expiry time

-- OverlordStrategy =
--     { name = 'T1 Rush'
--     , objectives =
--         { { 'Eliminate Enemy Commander with T1 forces', 100 }
--         , { 'Eliminate Enemy Mexes', 90 }
--         }
--     }

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
