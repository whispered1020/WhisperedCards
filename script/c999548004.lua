--Charizard (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Charmeleon
    pokeutil.InitStage(c,id,999548024)
    --Energy Burn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.ebcon)
	e1:SetOperation(s.ebop)
	c:RegisterEffect(e1)
	--Fire Spin
	pokeutil.InitAtk(c,id,1,"RRRR",10,nil,s.fscost,nil,nil)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_AQUA,"*",2,RACE_ROCK,"-",3)
end
function s.ebcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetFlagEffect(pokeutil.CONFUSION_FLAG)>0 or c:GetFlagEffect(pokeutil.PARALYZE_FLAG)>0 or c:GetFlagEffect(pokeutil.SLEEP_FLAG)>0 then return end
    return true
end
function s.ebop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        --Energy Burn client hint
        local eh=Effect.CreateEffect(c)
		eh:SetType(EFFECT_TYPE_SINGLE)
		eh:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		eh:SetDescription(aux.Stringid(id,2))
        eh:SetReset(RESETS_STANDARD_PHASE_END,1)
        c:RegisterEffect(eh)
    --Fire Spin
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCondition(s.fscon)
	e2:SetCost(s.fscost)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.fsop)
    e2:SetReset(RESETS_STANDARD_PHASE_END,1)
	c:RegisterEffect(e2)
    end
end
function s.fscon(e,tp,eg,ep,ev,re,r,rp)
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
        return group:IsExists(Card.IsSetCard,4,nil,0x700)
    end
end
function s.fscost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetOverlayGroup():IsExists(Card.IsSetCard,2,nil,0x700) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=c:GetOverlayGroup():FilterSelect(tp,Card.IsSetCard,2,2,nil,0x700)
    Duel.SendtoGrave(g,REASON_COST)
end
function s.fsop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetMatchingGroup(pokeutil.filterEx,tp,0,LOCATION_MZONE,nil):GetFirst()
    if tc then
        tc:AddCounter(0x1300,10)
        pokeutil.MarkLastDamageUser(e:GetHandler())
    end
end