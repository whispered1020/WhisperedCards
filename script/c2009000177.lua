--Gridbound Watchtower
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon this card from your hand or GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
    --If this card is Special Summoned: You can target 1 monster you control; change its battle position, then, if that monster has a Grid Counter, you can destroy 1 monster in a column adjacent to that monster.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
s.counter_place_list={0x1989}
s.listed_series={0xf24}

function s.gridcon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xf24),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or s.gridcon(e)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
--
function s.desfilter(c,s,p)
	local seq=c:GetSequence()
	return seq<5 and c:IsControler(p) and math.abs(seq-s)==1
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
    if tc:GetCounter(0x1989)>0 then
        local seq=tc:GetSequence()
		local dg=Group.CreateGroup()
		if seq<5 then dg=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,seq,tc:GetControler()) end
		if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
            Duel.BreakEffect()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local tc2=dg:Select(tp,1,1,nil)
            Duel.HintSelection(tc2)
			Duel.Destroy(tc2,REASON_EFFECT)
		end
    end
end