--PlusPower (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	pokeutil.toolAttach(c,nil,nil,s.tgop,nil)
end

--function to attach the tool only to the active pokemon, using function pokeutil.filterEx()
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.filter(c)
    return pokeutil.toolfilt(c) and pokeutil.filterEx(c)
end