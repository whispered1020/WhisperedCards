--Alakazam (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Kadabra
    pokeutil.InitStage(c,id,999548032)
    --Damage Swap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.dscon)
	e1:SetTarget(s.dstg)
	e1:SetOperation(s.dsop)
	c:RegisterEffect(e1)
    --Confuse Ray
    pokeutil.InitAtk(c,id,1,"PPP",3,nil,nil,nil,s.crop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"*",2)
end
function s.crop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyConfusion(tc)
    end
end
function s.dscon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    if c:GetFlagEffect(pokeutil.CONFUSION_FLAG)>0 or c:GetFlagEffect(pokeutil.PARALYZE_FLAG)>0 or c:GetFlagEffect(pokeutil.SLEEP_FLAG)>0 then return end
    if Duel.GetCounter(tp,1,0,0x1300)==0 then return end
    local survivors=0
    for tc in aux.Next(g) do
        if tc:GetAttack()>=20 then
            survivors = survivors + 1
        end
    end
    return survivors>=2
end
function s.dsfilter(c)
    return c:IsFaceup() and c:GetAttack()>=20
end
function s.dsfilter2(c)
    return c:IsFaceup() and c:GetCounter(0x1300)>0
end
--selects the pokemon to move the counter from
function s.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.dsfilter2,tp,LOCATION_MZONE,0,1,nil) end
end
--selects the pokemon to move the counter to and moves it
function s.dsop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g1=Duel.SelectMatchingCard(tp,s.dsfilter2,tp,LOCATION_MZONE,0,1,1,nil)
    local tc1=g1:GetFirst()
    if not tc1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g2=Duel.SelectMatchingCard(tp,s.dsfilter,tp,LOCATION_MZONE,0,1,1,nil)
    local tc2=g2:GetFirst()
    if not tc2 then return end
    tc1:RemoveCounter(tp,0x1300,1,REASON_EFFECT)
    tc2:AddCounter(0x1300,1)
end
