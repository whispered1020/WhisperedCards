--Vulpix (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Confuse Ray
    pokeutil.InitAtk(c,id,1,"RR",1,nil,nil,nil,s.crop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_AQUA,"*",2)
end
function s.crop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyConfusion(tc)
    end
end