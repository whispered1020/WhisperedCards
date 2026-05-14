--Wartortle (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Squirtle
    pokeutil.InitStage(c,id,999548063)
    --Withdraw
    pokeutil.InitAtk(c,id,1,"WN",0,nil,nil,nil,s.wdop)
	--Bite
    pokeutil.InitAtk(c,id,2,"WNN",4)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_THUNDER,"*",2)
end
function s.wdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.TossCoin(tp,1)==1 then
        pokeutil.RegisterFlagWithHint(c, pokeutil.COUNTER_IMMUNITY_FLAG, RESET_PHASE+PHASE_END+RESET_OPPO_TURN, aux.Stringid(100,5))
	end
end