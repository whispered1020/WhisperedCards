--Tangela (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Bind
    pokeutil.InitAtk(c,id,1,"GN",2,nil,nil,nil,s.bnop)
    --Poison Powder
    pokeutil.InitAtk(c,id,2,"GGG",2,nil,nil,nil,s.ppop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PYRO,"*",2)
end
function s.bnop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyParalyze(tc)
    end
end
function s.ppop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    pokeutil.ApplyPoison(tc,1)
end