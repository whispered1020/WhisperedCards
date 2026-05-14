--Blastoise (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Wartortle
    pokeutil.InitStage(c,id,999548042)
    --Rain Dance
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(s.rdcon)
	e1:SetTarget(s.rdtg)
	e1:SetOperation(s.rdop)
	c:RegisterEffect(e1)
	--Hydro Pump
    pokeutil.InitAtk(c,id,1,"WWW",4,nil,nil,nil,s.hpop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_THUNDER,"*",2)
end
function s.rdcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    if c:GetFlagEffect(pokeutil.CONFUSION_FLAG)>0 or c:GetFlagEffect(pokeutil.PARALYZE_FLAG)>0 or c:GetFlagEffect(pokeutil.SLEEP_FLAG)>0 then return end
    if g:IsExists(s.energyfilter,1,nil) then return true end
end
function s.rdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,999912043)
            and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_MZONE,0,1,nil,RACE_AQUA)
    end
end
function s.rdop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
    local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,999912043)
    local energy=g:GetFirst()
    if not energy then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local m=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_MZONE,0,1,1,nil,RACE_AQUA):GetFirst()
    if not m then return end
    Duel.Overlay(m,Group.FromCards(energy))
end
function s.energyfilter(c)
    return c:IsCode(999912043)
end
function s.hpop(e,tp,eg,ep,ev,re,r,rp,tg)
    local c=e:GetHandler()
    local tc=tg:GetFirst()
    if not tc then return end
    local energies=c:GetOverlayGroup()
    local wEnergies=energies:Filter(s.energyfilter,nil,tp)
    if #wEnergies<=3 then return end
    if #wEnergies==4 then
        tc:AddCounter(0x1300,1)
    end
    if #wEnergies==5 then
        tc:AddCounter(0x1300,2)
    end
end