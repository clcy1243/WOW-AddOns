-- my custom locale file - more streamlined than AceLocale and no lib dependency

-- To help with missing translations please go here:
-- http://www.wowace.com/addons/skadascroll/localization/

local addonName, vars = ...
local Ld, La = {}, {}
local locale = GAME_LOCALE or GetLocale()

vars.L = setmetatable({},{
    __index = function(t, s) return La[s] or Ld[s] or rawget(t,s) or s end
})

Ld["Key scrolling speed"] = "Key scrolling speed"
Ld["Scroll"] = "Scroll"
Ld["Scroll icon"] = "Scroll icon"
Ld["Scrolling speed"] = "Scrolling speed"
Ld["Scroll mouse button"] = "Scroll mouse button"


if locale == "frFR" then do end
La["Key scrolling speed"] = "Touche de défilement rapide" -- Needs review
La["Scroll"] = "Faites défiler" -- Needs review
La["Scroll icon"] = "Faites défiler l'icône" -- Needs review
La["Scrolling speed"] = "Vitesse de défilement" -- Needs review
La["Scroll mouse button"] = "Bouton de la souris de défilement" -- Needs review

elseif locale == "deDE" then do end
-- La["Key scrolling speed"] = ""
-- La["Scroll"] = ""
La["Scroll icon"] = "Scrollsymbol" -- Needs review
La["Scrolling speed"] = "Scrollgeschwindigkeit" -- Needs review
-- La["Scroll mouse button"] = ""

elseif locale == "koKR" then do end
-- La["Key scrolling speed"] = ""
-- La["Scroll"] = ""
-- La["Scroll icon"] = ""
-- La["Scrolling speed"] = ""
-- La["Scroll mouse button"] = ""

elseif locale == "esMX" then do end
-- La["Key scrolling speed"] = ""
-- La["Scroll"] = ""
-- La["Scroll icon"] = ""
-- La["Scrolling speed"] = ""
-- La["Scroll mouse button"] = ""

elseif locale == "ruRU" then do end
-- La["Key scrolling speed"] = ""
-- La["Scroll"] = ""
-- La["Scroll icon"] = ""
-- La["Scrolling speed"] = ""
-- La["Scroll mouse button"] = ""

elseif locale == "zhCN" then do end
-- La["Key scrolling speed"] = ""
-- La["Scroll"] = ""
-- La["Scroll icon"] = ""
-- La["Scrolling speed"] = ""
-- La["Scroll mouse button"] = ""

elseif locale == "esES" then do end
La["Key scrolling speed"] = "Clave velocidad desplazamiento" -- Needs review
La["Scroll"] = "desplazamiento" -- Needs review
La["Scroll icon"] = "Icono de desplazamiento" -- Needs review
La["Scrolling speed"] = "Velocidad de desplazamiento" -- Needs review
La["Scroll mouse button"] = "Boton del raton de desplazamiento" -- Needs review

elseif locale == "zhTW" then do end
La["Key scrolling speed"] = "鍵盤的移動軸速度" -- Needs review
La["Scroll"] = "移動軸" -- Needs review
La["Scroll icon"] = "移動軸圖示" -- Needs review
La["Scrolling speed"] = "捲動速度" -- Needs review
La["Scroll mouse button"] = "移動軸滑鼠按鈕" -- Needs review

elseif locale == "ptBR" then do end
-- La["Key scrolling speed"] = ""
-- La["Scroll"] = ""
-- La["Scroll icon"] = ""
-- La["Scrolling speed"] = ""
-- La["Scroll mouse button"] = ""

elseif locale == "itIT" then do end
-- La["Key scrolling speed"] = ""
-- La["Scroll"] = ""
-- La["Scroll icon"] = ""
-- La["Scrolling speed"] = ""
-- La["Scroll mouse button"] = ""

end
