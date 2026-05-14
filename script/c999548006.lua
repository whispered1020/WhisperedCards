--Gyarados (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Magikarp
    pokeutil.InitStage(c,id,999548035)
	--Dragon Rage
	pokeutil.InitAtk(c,id,1,"WWW",5)
	--Bubblebeam
	pokeutil.InitAtk(c,id,2,"WWWW",4,nil,nil,nil,s.bbop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PLANT,"*",2,RACE_ROCK,"-",3)
end
function s.bbop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    if Duel.TossCoin(tp,1)==1 then
        pokeutil.ApplyParalyze(tc)
    end
end