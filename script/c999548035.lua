--Magikarp (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Tackle
    pokeutil.InitAtk(c,id,1,"N",1)
	--Flail
	pokeutil.InitAtk(c,id,2,"W",0,nil,nil,nil,s.flop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_THUNDER,"*",2)
end
function s.flop(e,tp,eg,ep,ev,re,r,rp,tg)
    local c=e:GetHandler()
    local tc=tg:GetFirst()
    if c and c:IsRelateToEffect(e) then
        local counters=c:GetCounter(0x1300)
        if counters>0 then
            tc:AddCounter(0x1300,counters)
        end
    end
end