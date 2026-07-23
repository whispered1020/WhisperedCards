--Abra (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Psyshock
	pokeutil.InitAtk(c,id,1,"P",1,nil,nil,nil,s.psop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"*",2)
end
function s.psop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyParalyze(tc)
    end
end