--Magneton (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Magnemite
    pokeutil.InitStage(c,id,999548053)
    --Thunder Wave
    pokeutil.InitAtk(c,id,1,"LLN",3,nil,nil,nil,s.twop)
	--Selfdestruct
    pokeutil.InitAtk(c,id,2,"L",8,nil,nil,nil,s.sdop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"*",2)
end
function s.twop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyParalyze(tc)
    end
end
function s.eqfilter(c)
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    for tc in g:Iter() do
        tc:AddCounter(0x1300,2)
    end
    if c then
        c:AddCounter(0x1300,8)
    end
end