--Gridbound Rook
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(0x1989)
    --You can activate this card the turn it was Set, by revealing 1 Normal Monster in your hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetValue(function(e) e:SetLabel(1) end)
	e0:SetCondition(function(e) return Duel.IsExistingMatchingCard(s.costfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil) end)
	c:RegisterEffect(e0)
    --Move 1 monster, then Special Summon Rook
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    --Place Grid Counter and lock battle position
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,2))
    e2:SetCategory(CATEGORY_COUNTER+CATEGORY_POSITION)
    e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,{id,2})
	e2:SetCondition(aux.exccon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.cttg)
    e2:SetOperation(s.ctop)
    c:RegisterEffect(e2)
end
s.listed_series={0xf23,0xf24}
s.listed_names={id,2009000184}

function s.costfilter(c)
	return c:IsSetCard(0xf23) and not c:IsPublic()
end
--
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
	local zone=c:GetColumnZone(LOCATION_MZONE)&ZONES_MMZ
    local own_loc=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and LOCATION_MZONE or 0
	local opp_loc=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and LOCATION_MZONE or 0
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and (chkc:IsControler(tp) and (own_loc>0) or (opp_loc>0)) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:IsHasType(EFFECT_TYPE_ACTIVATE)
        and zone>0 and not Duel.IsExistingMatchingCard(aux.IsZone,tp,LOCATION_MZONE,0,1,nil,zone,tp)
        and Duel.IsExistingTarget(nil,tp,own_loc,opp_loc,1,nil)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER|TYPE_EFFECT,1900,2000,5,RACE_ROCK,ATTRIBUTE_EARTH)
    end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	Duel.SelectTarget(tp,nil,tp,own_loc,opp_loc,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
	local zone=c:GetColumnZone(LOCATION_MZONE)&ZONES_MMZ
	if not (c:IsRelateToEffect(e) and zone>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER|TYPE_EFFECT,1900,2000,5,RACE_ROCK,ATTRIBUTE_EARTH)) then return end
    if not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
    local player=tc:GetControler()
    if Duel.GetLocationCount(player,LOCATION_MZONE)>0 then
		local is_own=player==tp
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local zone=Duel.SelectDisableField(tp,1,is_own and LOCATION_MZONE or 0,is_own and 0 or LOCATION_MZONE,0)
		if not is_own then zone=zone>>16 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		Duel.MoveSequence(tc,math.log(zone,2))
	end
    local tcs=tc:GetSetCard()
    if tcs and tcs[1]==0xf23 then
        if Duel.SelectYesNo(tp,aux.Stringid(id,4)) and s.sptg(e,tp,eg,ep,ev,re,r,rp,0) then
            Duel.BreakEffect()
            c:AddMonsterAttribute(TYPE_EFFECT)
            c:AssumeProperty(ASSUME_RACE,RACE_ROCK)
            Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP,zone)
            --Summon Pawn Token + Synchro Summon
            local e1a=Effect.CreateEffect(c)
            e1a:SetDescription(aux.Stringid(id,5))
            e1a:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
            e1a:SetType(EFFECT_TYPE_QUICK_O)
            e1a:SetCode(EVENT_FREE_CHAIN)
            e1a:SetRange(LOCATION_MZONE)
            e1a:SetCountLimit(1,{id,5})
            e1a:SetCondition(s.tkcon)
            e1a:SetCost(s.tkcost)
            e1a:SetTarget(s.tktg)
            e1a:SetOperation(s.tkop)
            e1a:SetReset(RESET_EVENT|RESETS_STANDARD)
            c:RegisterEffect(e1a,true)
            --Negate face-up Spell/Trap
            local e1b=Effect.CreateEffect(c)
            e1b:SetDescription(aux.Stringid(id,6))
            e1b:SetCategory(CATEGORY_DISABLE)
            e1b:SetType(EFFECT_TYPE_QUICK_O)
            e1b:SetCode(EVENT_FREE_CHAIN)
            e1b:SetProperty(EFFECT_FLAG_CARD_TARGET)
            e1b:SetRange(LOCATION_MZONE)
            e1b:SetCountLimit(1,{id,6})
            e1b:SetCondition(s.discon)
            e1b:SetCost(s.discost)
            e1b:SetTarget(s.distg)
            e1b:SetOperation(s.disop)
            e1b:SetReset(RESET_EVENT|RESETS_STANDARD)
            c:RegisterEffect(e1b,true)
            c:AddMonsterAttributeComplete()
        end
        Duel.SpecialSummonComplete()
    end
end
--
function s.synchfilter(c,mc)
	return c:IsRace(RACE_ROCK) and c:IsSynchroSummonable(mc)
end
function s.tkcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsMainPhase()
end
function s.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1989,1,REASON_COST) end
    Duel.RemoveCounter(tp,1,1,0x1989,1,REASON_COST)
end
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,2009000184,0xf23,TYPES_TOKEN+TYPE_TUNER,500,500,1,RACE_ROCK,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
    Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local token=0
    if s.tktg(e,tp,eg,ep,ev,re,r,rp,0) then
		token=Duel.CreateToken(tp,2009000184)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
	if Duel.SpecialSummonComplete()==0 then return end
    local synchg=Duel.GetMatchingGroup(s.synchfilter,tp,LOCATION_EXTRA,0,nil,token)
    if #synchg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,7)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=synchg:Select(tp,1,1,nil):GetFirst()
		if sc then
			Duel.BreakEffect()
			Duel.SynchroSummon(tp,sc,c)
		end
	end
end
--
function s.discon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsDefensePos()
end
function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1989,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x1989,1,REASON_COST)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and chkc:IsNegatable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsNegatable,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SelectTarget(tp,Card.IsNegatable,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,tp,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if #g==0 then return end
	local c=e:GetHandler()
	g:NegateEffects(c,RESET_PHASE|PHASE_END,true)
end
--
function s.filter(c)
	return c:IsCanChangePosition() and c:IsCanAddCounter(0x1989,1)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) and chkc:IsCanAddCounter(0x1989,1) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:AddCounter(0x1989,1) then
        Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		--Cannot change its battle position
		local e1a=Effect.CreateEffect(e:GetHandler())
		e1a:SetDescription(3313)
		e1a:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1a:SetType(EFFECT_TYPE_SINGLE)
		e1a:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1a:SetReset(RESET_EVENT|RESETS_STANDARD)
        e1a:SetCondition(s.poscon)
		tc:RegisterEffect(e1a)
	end
end
function s.poscon(e)
	return e:GetHandler():GetCounter(0x1989)>0
end