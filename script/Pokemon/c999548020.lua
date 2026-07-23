--Electabuzz (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Thundershock
    pokeutil.InitAtk(c,id,1,"L",1,nil,nil,nil,s.tsop)
	--Thunder Punch
	pokeutil.InitAtk(c,id,2,"LN",3,nil,nil,nil,s.tpop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"-",3)
end
function s.tsop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyParalyze(tc)
    end
end
function s.tpop(e,tp,eg,ep,ev,re,r,rp,tg)
    local c=e:GetHandler()
    local tc=tg:GetFirst()
    if Duel.TossCoin(tp,1)==1 then
        --do 10 more damage
        if tc then
            tc:AddCounter(0x1300,1)
        end
    else
        --do 10 damage to itself
        if c and c:IsRelateToEffect(e) then
            c:AddCounter(0x1300,1)
        end
    end
end