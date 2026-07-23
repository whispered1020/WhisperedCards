--Farfetch'd (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Leek Slap
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e2:SetCountLimit(1,id)
    e2:SetCondition(s.lscon)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.lsop)
	c:RegisterEffect(e2)
	--Pot Smash
	pokeutil.InitAtk(c,id,2,"NNN",3)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_THUNDER,"*",2,RACE_ROCK,"-",3)
end
function s.lscon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetTurnCount()==1 or c:GetSequence()<5 then
			return false
		end
		-- cannot attack if this card is asleep
		if c:GetFlagEffect(pokeutil.SLEEP_FLAG)>0 then return false end
		--cannot attack if this card is paralyzed
		if c:GetFlagEffect(pokeutil.PARALYZE_FLAG)>0 then return false end
		--cannot use the attack if the card is affected by amnesia
		if c:GetFlagEffect(pokeutil.AMNESIA_FLAG)>0 and c:GetFlagEffectLabel(pokeutil.AMNESIA_FLAG)==1 then return false end

    local group=c:GetOverlayGroup()
    if group then
        return group:IsExists(Card.IsSetCard,1,nil,0x700)
    end
end
function s.lsop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local tc=Duel.GetMatchingGroup(pokeutil.filterEx,tp,0,LOCATION_MZONE,nil):GetFirst()
    if tc then
        tc:AddCounter(0x1300,3)
        pokeutil.MarkLastDamageUser(c)
    end
    local eh=Effect.CreateEffect(c)
    eh:SetType(EFFECT_TYPE_SINGLE)
    eh:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    eh:SetDescription(aux.Stringid(id,3))
    eh:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(eh)
end