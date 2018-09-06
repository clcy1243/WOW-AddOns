# [2.7.6](https://github.com/WeakAuras/WeakAuras2/tree/2.7.6) (2018-09-05)

[Full Changelog](https://github.com/WeakAuras/WeakAuras2/compare/2.7.5...2.7.6)

Benjamin Staneck (4):

- fix a typo
- fix extra space in error string
- replace GetHeight with GetStringHeight
- localize forbidden() print

Buds (4):

- update hunter spells
- merge with #666
- Templates: rename "Cooldowns" to "Abilities" & fixed warrior spellids
- Templates fixes > fix totem glow > typo in a description > new "overlayGlow" subType for spells with procs > added and fixed a few spells

Infus (10):

- Don't schedule a CooldownScan if the remaingtime can't decrease anymore
- Fix another regression in condition test functions
- Fix conditions ui
- Fix regression in condition checks
- Fix BuffTrigger conditions for Buffed/Debuffed
- Make conditionTests test functions
- Fix hybrid sort mode with cloning auras
- Tweak SetTextOnText to not set the text if the text is already set
- Add UnitOnTaxi to vehicel load option
- Conditions: Change what we do for hidden auras

emptyrivers (1):

- cleanup trigger data (#666)

