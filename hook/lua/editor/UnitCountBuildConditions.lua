-- Overlord AI extensions

WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * AI-Overlord: offset UCBC.lua' )

function OverlordCanThinkThisTick(aiBrain)
    --LOG(string.format('Debug: Overlord Tick Value is: %d', aiBrain:OverlordGetObservationTickDelay()))
    return true
end
