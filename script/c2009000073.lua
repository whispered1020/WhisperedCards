-- Imprisoned Archfiend Takesha
-- Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
    --send to gy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,id)
	e3:SetCondition(s.bcon)
	e3:SetTarget(s.btg)
	e3:SetOperation(s.bop)
	c:RegisterEffect(e3)
end

function s.thfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToHand() and c:IsDefenseBelow(2000) and not c:IsAttribute(ATTRIBUTE_DARK)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
        --Cannot Special Summon from the Extra Deck, except LIGHT and/or Fiend Monsters
	    local e1=Effect.CreateEffect(c)
	    e1:SetDescription(aux.Stringid(id,1))
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	    e1:SetTargetRange(1,0)
	    e1:SetTarget(function(_,c) return c:IsLocation(LOCATION_EXTRA) and not (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_FIEND)) end)
	    e1:SetReset(RESET_PHASE|PHASE_END)
	    Duel.RegisterEffect(e1,tp)
	end
end
--Banish 1 "Imprisoned Archfiend" monster from deck, then you can add it to your hand or Special Summon it with its effects negated
function s.bcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and c:GetReasonCard():IsRace(RACE_FIEND) and c:GetReasonCard():IsAttribute(ATTRIBUTE_LIGHT) and (r==REASON_SYNCHRO or r==REASON_LINK)
end
function s.bfilter(c)
    return c:IsSetCard(0x2045) and c:IsMonster() and c:IsAbleToRemoveAsCost()
end
function s.btg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.bfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.bop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.bfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_COST)>0 then
        local tc=g:GetFirst()
        if tc:IsLocation(LOCATION_REMOVED) then
            if tc:IsType(TYPE_RITUAL) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,4))
            if opt==0 then
                Duel.SendtoHand(tc,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,tc)
            else
            end
            else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND+HINTMSG_SPSUMMON)
            local opt=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3),aux.Stringid(id,4))
            if opt==0 then
                Duel.SendtoHand(tc,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,tc)
            else if opt==1 then
                if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
                Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
                --Negate its effects
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_DISABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e1)
                local e2=Effect.CreateEffect(e:GetHandler())
                e2:SetType(EFFECT_TYPE_SINGLE)
                e2:SetCode(EFFECT_DISABLE_EFFECT)
                e2:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e2)
                Duel.SpecialSummonComplete()
            else
            end
            end
        end
    end
    end
end
