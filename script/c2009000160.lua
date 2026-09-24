--Vampire Frau
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon itself
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,id)
    e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
    local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
    --Accel Summon "Vampire" Xyz or Link
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
    e4:SetCountLimit(1,{id,1})
	e4:SetCost(Cost.PayLP(1000))
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
    local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
    local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--Declare 1 card type; opponent mills 1 card of declared type from deck to GY
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,2))
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_DAMAGE)
	e7:SetCondition(s.tgcon)
	e7:SetTarget(s.tgtg)
	e7:SetOperation(s.tgop)
	c:RegisterEffect(e7)
end
s.listed_series={SET_VAMPIRE}

function s.spfilter(c)
	return c:IsSetCard(SET_VAMPIRE) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function s.lkfilter(c,mg2,tc)
	return c:IsSetCard(SET_VAMPIRE) and (c:IsLinkSummonable(tc,mg2) or c:IsCanBeXyzMaterial())
end
function s.mfilter(c)
	return c:IsCanBeLinkMaterial() or c:IsCanBeXyzMaterial()
end
function s.tgfilter(tc,c,tp)
	local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil)
	--local mg=Group.AddCard(mg2,tc)
	return tc:IsFaceup() and Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg2,tc)
		and (tc:IsCanBeLinkMaterial() or tc:IsCanBeXyzMaterial())
end
function s.xyzfilter(c,e,tp,tc)
	return c:IsSetCard(SET_VAMPIRE) and c:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and tc:IsCanBeXyzMaterial(c,tp)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function s.linkfilter(c,mg2,tc)
	return c:IsSetCard(SET_VAMPIRE) and c:IsLinkSummonable(tc,mg2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(s.mfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(s.lkfilter,tp,LOCATION_EXTRA,0,1,nil,mg2,chkc)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.mfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	--Treat this card's Level as the same as the Xyz monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetValue(s.lvval)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	if tc and tc:IsControler(1-tp) and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local mg2=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4)) -- 3 = "Link Summon", 4 = "Xyz Summon"
		if op==0 then
			local g=Duel.SelectMatchingCard(tp,s.linkfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg2,tc)
			local sc=g:GetFirst()
			if sc then
				Duel.LinkSummon(tp,sc,tc,mg2)
				if e1 then e1:Reset() end
			end
		elseif op==1 then
			local g=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
			local sc=g:GetFirst()
			if sc then
				local mg=mg2:Select(tp,1,1,nil)
				sc:SetMaterial(mg)
				Duel.Overlay(sc,mg)
				if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
				sc:CompleteProcedure()
				Duel.Overlay(sc,tc)
		end
				if e1 then e1:Reset() end
			end
		end
	end
end
function s.lvval(e,c,rc)
	local lv=c:GetLevel()
	local xyzl=rc:GetRank()
	if rc:IsSetCard(SET_VAMPIRE) and xyzl>0 then
		return xyzl
	else
		return lv
	end
end
--
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(tp,70,71,72)
	e:SetLabel((1<<op))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK)
end
function s.tg2filter(c,ty)
	return c:IsType(ty) and c:IsAbleToGrave()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(1-tp,s.tg2filter,1-tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end