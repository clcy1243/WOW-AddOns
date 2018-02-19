# Transcriptor

## [v7.3.3](https://github.com/BigWigsMods/Transcriptor/tree/v7.3.3) (2018-02-16)
[Full Changelog](https://github.com/BigWigsMods/Transcriptor/compare/v7.3.2...v7.3.3)

- Also show the time since the latest stage in our "TooManyStages" entries, not just the time since the ability happened last.  
- Stage entries in the TIMERS table will now show the time since the previous ability, or the time since the previous stage if the ability didn't trigger between those stages.  
- Update blacklist  
- Fix drycoded loops.  
- SpecialEvents: Re-enable Imonar and Kin'garoth stages.  
- Remove the hard cap on how many stages the timers table can handle, fixing an error when too many stages were used.  
- Remove some compat code  
- Add support for CombatLogGetCurrentEventInfo (WoW v8)  
- update travis file  
- Update blacklist  
- Update journal ID usage.  
- Fix attempting to access C\_DeathInfo on live.  
- Add logging for IsEncounterLimitingResurrections.  
