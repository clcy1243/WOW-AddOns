# BigWigs

## [v54](https://github.com/BigWigsMods/BigWigs/tree/v54) (2017-05-19) [](#top)
[Full Changelog](https://github.com/BigWigsMods/BigWigs/compare/v53...v54)

- bump version  
- Nighthold/Guldan: Fix warmup timer for Horde side.  
- Core/BossPrototype: Remove call to CombatLogClearEntries() when engaging a boss, which was added back in 2010 to fix a combat log bug. This causes a game crash when called from a CLEU event, and hopefully the original issue is resolved now.  
- Loader: Add Black Temple id  
