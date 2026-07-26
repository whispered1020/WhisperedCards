--PlusPower (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	pokeutil.toolAttach(c,nil,nil,nil,nil)
end
