--Gridbound Knight
--scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
    c:EnableCounterPermit(0x1989)
	--Special Summon 1 "Gridbound" monster from the GY or hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,id)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
    --Move 1 monster card you control to another of your Main Monster Zones, then you can place 1 Grid Counter on all face-up cards in the moved card's column
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_COUNTER+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,1})
	e3:SetTarget(s.seqtg)
	e3:SetOperation(s.seqop)
	c:RegisterEffect(e3)
end
s.listed_series={0xf23}

function s.spfilter(c,e,tp)
	return c:IsSetCard(0xf23) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and not c:IsCode(id)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE|LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE|LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE|LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
    Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
    if #g>0 then
        local tc=g:GetFirst()
	    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	    local seq=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	    if seq then
		    Duel.MoveSequence(tc,math.log(seq,2))
		    local dg=tc:GetColumnGroup():Filter(aux.AND(Card.IsMonster,Card.IsFaceup),tc,nil)
		    if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			    Duel.BreakEffect()
			    for tc1 in dg:Iter() do
		            tc1:AddCounter(0x1989,1)
                    Duel.ChangePosition(tc1,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		            --Cannot change its battle position
		            local e1a=Effect.CreateEffect(e:GetHandler())
		            e1a:SetDescription(3313)
		            e1a:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		            e1a:SetType(EFFECT_TYPE_SINGLE)
		            e1a:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		            e1a:SetReset(RESET_EVENT|RESETS_STANDARD)
                    e1a:SetCondition(s.poscon)
		            tc1:RegisterEffect(e1a)
	            end
		    end
	    end
    end
end
function s.poscon(e)
	return e:GetHandler():GetCounter(0x1989)>0
end