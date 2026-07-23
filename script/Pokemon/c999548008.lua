--Machamp (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Machoke
    pokeutil.InitStage(c,id,999548034)
    --Strikes Back
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ADD_COUNTER+0x1300)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.sbcon)
	e1:SetOperation(s.sbop)
	c:RegisterEffect(e1)
	--Seismic Toss
	pokeutil.InitAtk(c,id,1,"FFFN",6)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"*",2)
end

function s.sbcon(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return c:GetCounter(0x1300)>re:GetLabel()
end
function s.sbop(e,tp,eg,ep,ev,re,r,rp)
    local g=pokeutil.GetLastDamageUser()
    if g then
        local tc=g
		Duel.Hint(HINT_CARD,0,e:GetHandler():GetCode())
            tc:AddCounter(0x1300,1)
    end
end