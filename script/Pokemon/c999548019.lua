--Dugtrio (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Diglett
    pokeutil.InitStage(c,id,999548047)
    --Slash
    pokeutil.InitAtk(c,id,1,"FFN",4)
	--Earthquake
    pokeutil.InitAtk(c,id,2,"FFFF",7,nil,nil,s.eqtg,s.eqop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PLANT,"*",2,RACE_THUNDER,"-",3)
end
function s.eqfilter(c)
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(s.eqfilter,tp,LOCATION_MZONE,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.eqfilter,tp,LOCATION_MZONE,0,nil)
    for tc in g:Iter() do
        tc:AddCounter(0x1300,1)
    end
end