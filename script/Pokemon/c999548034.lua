--Machoke (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Machop
    pokeutil.InitStage(c,id,999548052)
	--Karate Chop
	pokeutil.InitAtk(c,id,1,"FFN",0,nil,nil,nil,s.kcop)
	--Submission
	pokeutil.InitAtk(c,id,2,"FFNN",6,nil,nil,nil,s.smop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PSYCHIC,"*",2)
end
function s.kcop(e,tp,eg,ep,ev,re,r,rp,tg)
    local c=e:GetHandler()
    local tc=tg:GetFirst()
    local lostHP=c:GetCounter(0x1300)
    local dam=5-lostHP
    if tc and dam>0 then
        tc:AddCounter(0x1300,dam)
    end
end
function s.smop(e,tp,eg,ep,ev,re,r,rp,g)
    local c=e:GetHandler()
    if c and c:IsRelateToEffect(e) then
        c:AddCounter(0x1300,2)
    end
end