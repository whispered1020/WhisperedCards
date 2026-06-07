-- Imprisoned Archfiend Hidarimi
-- Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	c:RegisterEffect(e1)
    --Send 1 level 4 or lower "Imprisoned Archfiend" monster from deck to GY --- not working
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	--Add 1 "Imprisoned Archfiend" card from your GY or banishment to your hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCountLimit(1,{id,1})
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	--Special Summon itself if it is banished
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,{id,2})
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	--Special Summon 1 "Imprisoned Archfiend" monster from your hand or GY
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,{id,3})
	e5:SetTarget(s.sptg2)
	e5:SetOperation(s.spop2)
	c:RegisterEffect(e5)
end

function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT) then return false end
	return (sumtype&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
--
function s.tgfilter(c)
	return c:IsSetCard(0x2045) and c:IsAbleToDeck()
end
function s.dcfilter(c)
	return c:IsSetCard(0x2045) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.strmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.dcfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			--Cannot Special Summon, except LIGHT and/or Fiend Monsters
	    	local e1=Effect.CreateEffect(c)
	    	e1:SetDescription(aux.Stringid(id,4))
	    	e1:SetType(EFFECT_TYPE_FIELD)
	    	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	    	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	    	e1:SetTargetRange(1,0)
	    	e1:SetTarget(function(_,c)
    			return not c:IsAttribute(ATTRIBUTE_LIGHT)
       			and not c:IsRace(RACE_FIEND)
			end)
	    	e1:SetReset(RESET_PHASE|PHASE_END)
	    	Duel.RegisterEffect(e1,tp)
		end
	end
end
--
function s.thcon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()
end
function s.thfilter(c)
	return c:IsSetCard(0x2045) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--
function s.mfilter(c)
	return not Duel.IsPlayerAffectedByEffect(c:GetControler(), CARD_SPIRIT_ELIMINATION)
		and c:HasLevel() and c:IsSetCard(0x2045) and c:IsMonster() and c:IsAbleToRemoveAsCost()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(aux.NecroValleyFilter(s.mfilter),tp,LOCATION_GRAVE,0,nil)
end
--
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x2045) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND|LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_GRAVE)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND|LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
		tc=g:GetFirst()
		--Disable
		local e1a=Effect.CreateEffect(e:GetHandler())
		e1a:SetType(EFFECT_TYPE_SINGLE)
		e1a:SetCode(EFFECT_DISABLE)
		e1a:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1a)
		local e1b=Effect.CreateEffect(e:GetHandler())
		e1b:SetType(EFFECT_TYPE_SINGLE)
		e1b:SetCode(EFFECT_DISABLE_EFFECT)
		e1b:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1b)
		--Cannot be used as Link Material
		local e1c=Effect.CreateEffect(e:GetHandler())
		e1c:SetDescription(3312)
		e1c:SetType(EFFECT_TYPE_SINGLE)
		e1c:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
		e1c:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1c:SetValue(1)
		e1c:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1c)
	end
end