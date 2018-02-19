local L = AleaUI_GUI.GetTranslate("FeralDotDamage", "enUS", true)
if not L then return end

L["Подсвечивать иконку при проке"] = 'Glow icon on '

L["Тип отображения силы дот"] = 'DoT power indicators type'
L['Индикаторы'] = 'Indicators'

L['Показывать иконку у миникарты'] = 'Show minimap icon'

L['Отключить смену иконок'] = 'Disable icon swap'
L['Отключить смену иконок для '] = 'Disable icon swap for '

L["Показать частично в специализации стража"] = 'Show some while in guardian specialization'
L["Показать полосу ресурса для специализации стража"] = 'Show power bar while in guardian specialization'

L["Полоса здоровья"] = 'Health bar'
L['Цвет полосы'] = 'Bar color'
L['artRegenDesc'] = GetSpellDescription(210583)
L['artRegen'] = "\124T"..(select(3, GetSpellInfo(210583)))..":14\124t "..( GetSpellInfo(210583) )

L["Учитывать очки серии для "] = 'Based on combo points for '
L['Будущее значение'] = 'Next value'
L['Текущее значение'] = 'Current value'
L['Слева'] = 'Left'
L['Справа'] = "Right"
L["Показывать основную цель"] = 'Show main target'
L["Смещение"] = 'Offset'
L["Отступ панели"] = 'Bar spacing'
L["Вертикально"] = 'Vertical'
L["Расположение"] = 'Position'
L["Окно проверки"] = 'Check frame'
L["Горизонтально"] = 'Horizontal'

L["Показать панель для других специализаций с талантом "] = 'Show panels for another specializations with talent '
L["Показать c "] = 'Show with '

L["Показать в форме кота"] = 'Show while in cat form'
L["Показать только в форме кота"] = 'Show only while in cat form'

L["Звуковое уведомление"] = 'Notification sound'
L['Размер настоя, руны и еды'] = 'Flash, rune and food icon size'
L['Размер рейдовых баффов'] = 'Raid buffs icon size'
L['Еда'] = 'Food'
L['Рейдовые баффы'] = 'Raid buffs'
L['Отсуствуют'] = 'Missing'
L['Отутствует'] = 'Missing'
L['Скоро закончится!'] = 'Ending soon!!'
L['Проверка баффов'] = 'Buff check'
L['использует кольцо нанесения урона'] = 'use damage ring'
L['использует кольцо исцеления'] = 'use healing ring'
L["Проверять настой"] = 'Check flask'
L["Проверять руну"] = 'Check rune'
L["Проверять еду"] = 'Check food'
L["Проверять рейдовые баффы"] = 'Check raid buffs'
L["Проверка положительных баффов"] = 'Check buffs'
L["Событие для проверки"] = 'Event for check'
L['Если выбрано "'] = 'If selected'
L['Проверка готовности или бой начат'] = 'Ready check or combat start'
L['" или "'] = '" or "'
L['Проверка готовности или бой c боссом начат'] = 'Ready check or boss combat start'
L['" то игрок получит только одно уведомление в течениe 20 секунд.'] = ' player only get one notification per 20 seconds.'
L['Проверка готовности'] = 'Ready check'
L['Бой начат'] = 'Combat start'
L['Бой с боссом начат'] = 'Boss combat start'


L[' для побочных целей, полос энергии и маны'] = ' for offtargets, energy and mana bars'

L["Ширина панели"] = 'Panel width'
L["При изменении количества иконок, их размер будет рассчитывается из значения ширины панели."] = 'On icon amount changes, their size will be calculated from panel width'
L['Пандемия - порог в 30% от базовой длительности ауры. При обновлении ауры, оставшаяся длительность, в пределах Пандемии, приплюсуется к новой ауре.'] = 'Pandemic - threshold for 30% of base aura duration. Allows to add any remaining effects to the same refreshed effect, with a maximum of 30% of the base duration'

L["Анонс легендарного кольца нанесения урона"] = 'Inform about damage legendary ring use'
L["Анонс легендарного кольца исцеления"] = 'Inform about healing legendary ring use'

L["Максимальный размер"] = 'Maximum size'
L['Размер иконки не будет превышать максимального размера'] = 'Icon size cant not be more then "Maximum size"'
L["Игнорировать "] = "Ignore "
L[' при расчете размера иконок'] = ' on icon size calculation'

L["ID Заклинания"] = "Spell ID"
L["Введите номер нужного заклинания"] = ""
L["Выбрать заклинание"] = "Select spell"
L["Двигать"] = "Move"
L["Вид отображения"] = "Style"
L["Иконка"] = "Icon"
L["Проверять ID"] = "Check ID"
L['Показывать ауру только с соответствующим "ID Заклинания"'] = "Show icon only for spell with same spellID"

L["Скрытый КД"] = "Internal CD"
L["Укажите скрытую перезарядку ауры."] = "Set internal cooldown value"
L["Показывать скрытую перезаряюку"] = "Show internal cooldown"

L["ShowGlow"] = "Show glow"
L["ShowGlowDesc"] = "Show glow if aura is active."
L["CP_Pandemia_anim"] = "Pandemia glow animation."
L["CP_Pandemia_animDesc"] = "Enable pandemia glow animation."
L["CP_Pandemia"] = "Pandemia."
L["CP_PandemiaDesc"] = "Show border if aura duration lower then pandemia threshold"
L["Ауры"] = "Auras"
L["Звук"] = 'Sound'
L["Проигрывать звук если не попали способностью"] = 'Play sound on spell missings'
L["Файл"] = 'File'

L["predatorIconRed"] = "Change color"
L["predatorIconRedDesc"] = "Change color to red if aura duration lower then 2 seconds."

L["провалено"] = "failed"

L["Максимальный размер"] = "Maximum size"
L["Размер иконки не будет превышать максимального значения при изменении колличества иконок"] = "Icon size can not be more then maximum size value on icon number change"

L["Автоинвайт"] = "Autoinvite"
L["Приглашать только членов гильдии"] = "Invite only guild members"

L["Если заклинание на перезарядке и аура отсутствует"] = "If spell is not ready or aura is missing"
L["Прозрачность"] = "Transparent"
L['Передвинуть фон'] = "Unlock background"

L["Таймер"] = "Timer"
L["Смещение по горизонтали"] = "Horizontal spacing"
L["Смещение по вертикали"] = "Vertical spacing"
L["Стаки"] = "Stacks"

L["Показать отсутствующие ауры"] = "Show missing auras"
L["Только для полос"] = "Only for bar type"
L["Затемнение"] = "Blackout"
L["Показать искру"] = "Show spark"
L["Сообщать всегда"] = "Always report"
L["Даже если заклинание не сбито"] = "Even if spell is not interrupted"

L["Укажите цель шепона"] = "Set whisper target"
L["Tags Desc"] = "Tags: \n\n%spell - spell Link \n%extraspell - kicked spell Link \n%target - spell target name \n%source - spell source name \n\n"
L["Тип"] = "Type"
L["Полоски"] = "Bars"
L["Отступ иконки"] = "Icon spacing"
L["Текстуры полосы"] = "Bar texture"
L["Основная текстура"] = "Main texture"
L["Текстура фона"] = "Background texture"
L["Цвет полосы"] = "Bar colors"
L["statusbar_color1"] = "Бафф активен"
L["statusbar_color2"] = "Не готово"
L["statusbar_color3"] = "Заклинание готово"
L["statusbar_color4"] = "Бафф отсутствует"

L["Свечение"] = "Glow"
L["Черно-белая"] = "Black-and-White"
L["Анонсы"] = "Anonce"
L["Чат"] = "Chat"
L["Авто"] = "Auto"
L["Группа"] = "Party"
L["Рейд"] = "Raid"
L["Шепот"] = "Whisper"
L["Крик"] = "Yell"
L["Сказать"] = "Say"
L["Цель"] = "Target"
L["Текст"] = "Text"
L["Включить"] = "Enable"
L["Отступ по вертикали"] = "Vertical spacing"
L["Точка привязки"] = "Anchor point"
L["Показать текст таймера"] = "Show timer text"
L["Размер шрифта таймера"] = "Timer font size"
L["Размер шрифта стаков"] = "Stack font size"
L["Выравнивание текста стаков"] = "Stack font justify"
L["Заклинания"] = "Spells"
L["Передвинь меня!"] = "Move me!"
L["Пороги заклинаний"] = "Spells thresholds"
L["Формат времени"] = "Time format"
L["Скрывать имена"] = "Hide names"
L["Отступ элементов"] = "Elements spacing"
L["Показать только в бою"] = "Show only in combat"
L["Показать если есть цель"] = "Show only if target exists"
L["Показать значение баффов"] = "Show buffs value"
L["Включено"] = "Enabled"
L["Показывать"] = "Show"
L["Позиция"] = "Order"
L["Цвет текста цели"] = "Target font color"
L["Размер шрифта иконок"] = "Icon font size"
L["Отступ иконок"] = "Icon space"
L["Скрывать отсутствующие ауры"] = "Hide missing auras"
L["Сияние \""] = "Shine \""
L["Анимация пандемии"] = "Pandemia animation"
L["Полоса энергии"] = "Energy Bar"
L["Стиль"] = "Style"
L["Прозрачность неактивной иконки"] = "Transparent non-active icon"
L["Цвет ярости"] = "Rage color"
L["Основное"] = "General"
L["Граница иконок"] = "Icon border"
L["Рост вверх"] = "Grow Up"
L["Цвет фона"] = "Background color"
L["Тень текста Y"] = "Text Shadow Y"
L["Выравнивание текста"] = "Text Justify"
L["Блокировать"] = "Lock"
L["Текст силы"] = "Power text"
L["Показать текст"] = "Show text"
L["По центру справа"] = "Center and right"
L["Полоса маны"] = "Mana Bar"
L["Цвет энергии"] = "Energy Color"
L["X pos"] = true
L["Y pos"] = true
L["Менять цвет полосы"] = "Change bar color"
L["цвет \"Схожий\""] = "color \"Same\""
L["Фон"] = "Background"
L["Очки серии"] = "Combo Points"
L["Сортировка"] = "Sorting"
L["Слева внизу"] = "Left and Bottom"
L["Отступ текста текущего значения"] = "Current power text gap"
L["Размер шрифта"] = "Font Size"
L["Текст таймера"] = "Timer text"
L["Сверху"] = "Top"
L["Обратить цвет текста"] = "Revert text coloring"
L["Показать текущее значение"] = "Show current values"
L["Обводка шрифта"] = "Font flags"
L["Центр"] = "Center"
L["Цвет маны"] = "Mana color"
L["Черно-белая иконка"] = "Black & white icon"
L["Увеличение"] = "Scale"
L["Справа вверху"] = "Right and Top"
L["Отступ панели по горизонтали"] = "Horizontal panel gap"
L["Цвета"] = "Colors"
L["Тень текста X"] = "Text Shadow X"
L["Цвет текста от значения"] = "Color text by value"
L["Разное"] = "Others"
L["Выравнивание текста таймера"] = "Timer text justify"
L["Отступ иконок по горизонтали"] = "Horizontal icon gap"
L["Побочные цели"] = "Offtargets"
L["Размер иконок"] = "Icon size"
L["Отступ панели по вертикали"] = "Horizontal panel gap"
L["Отступ"] = "Gap"
L["Цвет тика"] = "Tick color"
L["Анимация сияния"] = "Shine animation"
L["Цвет"] = "Color"
L["Цвет инонок от значения"] = "Icon color by value"
L["Высота Тиков"] = "Tick Height"
L["Слева вверху"] = "Left and Top"
L["Показать"] = "Show"
L["Граница"] = "Border"
L["Отступ текст будущего значения"] = "Future power text gap"
L["Показывать КП на иконках"] = "Show Combo point on icons"
L["Отступ фона"] = "Background gap"
L["Высота"] = "Height"
L["Отступ границ"] = "Border gap"
L["Тики"] = "Ticks"
L["Set Border Size"] = true
L["Пороговое значение"] = "Threshold"
L["Показывать тики"] = "Show ticks"
L["Полоса"] = "Bar"
L["Граница тиков"] = "Ticks border"
L["Цвет текста"] = "Text color"
L["Текстура"] = "Texture"
L["цвет \"Хуже\""] = "color \"Worse\""
L["Справа внизу"] = "Right and Bottom"
L["цвет \"Лучше\""] = "color \"Better\""
L["Иконки"] = "Icons"
L["Отступ тиков по вертикали"] = "Vertical icon gap"
L["Размер"] = "Size"
L["Шрифт"] = "Font"
L["(двигать тут)"] = "(move here)"
L["Показывать оверлей"] = "Show overlay"
L["Снизу"] = "Bottom"
L["По центру слева"] = "Center and Left"
L["Относительные значения"] = "Relative values"
L["Перезарядки"] = "Cooldowns"
L["цвет КП"] = "CP color"
L["Ширина"] = "Width"
L["Отступ Фона"] = "Background gap"
L["Пандемия"] = "Pandemic"
