--Eonwheel, The New Age
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--Remember when a card is returned to the hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetRange(LOCATION_ONFIELD)
	e0:SetOperation(s.regflag)
	c:RegisterEffect(e0)
	--Return all monsters to the hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.rthcon)
	e1:SetTarget(s.rthtg)
	e1:SetOperation(s.rthop)
	c:RegisterEffect(e1)
	--Banish from GY; add "Eonwheel" Spell
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
    e2:SetHintTiming(0,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.gytg)
	e2:SetOperation(s.gyop)
	c:RegisterEffect(e2)
end

function s.flagfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
		or (c:IsPreviousLocation(LOCATION_EXTRA) and c:IsFaceup())
end
function s.regflag(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if eg:IsExists(s.flagfilter,1,nil,tp) then
        c:RegisterFlagEffect(id+100,RESET_PHASE|PHASE_END,0,1)
    end
end
--
function s.rthcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
		and e:GetHandler():GetFlagEffect(id+100)>0
end
function s.rthfilter(c)
	return c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function s.rthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rthfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(s.rthfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,PLAYER_ALL,LOCATION_HAND)
end
function s.rthop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.rthfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	--Each player can Special Summon 1 monster
	for p=0,1 do
		if Duel.GetLocationCount(p,LOCATION_MZONE)<=0 then return end
		local sg=Duel.GetMatchingGroup(s.spfilter,p,LOCATION_HAND,0,nil,e,p)
		if #sg>0 and Duel.SelectYesNo(p,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
			local tc=sg:Select(p,1,1,nil):GetFirst()
			if tc then
				Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end
--
function s.gyfilter(c)
	return c:IsSetCard(0xf22) and c:IsSpell() and c:IsAbleToHand()
end
function s.trapfilter(c)
	return c:IsSetCard(0xf22) and c:IsTrap() and c:IsSSetable()
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.gyfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,s.gyfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
    Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	    if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
            local sg=Duel.SelectMatchingCard(tp,s.trapfilter,tp,LOCATION_DECK,0,1,1,nil)
            if sg then
				Duel.SSet(tp,sg)
				Duel.ConfirmCards(1-tp,sg)
		    end
	    end
	else return
    end
end