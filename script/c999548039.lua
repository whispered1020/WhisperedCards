--Porygon (Base Set)
--Scripted by: Whispered
Duel.LoadScript("pokeutil.lua")
local s,id=GetID()
function s.initial_effect(c)
    --Conversion 1
    pokeutil.InitAtk(c,id,1,"N",0,nil,nil,nil,s.cop1)
	--Conversion 2
    pokeutil.InitAtk(c,id,2,"NN",0,nil,nil,nil,s.cop2)

	pokeutil.InitRetreat(c,id)

	pokeutil.InitWeakRes(c,RACE_ROCK,"*",2,RACE_PSYCHIC,"-",3)
end
-- Table mapping races to string IDs
local raceStringMap = {
    [RACE_AQUA]     = aux.Stringid(id,3),
    [RACE_PYRO]     = aux.Stringid(id,4),
    [RACE_PLANT]    = aux.Stringid(id,5),
    [RACE_ROCK]     = aux.Stringid(id,6),
    [RACE_THUNDER]  = aux.Stringid(id,7),
    [RACE_PSYCHIC]  = aux.Stringid(id,8),
    [RACE_FIEND]    = aux.Stringid(id,9),
    [RACE_MACHINE]  = aux.Stringid(id,10),
    [RACE_FAIRY]    = aux.Stringid(id,11),
    [RACE_DRAGON]   = aux.Stringid(id,12),
}
local raceResistStringMap = {
    [RACE_AQUA]     = aux.Stringid(999548001,3),
    [RACE_PYRO]     = aux.Stringid(999548001,4),
    [RACE_PLANT]    = aux.Stringid(999548001,5),
    [RACE_ROCK]     = aux.Stringid(999548001,6),
    [RACE_THUNDER]  = aux.Stringid(999548001,7),
    [RACE_PSYCHIC]  = aux.Stringid(999548001,8),
    [RACE_FIEND]    = aux.Stringid(999548001,9),
    [RACE_MACHINE]  = aux.Stringid(999548001,10),
    [RACE_FAIRY]    = aux.Stringid(999548001,11),
    [RACE_DRAGON]   = aux.Stringid(999548001,12),
}

function s.cop1(e,tp,eg,ep,ev,re,r,rp,tg)
    local tc=tg:GetFirst()
    local races=RACE_AQUA+RACE_PYRO+RACE_PLANT+RACE_ROCK+RACE_THUNDER+RACE_PSYCHIC+RACE_FIEND+RACE_MACHINE+RACE_FAIRY+RACE_DRAGON
    local ac=Duel.AnnounceRace(tp,1,races)
    local desc=raceStringMap[ac]
    if tc:GetFlagEffect(pokeutil.CHANGE_WEAK_FLAG)>0 then
        pokeutil.resetNow(tc,eh,pokeutil.CHANGE_WEAK_FLAG)
    end
    tc:RegisterFlagEffect(pokeutil.CHANGE_WEAK_FLAG,RESET_EVENT+RESETS_STANDARD,0,1,ac)
    local eh=Effect.CreateEffect(tc)
		eh:SetType(EFFECT_TYPE_SINGLE)
		eh:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		eh:SetDescription(desc)
		eh:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(eh)
end
function s.cop2(e,tp,eg,ep,ev,re,r,rp,tg)
    local c=e:GetHandler()
    local races=RACE_AQUA+RACE_PYRO+RACE_PLANT+RACE_ROCK+RACE_THUNDER+RACE_PSYCHIC+RACE_FIEND+RACE_MACHINE+RACE_FAIRY+RACE_DRAGON
    local ac=Duel.AnnounceRace(tp,1,races)
    local desc=raceResistStringMap[ac]
    if c:GetFlagEffect(pokeutil.CHANGE_RESIST_FLAG)>0 then
        pokeutil.resetNow(c,eh,pokeutil.CHANGE_RESIST_FLAG)
    end
    c:RegisterFlagEffect(pokeutil.CHANGE_RESIST_FLAG,RESET_EVENT+RESETS_STANDARD,0,1,ac)
    local eh=Effect.CreateEffect(c)
		eh:SetType(EFFECT_TYPE_SINGLE)
		eh:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		eh:SetDescription(desc)
		eh:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(eh)
end