--Gridbound Pawn
--scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
	--register when a card leaves the field
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(s.regop)
	c:RegisterEffect(e0)
	--Add 1 "Grid-" Spell/Trap or "Board in Grid" from your Deck to your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(Cost.SelfDiscard)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--If a monster with a Grid Counter in a zone adjacent to this card is Tributed or destroyed: Give control of this card to your opponent, then, immediately after this effect resolves, its controller can Fusion Summon 1 Rock Fusion Monster, using this card and 1 other monster they control.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e3)
end
s.listed_names={2009000176}
s.listed_series={0xf24}

function s.lvfdfilter(c,seq)
	return c:IsLocation(LOCATION_MZONE) and c:GetCounter(0x1989)>0
		and (seq-1>=0 and c:GetPreviousSequence()==seq-1) or (seq+1<=4 and c:GetPreviousSequence()==seq+1)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.lvfdfilter,1,nil,e:GetHandler():GetSequence()) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
--
function s.thfilter(c)
	return c:IsAbleToHand() and (c:IsCode(2009000176) or c:IsSetCard(0xf24))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function s.spconfilter(c,seq)
	return c:IsPreviousLocation(LOCATION_MZONE) or (c:IsMonsterCard() and not c:IsPreviousLocation(LOCATION_SZONE))
		and (seq-1>=0 and c:GetPreviousSequence()==seq-1) or (seq+1<=4 and c:GetPreviousSequence()==seq+1)
		and c:IsPreviousPosition(POS_FACEUP)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spconfilter,1,nil,e:GetHandler():GetSequence()) and e:GetLabelObject():GetLabel()==1
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cc=c:GetControler()
	if cc==1-tp then cc=tp else cc=1-tp end
	if chk==0 then return c:IsAbleToChangeControler()
		and Duel.GetLocationCount(cc,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,c,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_FUSION_SUMMON,nil,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cc=c:GetControler()
	if cc==1-tp then cc=tp else cc=1-tp end
	if not c:IsRelateToEffect(e) or not Duel.GetControl(c,cc) then return end
	local fusion_params={handler=c,fusfilter=aux.FilterBoolFunction(Card.IsRace,RACE_ROCK),matfilter=Fusion.OnFieldMat,gc=Fusion.ForcedHandler}
		if Fusion.SummonEffTG(fusion_params)(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Fusion.SummonEffOP(fusion_params)(e,tp,eg,ep,ev,re,r,rp,1)
		end
end