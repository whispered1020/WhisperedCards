--Weedle (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Poison Sting
    pokeutil.InitAtk(c,id,1,"G",1,nil,nil,nil,s.psop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PYRO,"*",2)
end
function s.psop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyPoison(tc)
    end
end