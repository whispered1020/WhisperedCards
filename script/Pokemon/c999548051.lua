--Koffing (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Foul Gas
	pokeutil.InitAtk(c,id,1,"GG",1,nil,nil,nil,s.fgop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"*",2)
end
function s.fgop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyPoison(tc)
    else
        pokeutil.ApplyConfusion(tc)
    end
end