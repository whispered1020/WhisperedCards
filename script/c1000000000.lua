--Fossil Manoeuvre
--Scripted by: Pedroribeiro
--Revised by: Whispered
local s,id=GetID()
function s.initial_effect(c)
    --draw 2
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.drawtg)
    e1:SetOperation(s.drawop)
    c:RegisterEffect(e1)
    --Special Summon from GY
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,{id,1})
    e2:SetCondition(s.spcon)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    c:RegisterEffect(e2)
end
s.listed_names = {59419719}
s.listed_series={SET_FOSSIL}

--
function s.discard_filter(c)
    return c:IsDiscardable(REASON_EFFECT) and c:IsCode(59419719) or c:ListsCode(59419719)
end
function s.drawtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp, 2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,1)
end
function s.drawop(e, tp, eg, ep, ev, re, r, rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)>0 then
        Duel.ShuffleHand(p)
        Duel.BreakEffect()
		local handg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
        if handg:IsExists(s.discard_filter,1,nil) then
            Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
            local dg=handg:FilterSelect(tp,s.discard_filter,1,1,nil)
            if #dg>0 then
				Duel.SendtoGrave(dg,REASON_EFFECT|REASON_DISCARD)
            else
			    Duel.SendtoGrave(handg,REASON_EFFECT|REASON_DISCARD)
            end
        end
    end
end
--
function s.cfilter(c)
    return c:IsMonster() and c:ListsCode(59419719)
end
function s.spfilter(c, e, tp)
    return c:IsRace(RACE_ROCK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.cfilter,1,nil) and e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp, LOCATION_MZONE)>0 and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,0,0)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
