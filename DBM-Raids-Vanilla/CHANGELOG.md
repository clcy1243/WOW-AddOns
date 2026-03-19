# DBM - Vanilla and Season of Discovery

## [r818](https://github.com/DeadlyBossMods/DBM-Vanilla/tree/r818) (2026-03-15)
[Full Changelog](https://github.com/DeadlyBossMods/DBM-Vanilla/compare/r817...r818) [Previous Releases](https://github.com/DeadlyBossMods/DBM-Vanilla/releases)

- Prevent loading of options on 114 boss mods on retail (they'll still load and record stats). This is the number of dungeon, delve, and scenario bosses that blizzard doesn't support with boss mod api  
- more cleanup  
- Remove deprecated functions: (rangeframe, hud, arrow)  
    due to buggy diffs, some regressions may be possible since it's harder to verify nothing was accidentally removed  
- hide some more UI options from era  
- tweaks  
- hide sod options on non sod  
- strip redundant CI  
- modernize CI  
- Possibly fix chromaggus not updating spellicon correctly due to inability to match timer ID  
- toc cleanup  
- Fix invalid sound args found by improved LuaLs diagnostics  
- Update localization.ru.lua (#456)  
- Update localization.de.lua (#452)  
- Update localization.fr.lua (#454)  
- Update localization.kr.lua (#455)  
- Update localization.cn.lua (#448)  
- Update localization.br.lua (#447)  
- Update localization.mx.lua (#449)  
- Update localization.es.lua (#450)  
- Update Razorgore.lua (#461)  
- Update Nefarian.lua (#463)  
- Update Ragnaros.lua (#460)  
- Update localization.tw.lua (#457)  
- Update localization.en.lua (#458)  
- Update Patchwerk.lua (#453)  
- Update Razuvious.lua (#451)  
