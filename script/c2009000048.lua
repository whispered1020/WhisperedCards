--Coryphora, the Sylvan High Watcher
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PLANT),5,2,s.matfilter,aux.Stringid(id,0),2,s.xyzop)
	c:EnableReviveLimit()
	--Excavate on Xyz Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,{id,1})
	e1:SetCondition(s.excacon)
	e1:SetTarget(s.excatg)
	e1:SetOperation(s.excaop)
	c:RegisterEffect(e1)
	--Detach to Xyz Summon 1 Xyz Monster from your Extra Deck, using monsters you control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE|TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,2})
	e2:SetCondition(function(e,tp) return Duel.IsTurnPlayer(1-tp) end)
	e2:SetCost(Cost.DetachFromSelf(2))
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
--Alternative Xyz Summon using a Sylvan Xyz Monster
function s.matfilter(c,tp,lc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ,lc,SUMMON_TYPE_XYZ,tp) and c:IsSetCard(0x90,lc,SUMMON_TYPE_XYZ,tp)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return not Duel.HasFlagEffect(tp,id) end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,EFFECT_FLAG_OATH,1)
	return true
end
--Excavate on Xyz Summon
function s.excacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.excatg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function s.excaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=math.min(c:GetOverlayCount(),Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
	if not Duel.IsPlayerCanDiscardDeck(tp,1) or ct==0 then return end
	Duel.ConfirmDecktop(tp,ct)
	local td=Duel.GetDecktopGroup(tp,ct)
	local tg=td:Filter(Card.IsRace,nil,RACE_PLANT)
	if #tg>0 then
		Duel.SendtoGrave(tg,REASON_EFFECT+REASON_EXCAVATE)
		Duel.DisableShuffleCheck()
		td:Sub(tg)
	end
	if #td>0 then
		Duel.MoveToDeckBottom(td)
		Duel.SortDeckbottom(tp,tp,#td)
	end
end
--
function s.gyfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsXyzSummonable()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.gyfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.gyfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.gyfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local lv=tc:GetLevel()
		if lv<=0 then return end
		-- Make Coryphora a Level equal to the revived monster
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_RANK_LEVEL)
		e0:SetValue(lv)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e0)
		local g=Duel.GetMatchingGroup(function(mc)
		return mc:IsRace(RACE_PLANT)
			and mc:IsType(TYPE_XYZ)
			and mc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and mc:GetRank()==lv
		end,tp,LOCATION_EXTRA,0,nil)
		if #g==0 then return end

		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=g:Select(tp,1,1,nil):GetFirst()
		-- Xyz Summon using Coryphora and the revived monster
		if Duel.XyzSummon(tp,xyz,Group.FromCards(c,tc),2,2) then
			local e0b=Effect.CreateEffect(c)
			e0b:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e0b:SetCode(EVENT_PHASE+PHASE_END)
			e0b:SetCountLimit(1)
			e0b:SetLabelObject(xyz)
			e0b:SetCondition(s.descon)
			e0b:SetOperation(s.desop)
			Duel.RegisterEffect(e0b,tp)
		end
	end
	function s.descon(e,tp,eg,ep,ev,re,r,rp)
		return e:GetLabelObject():IsOnField()
	end
	function s.desop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetLabelObject()
		if c:IsOnField() then
			Duel.Destroy(c,REASON_EFFECT)
		end
	e:Reset()
	end
end