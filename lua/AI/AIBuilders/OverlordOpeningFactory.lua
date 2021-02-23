local UCBC = '/lua/editor/UnitCountBuildConditions.lua'

BuilderGroup {
    BuilderGroupName = 'OverlordOpeningFactory',
    BuildersType = 'FactoryBuilder',

    Builder {
        BuilderName = 'Overlord T1 Engineer',
        PlatoonTemplate = 'T1BuildEngineer',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'EngineerLessAtLocation', { 'LocationType', 4, 'ENGINEER TECH1' }},
            --{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'FACTORY TECH3' }},
            --{ UCBC, 'HaveLessThanUnitsWithCategory', { 2, 'FACTORY TECH3' }},
            --{ UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 1, 'ENGINEER TECH1' } },
            --{ UCBC, 'EngineerCapCheck', { 'LocationType', 'Tech1' } },
        },
        BuilderType = 'All',
    }
}