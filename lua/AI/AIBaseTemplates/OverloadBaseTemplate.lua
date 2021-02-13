BaseBuilderTemplate {
    BaseTemplateName = 'OverloadAITemplateBase',
    Builders = {},
    NonCheatBuilders = {},
    BaseSettings = {},
    ExpansionFunction = function(aiBrain, location, markerType)
        return 0
    end,
    FirstBaseFunction = function(aiBrain)
        local personality = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        if not personality then return 1 end
        if personality == 'overlordeasy' then
            return 150, 'overlordeasy'
        end
        return 1, 'overlordeasy'
    end,
}