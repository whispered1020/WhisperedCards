--Poliwhirl (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Evolve from Poliwag
    pokeutil.InitStage(c,id,999548059)
	--Amnesia
	pokeutil.InitAtk(c,id,1,"WW",0,nil,nil,nil,s.anop)
	--Double Slap
	pokeutil.InitAtk(c,id,2,"WWN",0,nil,nil,nil,s.dsop)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_PLANT,"*",2)
end
function s.anop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    local atk1=aux.Stringid(tc:GetCode(),1)
    local atk2=aux.Stringid(tc:GetCode(),2)
    local atk1Exist=atk1~=nil
    local atk2Exist=atk2~=nil

    local op=Duel.SelectEffect(tp,
		{atk1Exist,aux.Stringid(tc:GetCode(),1)},
		{atk2Exist,aux.Stringid(tc:GetCode(),2)})
    pokeutil.ApplyAmnesia(tc,op)
end
function s.dsop(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    if not tc then return end
    local heads=0
    for i=1,2 do
        if Duel.TossCoin(tp,1)==1 then
            heads=heads+1
        end
    end
    if heads>0 then
        local dam=heads
        tc:AddCounter(0x1300,dam*3)
    end
end