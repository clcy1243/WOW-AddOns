local _, Sequences = ...
------------------
----- Warlock
------------------

Sequences['HP_EX_Aff_ST_Haste'] = {
  Author="Exlynn@Perenolde with help from Belthozar@Pozzo dell’Eternità",
  SpecID=265,
  Talents = "3,2,?,1,?,1,3",
  Helplink = "https://wowlazymacros.com/forums/topic/affliction-conduit-7-1-5/",
  Help = [[Single Target - Run at 80ms, 100ms, or manually - Requires 20% haste or higher]],
  Default=1,
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/targetenemy [noharm][dead]",
        "/use [mod:alt] Drain Soul",
        "/castsequence  reset=target  Corruption, Agony, Siphon Life, null",
      },
      PreMacro={
      },
        "/castsequence [nochanneling] Agony, Siphon Life, Drain Soul, Life Tap, Agony",
        "/cast [nochanneling] Unstable Affliction",
        "/castsequence [nochanneling] Unstable Affliction, Drain Soul, Drain Soul, Reap Souls",
      PostMacro={
      },
      KeyRelease={
        "/petautocastoff [group] Seethe",
        "/petautocastoff [group] Burning Presence",
        "/petautocaston [nogroup] Seethe",
        "/petautocaston [nogroup] Burning Presence",
      },
    },
  },
}

Sequences['HP_EX_Aff_ST'] = {
  Author="Exlynn@Perenolde with help from Belthozar@Pozzo dell’Eternità",
  SpecID=265,
  Talents = "3,2,?,1,?,1,3",
  Helplink = "https://wowlazymacros.com/forums/topic/affliction-conduit-7-1-5/",
  Help = [[Single Target - Run at 80ms, 100ms, or manually - Use if less than 20% haste]],
  Default=1,
  MacroVersions = {
    [1] = {
      StepFunction = "Sequential",
      KeyPress={
        "/targetenemy [noharm][dead]",
        "/use [mod:alt] Drain Soul",
        "/castsequence  reset=target  Corruption, Agony, Siphon Life, null",
      },
      PreMacro={
      },
        "/castsequence [nochanneling] Agony, Siphon Life, Drain Soul, Life Tap, Agony",
        "/cast [nochanneling] Unstable Affliction",
        "/castsequence [nochanneling] Unstable Affliction, Drain Soul, Reap Souls",
      PostMacro={
      },
      KeyRelease={
        "/petautocastoff [group] Seethe",
        "/petautocastoff [group] Burning Presence",
        "/petautocaston [nogroup] Seethe",
        "/petautocaston [nogroup] Burning Presence",
      },
    },
  },
}

Sequences['HP_EX_Aff_AoE'] = {
  Author="Exlynn@Perenolde",
  SpecID=265,
  Talents = "3,1,?,1,?,1,3",
  Helplink = "https://wowlazymacros.com/forums/topic/affliction-conduit-7-1-5/",
  Help = "AoE - Run at 80ms or manually",
  Default=1,
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
        "/targetenemy [noharm][dead]",
        "/use [mod:alt] Drain Soul",
        "/castsequence  reset=target  Agony, Corruption, Siphon Life, null",
      },
      PreMacro={
      },
        "/castsequence Seed of Corruption, Seed of Corruption, Seed of Corruption, Agony, Life Tap",
        "/cast Reap Souls",
      PostMacro={
      },
      KeyRelease={
        "/petautocastoff [group] Seethe",
        "/petautocastoff [group] Burning Presence",
        "/petautocaston [nogroup] Seethe",
        "/petautocaston [nogroup] Burning Presence",
      },
    },
  },
}


Sequences['HP_EX_Demo_ST'] = {
  Author="Exlynn@Perenolde",
  SpecID=266,
  Talents = "3,1,?,1,?,2,2",
  Helplink = "https://wowlazymacros.com/forums/topic/demonology-synergy/",
  Help = "Single Target - Run at 80ms or manually",
  Default=1,
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
        "/targetenemy [noharm][dead]",
        "/use [mod:alt] Drain Life",
        "/castsequence  reset=target  Doom, null",
      },
      PreMacro={
      },
        "/castsequence [nochanneling] Demonbolt, Call Dreadstalkers, Demonic Empowerment, Life Tap",
        "/castsequence [nochanneling] Demonbolt, Hand of Gul'dan, Demonic Empowerment",
        "/castsequence [nochanneling] Summon Doomguard, Demonic Empowerment",
        "/castsequence [nochanneling] Demonbolt, Hand of Gul'dan, Call Dreadstalkers, Thal'kiel's Consumption",
        "/castsequence [nochanneling] Demonbolt, Demonbolt, Grimoire: Felguard, Demonic Empowerment",
        "/cast [nochanneling] Command Demon",
        "/cast [nochanneling] Demonbolt",
      PostMacro={
      },
      KeyRelease={
        "/petautocastoff [group] Threatening Presence",
        "/petautocaston [nogroup] Threatening Presence",
      },
    },
  },
}


Sequences['HP_EX_Demo_AoE'] = {
  Author="Exlynn@Perenolde",
  SpecID=266,
  Talents = "3,1,?,1,?,2,2",
  Helplink = "https://wowlazymacros.com/forums/topic/demonology-synergy/",
  Help = "AoE - Run at 80ms",
  Default=1,
  Icon='INV_MISC_QUESTIONMARK',
  MacroVersions = {
    [1] = {
      StepFunction = [[Sequential]],
      KeyPress={
        "/targetenemy [noharm][dead]",
        "/use [mod:alt] Drain Life",
        "/castsequence  reset=target  Doom, null",
      },
      PreMacro={
      },
        "/castsequence [nochanneling] Demonwrath, Hand of Gul'dan, Demonic Empowerment, Demonwrath, Demonwrath, Life Tap",
        "/cast [nochanneling] Grimoire: Felguard",
        "/cast [nochanneling] Command Demon",
      PostMacro={
      },
      KeyRelease={
        "/petautocastoff [group] Threatening Presence",
        "/petautocaston [nogroup] Threatening Presence",
      },
    },
  },
}
