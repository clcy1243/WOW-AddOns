-- DO NOT EDIT THIS FILE, GENERATED BY LUAPB-SAVEAST
local _, ADDONSELF = ...

local t = {
-- Table: {1}
{
   ["types"]={2},
},
-- Table: {2}
{
   {3},
   {4},
   {5},
   {6},
   {7},
   ["Bind"]={6},
   ["Slot"]={4},
   ["Macro"]={5},
   ["Charactor"]={3},
   ["Key"]={7},
},
-- Table: {3}
{
   ["fields"]={8},
   ["name"]="Charactor",
   [".type"]="message",
},
-- Table: {4}
{
   ["fields"]={9},
   ["name"]="Slot",
   [".type"]="message",
   ["types"]={10},
},
-- Table: {5}
{
   ["fields"]={11},
   ["name"]="Macro",
   [".type"]="message",
},
-- Table: {6}
{
   ["fields"]={12},
   ["name"]="Bind",
   [".type"]="message",
},
-- Table: {7}
{
   ["fields"]={13},
   ["name"]="Key",
   [".type"]="message",
},
-- Table: {8}
{
   {14},
   {15},
   {16},
   {17},
   {18},
   {19},
   ["ver"]={18},
   ["bind"]={15},
   ["slot"]={14},
   ["macro"]={16},
   ["petslot"]={17},
   ["name"]={19},
},
-- Table: {9}
{
   {20},
   {21},
   {22},
   {23},
   ["id"]={20},
   ["type"]={21},
   ["index"]={22},
   ["strindex"]={23},
},
-- Table: {10}
{
   {24},
   ["SlotType"]={24},
},
-- Table: {11}
{
   {25},
   {26},
   {27},
   {28},
   ["id"]={27},
   ["icon"]={28},
   ["name"]={25},
   ["body"]={26},
},
-- Table: {12}
{
   {29},
   {30},
   {31},
   {32},
   ["command"]={32},
   ["key1"]={30},
   ["id"]={29},
   ["key2"]={31},
},
-- Table: {13}
{
   {33},
   {34},
   {35},
   ["mod"]={34},
   ["key"]={33},
   ["keycode"]={35},
},
-- Table: {14}
{
   ["ftype"]="Slot",
   ["name"]="slot",
   [".type"]="field",
   ["rule"]="repeated",
   ["tag"]=1,
},
-- Table: {15}
{
   ["ftype"]="Bind",
   ["name"]="bind",
   [".type"]="field",
   ["rule"]="repeated",
   ["tag"]=2,
},
-- Table: {16}
{
   ["ftype"]="Macro",
   ["name"]="macro",
   [".type"]="field",
   ["rule"]="repeated",
   ["tag"]=3,
},
-- Table: {17}
{
   ["ftype"]="Slot",
   ["name"]="petslot",
   [".type"]="field",
   ["rule"]="repeated",
   ["tag"]=4,
},
-- Table: {18}
{
   ["ftype"]="uint32",
   ["name"]="ver",
   [".type"]="field",
   ["rule"]="optional",
   ["tag"]=14,
},
-- Table: {19}
{
   ["ftype"]="string",
   ["name"]="name",
   [".type"]="field",
   ["rule"]="optional",
   ["tag"]=15,
},
-- Table: {20}
{
   ["ftype"]="uint32",
   ["name"]="id",
   [".type"]="field",
   ["rule"]="required",
   ["tag"]=1,
},
-- Table: {21}
{
   ["ftype"]="SlotType",
   ["name"]="type",
   [".type"]="field",
   ["rule"]="required",
   ["tag"]=2,
},
-- Table: {22}
{
   ["ftype"]="uint32",
   ["name"]="index",
   [".type"]="field",
   ["rule"]="required",
   ["tag"]=3,
},
-- Table: {23}
{
   ["ftype"]="string",
   ["name"]="strindex",
   [".type"]="field",
   ["rule"]="optional",
   ["tag"]=4,
},
-- Table: {24}
{
   [".type"]="enum",
   ["name"]="SlotType",
   ["values"]={36},
},
-- Table: {25}
{
   ["ftype"]="string",
   ["name"]="name",
   [".type"]="field",
   ["rule"]="required",
   ["tag"]=1,
},
-- Table: {26}
{
   ["ftype"]="string",
   ["name"]="body",
   [".type"]="field",
   ["rule"]="required",
   ["tag"]=2,
},
-- Table: {27}
{
   ["ftype"]="uint32",
   ["name"]="id",
   [".type"]="field",
   ["rule"]="required",
   ["tag"]=3,
},
-- Table: {28}
{
   ["ftype"]="string",
   ["name"]="icon",
   [".type"]="field",
   ["rule"]="required",
   ["tag"]=4,
},
-- Table: {29}
{
   ["ftype"]="uint32",
   ["name"]="id",
   [".type"]="field",
   ["rule"]="required",
   ["tag"]=1,
},
-- Table: {30}
{
   ["ftype"]="Key",
   ["name"]="key1",
   [".type"]="field",
   ["rule"]="optional",
   ["tag"]=2,
},
-- Table: {31}
{
   ["ftype"]="Key",
   ["name"]="key2",
   [".type"]="field",
   ["rule"]="optional",
   ["tag"]=3,
},
-- Table: {32}
{
   ["ftype"]="string",
   ["name"]="command",
   [".type"]="field",
   ["rule"]="optional",
   ["tag"]=15,
},
-- Table: {33}
{
   ["ftype"]="uint32",
   ["name"]="key",
   [".type"]="field",
   ["rule"]="required",
   ["tag"]=1,
},
-- Table: {34}
{
   ["ftype"]="uint32",
   ["name"]="mod",
   [".type"]="field",
   ["rule"]="required",
   ["tag"]=2,
},
-- Table: {35}
{
   ["ftype"]="string",
   ["name"]="keycode",
   [".type"]="field",
   ["rule"]="optional",
   ["tag"]=15,
},
-- Table: {36}
{
   "SPELL",
   "ITEM",
   "MACRO",
   "FLYOUT",
   "EMPTY",
   "EQUIPMENTSET",
   "SUMMONPET",
   "COMPANION",
   "SUMMONMOUNT",
   ["EMPTY"]=5,
   ["FLYOUT"]=4,
   ["SPELL"]=1,
   ["ITEM"]=2,
   ["SUMMONMOUNT"]=9,
   ["SUMMONPET"]=7,
   ["MACRO"]=3,
   ["COMPANION"]=8,
   ["EQUIPMENTSET"]=6,
},
}
   local function loadast()
      local tables = t
      for idx = 1,#tables do
         local tolinki = {}
         for i,v in pairs( tables[idx] ) do
            if type( v ) == "table" then
               tables[idx][i] = tables[v[1]]
            end
            if type( i ) == "table" and tables[i[1]] then
               table.insert( tolinki,{ i,tables[i[1]] } )
            end
         end
         -- link indices
         for _,v in ipairs( tolinki ) do
            tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
         end
      end
      return tables[1]
   end

ADDONSELF.ast = loadast()