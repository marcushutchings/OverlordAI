local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local OLBC = '/mods/overlordai/lua/editor/OverlordBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'OverlordEngineerFactoryConstruction',
    BuildersType = 'EngineerBuilder',

    Builder {
        BuilderName = 'Overlord CDR T1 Land Factory',
        PlatoonTemplate = 'CommanderBuilder',
        Priority = 900,
        BuilderConditions = {
            --{ SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            --{ UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { OLBC, 'OverlordCanThinkThisTick2', {} },
            --{ EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
            --{ UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory',
                },
            }
        }
    },
}