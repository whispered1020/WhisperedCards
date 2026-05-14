--Electrode (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Voltorb
    pokeutil.InitStage(c,id,999548067)
    --Buzzap (use EFFECT_ADD_CODE, not sure if the effect will last cuz the card will be sent to gy)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.bpcon)
	e1:SetOperation(s.bpop)
	c:RegisterEffect(e1)
	--Electric Shock
	pokeutil.InitAtk(c,id,1,"LLL",5,nil,nil,nil,s.esop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"*",2)
end
function s.bpcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetFlagEffect(pokeutil.CONFUSION_FLAG)>0 or c:GetFlagEffect(pokeutil.PARALYZE_FLAG)>0 or c:GetFlagEffect(pokeutil.SLEEP_FLAG)>0 then return end
    return true
end
function s.bpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        c:AddCounter(0x1300,100)
    end
end
function s.esop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.TossCoin(tp,1)==0 then
        if c and c:IsRelateToEffect(e) then
            c:AddCounter(0x1300,1)
        end
    end
end