---Clefairy (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
Duel.LoadScript("moves_all.lua")
local s,id=GetID()
function s.initial_effect(c)
	--Sing
	pokeutil.InitAtk(c,id,1,"N",0,nil,nil,nil,s.sop)
	--Metronome
	pokeutil.InitAtk(c,id,2,"NNN",0,nil,nil,nil,s.meop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"*",2,RACE_PSYCHIC,"-",3)
end
function s.sop(e,tp,eg,ep,ev,re,r,rp,tg)
	local tc=tg:GetFirst()
	if not tc then return end
	if Duel.TossCoin(tp,1)==1 then
		pokeutil.ApplySleep(tc)
	end
end
--TODO#Metronome