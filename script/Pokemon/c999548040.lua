--Raticate (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Rattata
    pokeutil.InitStage(c,id,999548061)
    --Bite
    pokeutil.InitAtk(c,id,1,"N",2)
	--Super Fang
    pokeutil.InitAtk(c,id,2,"NNN",0,nil,nil,nil,s.sfop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"*",2,RACE_PSYCHIC,"-",3)
end
function s.sfop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    local dam=tc:GetAttack()/10/2
    if tc:GetAttack()==10 then dam=1 end
    if not tc then return end
    if dam>0 then
        tc:AddCounter(0x1300,dam)
    end
end