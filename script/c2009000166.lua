--Mokey Mokey - Different Dimension
--Scripted by: Whispered
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    --Mokey Mokey Effect Monsters become "Mokey Mokey"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CHANGE_CODE)
    e1:SetRange(LOCATION_FZONE)
    e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0)
    e1:SetTarget(s.nametg)
    e1:SetValue(27288416)
    c:RegisterEffect(e1)
    --No battle damage from battles involving Level 1 monsters you control
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(s.bdtarget)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Add Mokey Mokey Spell/Trap + monster
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1,id)
    e3:SetCost(s.thcost)
    e3:SetTarget(s.thtg)
    e3:SetOperation(s.thop)
    c:RegisterEffect(e3)
end
s.listed_names={27288416,id}
s.listed_series={SET_MOKEY_MOKEY}

--
function s.nametg(e,c)
    return c:IsSetCard(SET_MOKEY_MOKEY) and c:IsType(TYPE_EFFECT)
end
--
function s.bdtarget(e,c)
    return c:IsLevel(1)
end
--
function s.stfilter(c)
    return c:IsSetCard(SET_MOKEY_MOKEY) and c:IsSpellTrap() and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thfilter(c)
    return c:IsSetCard(SET_MOKEY_MOKEY) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.rescon(sg)
	return sg:FilterCount(Card.IsMonster,nil)==1
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,0) end
    local dg=aux.SelectUnselectGroup(g,e,tp,2,2,s.rescon,1,tp,HINTMSG_TOHAND)
    Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,dg,2,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetTargetCards(e)
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end
