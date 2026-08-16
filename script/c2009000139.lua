--The Aftershock of The Eonwheel
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--Return a Special Summoned monster to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rthtg)
	e1:SetOperation(s.rthop)
	c:RegisterEffect(e1)
	--Activate this card from the hand if it was Set and returned
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,{id,1},EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(s.actcon)
	e2:SetOperation(s.actop)
	c:RegisterEffect(e2)
end

function s.rthfilter(c,tp)
	return c:IsAbleToHand() and c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function s.rthtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:IsExists(s.rthfilter,1,nil,1-tp) end
	local g=eg:Filter(s.rthfilter,nil,1-tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local tg=g:Select()
    Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,0,0)
end
function s.rthop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	return c:IsPreviousLocation(LOCATION_SZONE)
		and c:IsPreviousPosition(POS_FACEDOWN)
		and c:IsPreviousControler(tp)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end