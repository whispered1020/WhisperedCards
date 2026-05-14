--Chansey (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Scrunch
	pokeutil.InitAtk(c,id,1,"NN",0,nil,nil,nil,s.scop)
	--Double-Edge
	pokeutil.InitAtk(c,id,2,"NNNN",8,nil,nil,nil,s.deop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"*",2,RACE_PSYCHIC,"-",3)
end

function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.TossCoin(tp,1)==1 then
		pokeutil.RegisterFlagWithHint(c, pokeutil.COUNTER_IMMUNITY_FLAG, RESET_PHASE+PHASE_END+RESET_OPPO_TURN, aux.Stringid(100,5))
	end
end

function s.deop(e,tp,eg,ep,ev,re,r,rp,g)
    local c=e:GetHandler()
    if c and c:IsRelateToEffect(e) then
        c:AddCounter(0x1300,8)
    end
end