--Dewgong (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Seel
    pokeutil.InitStage(c,id,999548041)
	--Aurora Beam
	pokeutil.InitAtk(c,id,1,"WWN",5)
	--Ice Beam
	pokeutil.InitAtk(c,id,2,"WWNN",3,nil,nil,nil,s.ibop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_THUNDER,"*",2)
end
function s.ibop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyParalyze(tc)
    end
end