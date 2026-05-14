--Full Heal (Base Set)
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	--e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc1=Duel.GetMatchingGroup(pokeutil.filterEx,tp,LOCATION_MZONE,0,nil):GetFirst()
    if tc1:GetFlagEffect(pokeutil.SLEEP_FLAG)>0 or tc1:GetFlagEffect(pokeutil.PARALYZE_FLAG)>0 or tc1:GetFlagEffect(pokeutil.POISON_FLAG)>0 or tc1:GetFlagEffect(pokeutil.CONFUSION_FLAG)>0 then
        tc1:ResetFlagEffect(pokeutil.SLEEP_FLAG)
        tc1:ResetFlagEffect(pokeutil.PARALYZE_FLAG)
        tc1:ResetFlagEffect(pokeutil.POISON_FLAG)
        tc1:ResetFlagEffect(pokeutil.CONFUSION_FLAG)
    end
end