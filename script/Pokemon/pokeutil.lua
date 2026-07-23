--File included commonly used function, such as retreat, weaknes/resistance, and attacks
--Scripted by adruzenko03 (10V Battery)
--Scripted by Whispered
pokeutil={}

--pokeutil.InitAtk(c,id,atkNum,ener,dam,condCust,costCust,tgCust,opCust,checkWR)

-- Flag id used to mark a monster as immune to damage counters for 1 turn
pokeutil.COUNTER_IMMUNITY_FLAG = 999999001
--Sleep Flag (Status Condition)
pokeutil.SLEEP_FLAG = 999999002
--Poison Flag (Status Condition)
pokeutil.POISON_FLAG = 999999003
-- Flag id used to mark a monster as immune to other attack effects for 1 turn
pokeutil.EFFECT_IMMUNE_FLAG = 999999004
-- Flag id used to mark a monster as immune to status conditions (sleep, etc.) for 1 turn
pokeutil.STATUS_IMMUNE_FLAG = 999999005
--Paralyze Flag (Status Condition)
pokeutil.PARALYZE_FLAG = 999999006
--Flag for attacks that are once per card in play
pokeutil.LEEKSLAP_FLAG = 999999007
--Destiny Bond Flag
pokeutil.DESTINY_BOND_FLAG = 999999008
--Already on InitAtk, needs to be on any other damaging ability as well
pokeutil.LAST_DAMAGE_USER_FLAG = 999999009
--Flag to store pokemon's HP on turn start
pokeutil.STORED_START_TURN_HP_FLAG = 999999010
--Flag to store pokemon's HP on turn end
pokeutil.STORED_END_TURN_HP_FLAG = 999999011
--Confusion Flag (Status Condition)
pokeutil.CONFUSION_FLAG = 999999012
--Amnesia and similar effects flag
pokeutil.AMNESIA_FLAG = 999999013
--Immunity to attacks that does 30 damage or less Flag
pokeutil.IMMUNITY_30_OR_LESS_FLAG = 999999014
--Changed Weakness Flag
pokeutil.CHANGE_WEAK_FLAG = 999999015
--Changed Resistance Flag
pokeutil.CHANGE_RESIST_FLAG = 999999016
--03/feb/26 - function to check if a monster is immune to damage counters
function pokeutil.isCounterImmune(c)
	if not c then return false end
	return c:GetFlagEffect(pokeutil.COUNTER_IMMUNITY_FLAG)>0
end

--03/feb/26 - function to check if a monster is immune to attack effects for 1 turn
function pokeutil.isEffectImmune(c)
	if not c then return false end
	return c:GetFlagEffect(pokeutil.EFFECT_IMMUNE_FLAG)>0
end

--03/feb/26 - function to check if a monster is immune to status conditions for 1 turn
function pokeutil.isStatusImmune(c)
	if not c then return false end
	return c:GetFlagEffect(pokeutil.STATUS_IMMUNE_FLAG)>0
end

--03/feb/26 register a flag on a card and attach a client hint, 1 turn duration
function pokeutil.RegisterFlagWithHint(c,flag,reset,desc)
	if not c or not flag then return end
	-- Register the flag effect
	c:RegisterFlagEffect(flag,reset,0,1)
	-- Attach a client hint so players can see what the flag means
	local eh=Effect.CreateEffect(c)
	eh:SetType(EFFECT_TYPE_SINGLE)
	eh:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	if desc~=nil then
		eh:SetDescription(desc)
	end
	-- Ensure the hint effect expires with the same reset timing as the flag
	if reset~=nil then eh:SetReset(reset) end
	c:RegisterEffect(eh)
	pokeutil.resetEff(c,eh,flag)
	return eh
end

-- Sleep flag and helpers
pokeutil._sleep_hints = {}
pokeutil._sleep_triggers = {}
pokeutil._sleep_move_triggers = {}

--03/feb/26 - function to apply sleep status to a monster
function pokeutil.ApplySleep(c)
	if not c then return end
	-- if already asleep, do nothing
	if c:GetFlagEffect(pokeutil.SLEEP_FLAG)>0 then return end
	-- if target is status-immune, do nothing
	if (c:GetFlagEffect(pokeutil.STATUS_IMMUNE_FLAG)>0) or (c:GetFlagEffect(pokeutil.EFFECT_IMMUNE_FLAG)>0) then return end
	--If target is Paralyzed, clear it
	if c:GetFlagEffect(pokeutil.PARALYZE_FLAG)>0 then
		pokeutil.resetEff(c,nil,pokeutil.PARALYZE_FLAG)
	end
	--If target is Confused, clear it
	if c:GetFlagEffect(pokeutil.CONFUSION_FLAG)>0 then
		pokeutil.resetEff(c,nil,pokeutil.CONFUSION_FLAG)
	end
	-- register a persistent flag
	c:RegisterFlagEffect(pokeutil.SLEEP_FLAG,0,0,1)
	-- attach a client hint so players can see the status
	local eh=Effect.CreateEffect(c)
	eh:SetType(EFFECT_TYPE_SINGLE)
	eh:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	eh:SetDescription(aux.Stringid(100,3))
	c:RegisterEffect(eh)
	pokeutil.resetEff(c,eh,pokeutil.SLEEP_FLAG)
	pokeutil._sleep_hints[c]=eh

	-- create a per-card end-phase trigger to flip coin and wake up
	local te=Effect.CreateEffect(c)
	te:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	te:SetCode(EVENT_PHASE+PHASE_END)
	te:SetRange(LOCATION_MZONE)
	te:SetCountLimit(1)
	te:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=e:GetHandler()
		-- only act if the card is still asleep
		if not tc or tc:GetFlagEffect(pokeutil.SLEEP_FLAG)==0 then return end
		-- flip once for the controller of the sleeping card
		local p = tc:GetControler()
		-- show card and a short hint so players know what the coin toss is for
		Duel.Hint(HINT_CARD,0,tc:GetCode())
		Duel.Hint(HINT_SELECTMSG,p,aux.Stringid(100,4))
		if Duel.TossCoin(p,1)==1 then
			tc:ResetFlagEffect(pokeutil.SLEEP_FLAG)
			local hint = pokeutil._sleep_hints[tc]
			if hint then hint:Reset() pokeutil._sleep_hints[tc]=nil end
			local trg = pokeutil._sleep_triggers[tc]
			if trg then trg:Reset() pokeutil._sleep_triggers[tc]=nil end
		end
	end)
	c:RegisterEffect(te)
	pokeutil._sleep_triggers[c]=te
end

-- Paralyze flag and helpers
pokeutil._paralyze_hints = {}
pokeutil._paralyze_triggers = {}
pokeutil._paralyze_move_triggers = {}

--04/feb/26 - Function to apply paralysis status to a monster
function pokeutil.ApplyParalyze(c)
    if not c then return end
    -- if already paralyzed, do nothing
    if c:GetFlagEffect(pokeutil.PARALYZE_FLAG)>0 then return end
    -- if target is status/effect-immune, do nothing
    if (c:GetFlagEffect(pokeutil.STATUS_IMMUNE_FLAG)>0) or (c:GetFlagEffect(pokeutil.EFFECT_IMMUNE_FLAG)>0) then return end
	--If target is Asleep, clear it
	if c:GetFlagEffect(pokeutil.SLEEP_FLAG)>0 then
		pokeutil.resetEff(c,nil,pokeutil.SLEEP_FLAG)
	end
	--If target is Confused, clear it
	if c:GetFlagEffect(pokeutil.CONFUSION_FLAG)>0 then
		pokeutil.resetEff(c,nil,pokeutil.CONFUSION_FLAG)
	end
    -- register a persistent flag
 	c:RegisterFlagEffect(pokeutil.PARALYZE_FLAG,RESETS_STANDARD_PHASE_END,0,2)
    --Paralyze client hint
        local eh=Effect.CreateEffect(c)
		eh:SetType(EFFECT_TYPE_SINGLE)
		eh:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		eh:SetDescription(aux.Stringid(100,7))
		eh:SetReset(RESETS_STANDARD_PHASE_END,2)
        c:RegisterEffect(eh)
    pokeutil.resetEff(c,eh,pokeutil.PARALYZE_FLAG)
	pokeutil._paralyze_hints[c]=eh
end

-- Confusion flag and helpers
pokeutil._confusion_hints = {}
pokeutil._confusion_triggers = {}
pokeutil._confusion_move_triggers = {}

--Function to apply confusion status to a monster
function pokeutil.ApplyConfusion(c)
    if not c then return end
    -- if already confused, do nothing
    if c:GetFlagEffect(pokeutil.CONFUSION_FLAG)>0 then return end
    -- if target is status/effect-immune, do nothing
    if (c:GetFlagEffect(pokeutil.STATUS_IMMUNE_FLAG)>0) or (c:GetFlagEffect(pokeutil.EFFECT_IMMUNE_FLAG)>0) then return end
	--If target is Asleep, clear it
	if c:GetFlagEffect(pokeutil.SLEEP_FLAG)>0 then
		pokeutil.resetEff(c,nil,pokeutil.SLEEP_FLAG)
	end
	--If target is Paralyzed, clear it
	if c:GetFlagEffect(pokeutil.PARALYZE_FLAG)>0 then
		pokeutil.resetEff(c,nil,pokeutil.PARALYZE_FLAG)
	end
    -- register a persistent flag
 	c:RegisterFlagEffect(pokeutil.CONFUSION_FLAG,0,0,1)
    --Confusion client hint
        local eh=Effect.CreateEffect(c)
		eh:SetType(EFFECT_TYPE_SINGLE)
		eh:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		eh:SetDescription(aux.Stringid(100,11))
        c:RegisterEffect(eh)
	pokeutil.resetEff(c,eh,pokeutil.CONFUSION_FLAG)
	pokeutil._confusion_hints[c]=eh
end

-- Poison flag and helpers
pokeutil._poison_hints = {}
pokeutil._poison_triggers = {}
pokeutil._poison_move_triggers = {}

--The pokemon cant die instantly by poison cuz the function only check at chain resolution
--Function to apply poison status to a monster
function pokeutil.ApplyPoison(c,pDam)
	if not c then return end
	local pDam=pDam
	if pDam==nil then pDam=1 end
	-- if already poisoned, do nothing
	if c:GetFlagEffect(pokeutil.POISON_FLAG)>0 and pDam==1 then return end
	-- if already poisoned with normal poison, reset and apply severe poison
	if c:GetFlagEffect(pokeutil.POISON_FLAG)>0 and pDam==2 then
		pokeutil.resetEff(c,eh,pokeutil.POISON_FLAG)
		pokeutil.resetEff(c,he)
	end
	-- if target is status-immune, do nothing
	if (c:GetFlagEffect(pokeutil.STATUS_IMMUNE_FLAG)>0) or (c:GetFlagEffect(pokeutil.EFFECT_IMMUNE_FLAG)>0) then return end
	-- register a persistent flag
 	c:RegisterFlagEffect(pokeutil.POISON_FLAG,0,0,1)
	--Poison client hint and effect
	if pDam==1 then
		local eh=Effect.CreateEffect(c)
		eh:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		eh:SetCategory(CATEGORY_ATKCHANGE)
		eh:SetRange(LOCATION_MZONE)
		eh:SetCode(EVENT_PHASE+PHASE_END)
		eh:SetCountLimit(1)
		eh:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local tc=e:GetHandler()
			return tc and tc:GetFlagEffect(pokeutil.POISON_FLAG)>0
		end)
		eh:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local tc=e:GetHandler()
			if not tc then return end
			-- apply 1 damage counter at the end of each turn
			tc:AddCounter(0x1300,1)
			--Destroy the monster if it has 0 ATK
			if tc:GetAttack()==0 then
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end)
		c:RegisterEffect(eh)
		pokeutil._poison_triggers[c]=eh
		local he=Effect.CreateEffect(c)
		he:SetType(EFFECT_TYPE_SINGLE)
		he:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		he:SetDescription(aux.Stringid(100,9))
		c:RegisterEffect(he)
		pokeutil._poison_hints[c]=he
	pokeutil.resetEff(c,eh,pokeutil.POISON_FLAG)
	pokeutil.resetEff(c,he)
	end
	if pDam==2 then
		local eh=Effect.CreateEffect(c)
		eh:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		eh:SetCategory(CATEGORY_ATKCHANGE)
		eh:SetRange(LOCATION_MZONE)
		eh:SetCode(EVENT_PHASE+PHASE_END)
		eh:SetCountLimit(1)
		eh:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local tc=e:GetHandler()
			return tc and tc:GetFlagEffect(pokeutil.POISON_FLAG)>0
		end)
		eh:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local tc=e:GetHandler()
			if not tc then return end
			-- apply 2 damage counter at the end of each turn
			tc:AddCounter(0x1300,2)
			--Destroy the monster if it has 0 ATK
			if tc:GetAttack()==0 then
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end)
		c:RegisterEffect(eh)
		pokeutil._poison_triggers[c]=eh
		local he=Effect.CreateEffect(c)
		he:SetType(EFFECT_TYPE_SINGLE)
		he:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		he:SetDescription(aux.Stringid(100,10))
		c:RegisterEffect(he)
		pokeutil._poison_hints[c]=he
	pokeutil.resetEff(c,eh,pokeutil.POISON_FLAG)
	pokeutil.resetEff(c,he)
	end
end

-- Destiny Bond flag and helpers
pokeutil._destiny_bond_hints = {}
pokeutil._destiny_bond_triggers = {}
pokeutil._destiny_bond_move_triggers = {}

--Function to apply and execute Destiny Bond's effect
function pokeutil.ApplyDestinyBond(c)
    if not c then return end
    if c:GetFlagEffect(pokeutil.DESTINY_BOND_FLAG)>0 then return end

    -- flag + hint
    c:RegisterFlagEffect(pokeutil.DESTINY_BOND_FLAG,RESET_PHASE+PHASE_END,0,2)
    local eh=Effect.CreateEffect(c)
    eh:SetType(EFFECT_TYPE_SINGLE)
    eh:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    eh:SetDescription(aux.Stringid(100,8))
    eh:SetReset(RESET_PHASE+PHASE_END,2)
    c:RegisterEffect(eh)
	pokeutil._destiny_bond_hints[c]=eh
	--trigger
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCategory(CATEGORY_DESTROY)
    e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetReset(RESET_PHASE+PHASE_END,2)
    e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
        local tc=e:GetHandler()
        return tc:GetFlagEffect(pokeutil.DESTINY_BOND_FLAG)>0
           and tc:IsReason(REASON_EFFECT)
    end)
    e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
    local attacker=pokeutil.GetLastDamageUser()
    if attacker then
            Duel.Destroy(attacker,REASON_EFFECT)
        end
	end)
    c:RegisterEffect(e1)
	pokeutil._destiny_bond_triggers[c]=e1
end

-- Amnesia flag and helpers
pokeutil._amnesia_hints = {}
pokeutil._amnesia_triggers = {}
pokeutil._amnesia_move_triggers = {}

--The hint is not showing the correct text (cannot use X attack)
--Function to apply amnesia flag to the target with the chosen attack to disable
function pokeutil.ApplyAmnesia(c,chosen)
	if not c then return end
	local atkName=aux.Stringid(c:GetCode(),chosen)

	-- flag + hint
	c:RegisterFlagEffect(pokeutil.AMNESIA_FLAG,RESET_PHASE+PHASE_END,0,2,chosen)
	local eh=Effect.CreateEffect(c)
	eh:SetType(EFFECT_TYPE_SINGLE)
	eh:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	eh:SetDescription(aux.Stringid(c:GetCode(),chosen))
	eh:SetReset(RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(eh)
	pokeutil._amnesia_hints[c]=eh
end


--Last Damage User Flag
-- Helper to mark the last attacker globally
function pokeutil.MarkLastDamageUser(attacker)
    if not attacker then return end
    -- Clear the flag from all monsters first
    local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    for tc in aux.Next(g) do
        tc:ResetFlagEffect(pokeutil.LAST_DAMAGE_USER_FLAG)
    end
    -- Register the flag on the new attacker
    attacker:RegisterFlagEffect(pokeutil.LAST_DAMAGE_USER_FLAG,RESET_PHASE+PHASE_END,0,2)
end

-- Helper to retrieve the last attacker
function pokeutil.GetLastDamageUser()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    for tc in aux.Next(g) do
        if tc:GetFlagEffect(pokeutil.LAST_DAMAGE_USER_FLAG)>0 then
            return tc
        end
    end
    return nil
end

--StoreHPAtTurnStart of opponent
function pokeutil.StoreHPAtOppTurnStart(c)
    if not c then return end
    -- Continuous effect: fires at the start of each turn
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)  -- beginning of turn
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
        local tc=e:GetHandler()
        if tc then
			if Duel.GetTurnPlayer() ~= tc:GetControler() then
            local count = tc:GetAttack()
			--clear previous flags
			if tc:GetFlagEffect(pokeutil.STORED_START_TURN_HP_FLAG)>0 then
				tc:ResetFlagEffect(pokeutil.STORED_START_TURN_HP_FLAG)
			end
            -- store the value on the card using a flag with label
            tc:RegisterFlagEffect(pokeutil.STORED_START_TURN_HP_FLAG,RESET_EVENT+RESETS_STANDARD,0,1,count)
			end
        end
    end)
    c:RegisterEffect(e1)
end
--Helper to retrieve the target's stored HP at the start of opponent's turn
function pokeutil.GetStoredOppStartHP(c)
    if not c then return 0 end
    local val = c:GetFlagEffectLabel(pokeutil.STORED_START_TURN_HP_FLAG)
    return val or 0
end

--StoredHPAtEndTurn
function pokeutil.StoredHPAtTurnEnd(c)
	if not c then return end
	-- Continuous effect: fires at the end of each turn
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
        local tc=e:GetHandler()
        if tc then
            local count = tc:GetAttack()
            -- store the value on the card using a flag with label
            tc:RegisterFlagEffect(pokeutil.STORED_END_TURN_HP_FLAG,RESET_EVENT+RESETS_STANDARD,0,1,count)
        end
    end)
    c:RegisterEffect(e1)
end
--helper to retrieve the target's stored HP at the end of turn
function pokeutil.GetStoredEndHP(c)
    if not c then return 0 end
    local val = c:GetFlagEffectLabel(pokeutil.STORED_END_TURN_HP_FLAG)
    return val or 0
end



function pokeutil.InitRetreat(c,id)
	--Retreat
	function pokeutil.retcon(e,tp,eg,ep,ev,re,r,rp)
		-- cannot retreat if the card is asleep (has sleep flag)
		if e:GetHandler():GetFlagEffect(pokeutil.SLEEP_FLAG)>0 then return false end
		if e:GetHandler():GetFlagEffect(pokeutil.PARALYZE_FLAG)>0 then return false end
		return e:GetHandler():GetSequence()>=5
	end
	function pokeutil.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
		local val=e:GetHandler():GetDefense()
		local og=c:GetOverlayGroup():Filter(Card.IsSetCard,nil,0x700)
		if chk==0 then return og:GetCount()>=val end
		Duel.SendtoGrave(og:Select(tp,val,val,nil), REASON_EFFECT)
	end
	function pokeutil.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingTarget(pokeutil.filterM,tp,LOCATION_MZONE,0,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		Duel.SelectTarget(tp,pokeutil.filterM,tp,LOCATION_MZONE,0,1,1,nil)
	end
	function pokeutil.retop(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SwapSequence(tc,e:GetHandler())
		end
	end


	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(100,0))
	e1:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(pokeutil.retcon)
	e1:SetCost(pokeutil.retcost)
	e1:SetTarget(pokeutil.rettg)
	e1:SetOperation(pokeutil.retop)
	c:RegisterEffect(e1)
end


function pokeutil.InitWeakRes(c,raceW,modW,countW,raceR,modR,countR)
	function pokeutil.wcon(e,tp,eg,ep,ev,re,r,rp)
		return c:GetSequence()>=5 and not re:IsHasCategory(CATEGORY_ATKCHANGE)
	end

	function pokeutil.wop(e,tp,eg,ep,ev,re,r,rp)
		local newev=ev;
		local raceW=raceW
		local raceR=raceR
		if c:GetFlagEffect(pokeutil.CHANGE_WEAK_FLAG)>0 then
			raceW=c:GetFlagEffectLabel(pokeutil.CHANGE_WEAK_FLAG)
		end
		if c:GetFlagEffect(pokeutil.CHANGE_RESIST_FLAG)>0 then
			raceR=c:GetFlagEffectLabel(pokeutil.CHANGE_RESIST_FLAG)
		end
		if re:GetHandler():IsRace(raceW) then
			if(modW=="*") then
				for i=2,countW do
					c:AddCounter(0x1300,ev)
					newev=newev+ev
				end
			end
		end
		if(raceR~=nil and re:GetHandler():IsRace(raceR)) then
			if(modR=="-") then 
				if(ev<countR) then
					c:RemoveCounter(tp,0x1300,ev,REASON_ADJUST)
					newev=newev-ev
				else
					c:RemoveCounter(tp,0x1300,countR,REASON_ADJUST)
					newev=newev-countR
				end
			end
		end
		--checks if the pokemon is under Harden like effects
		local counterev=ev;
		if c:GetFlagEffect(pokeutil.IMMUNITY_30_OR_LESS_FLAG)>0 and counterev<=3 then
			c:RemoveCounter(tp,0x1300,counterev,REASON_ADJUST)
		end
		--Defender check
		if c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,999548080) and re:GetHandler()==pokeutil.GetLastDamageUser() then
			if c:GetCounter(0x1300)==1 and c:GetCounter(0x1300)~=re:GetLabel() then
				c:RemoveCounter(tp,0x1300,1,REASON_ADJUST) end
			if c:GetCounter(0x1300)>=2 and c:GetCounter(0x1300)~=re:GetLabel() then
				c:RemoveCounter(tp,0x1300,2,REASON_ADJUST) end
		end
		--PlusPower check
		if re:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,999548084) and re:GetHandler()==pokeutil.GetLastDamageUser() then
			c:AddCounter(0x1300,1)
		end
		Duel.RaiseEvent(c, EVENT_BATTLE_END, re, r, rp, ep, newev)
	end

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADD_COUNTER+0x1300)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetCondition(pokeutil.wcon)
	e2:SetOperation(pokeutil.wop)
	c:RegisterEffect(e2)
end


function pokeutil.InitAtk(c,id,atkNum,ener,dam,condCust,costCust,tgCust,opCust,checkWR)
	function pokeutil.dcon(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetTurnCount()==1  or e:GetHandler():GetSequence()<5 then
			return false
		end
		-- cannot attack if this card is asleep
		if e:GetHandler():GetFlagEffect(pokeutil.SLEEP_FLAG)>0 then return false end
		--cannot attack if this card is paralyzed
		if e:GetHandler():GetFlagEffect(pokeutil.PARALYZE_FLAG)>0 then return false end
		--cannot use the attack if the card is affected by amnesia
		if e:GetHandler():GetFlagEffect(pokeutil.AMNESIA_FLAG)>0 and e:GetHandler():GetFlagEffectLabel(pokeutil.AMNESIA_FLAG)==atkNum then return false end
		--TODO: Add double energy counting here
		local overlay=e:GetHandler():GetOverlayGroup()
		local energroup=overlay:Filter(Card.IsSetCard,nil,0x1700)
		local specenergroup=overlay:Filter(Card.IsSetCard,nil,0x2700)
		local enerrem=ener
		if string.len(enerrem)>(energroup:GetCount()+specenergroup:GetCount())then
			return false;
		end
		enerrem=enerrem:gsub("%N", "")
		local enerstr=""
		local convtable={[999912041]="G",[999912042]="R",[999912043]="W",[999912044]="L",[999912045]="P",
						 [999912046]="F",[999912047]="K",[999912048]="M",[999912049]="Y"}
		for en in energroup:Iter() do
			enerstr=enerstr..convtable[en:GetCode()]
		end
		for c in enerstr:gmatch"." do
			local ind=ener:find(c)
			if ind then
				enerrem=enerrem:sub(1,ind-1)..enerrem:sub(ind+1)
			end
		end

		local auraCount=overlay:FilterCount(Card.IsCode,nil,991204186)
		if enerrem:len()<=auraCount then
			return true
		end
		return false	
	end

	function pokeutil.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
		local temp= Duel.IsExistingMatchingCard(pokeutil.filterEx,tp,0,LOCATION_MZONE,1,nil)
		if(tgCust~=nil) then
			temp = temp and tgCust(e,tp,eg,ep,ev,re,r,rp,chk)
		end
		return temp
	end
--03/feb/26 - added a flag check for atks that makes the card immune to damage
--09/feb/26 - added a check if the pokemon is confused, coin flip to perform the atk or self damage
	function pokeutil.dop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(pokeutil.filterEx,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		local dam=e:GetValue()
		local countersBefore=tc:GetCounter(0x1300)
		if e:GetHandler():GetFlagEffect(pokeutil.CONFUSION_FLAG)>0 then
			if Duel.TossCoin(tp,1)==0 then
				e:GetHandler():AddCounter(0x1300,3)
				return
			end
		end
		if tc and dam>0 and not pokeutil.isCounterImmune(tc) then
			tc:AddCounter(0x1300,e:GetValue())
		end	
		if(opCust~=nil) then
			opCust(e,tp,eg,ep,ev,re,r,rp,g)
		end
		if tc:GetCounter(0x1300)>countersBefore then
		pokeutil.MarkLastDamageUser(e:GetHandler())
		end
		e:SetLabel(countersBefore)
	end


	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,atkNum))
	if checkWR==true or checkWR==nil then
		e3:SetCategory(CATEGORY_DAMAGE)
	else
		e3:SetCategory(CATEGORY_ATKCHANGE)
	end
	e3:SetValue(dam)
	e3:SetType(EFFECT_TYPE_IGNITION)
	if (costCust~=nil) then
		e3:SetCost(costCust)
	end
	if (condCust~=nil) then
		e3:SetCondition(condCust)
	end
    e3:SetCondition(pokeutil.dcon)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(pokeutil.dtg)
	e3:SetOperation(pokeutil.dop)
	c:RegisterEffect(e3)
end

--Resets effects and flags rightaway
function pokeutil.resetNow(c,ef,flagcode)
    if not c then return end
    if ef~=nil and not ef:IsDeleted() then
        Duel.Hint(HINT_CARD,0,c:GetCode())
        ef:Reset()
    end
    if flagcode~=nil then
        c:ResetFlagEffect(flagcode)
    end
end
--Resets effects and flags when card moves [to bench]
function pokeutil.resetEff(c,ef,flagcode)
	if(pokeutil.filterM(c)) then return end
	function pokeutil.mcon(e,tp,eg,ep,ev,re,r,rp)
		return pokeutil.filterM(e:GetHandler()) 
	end
	function pokeutil.mop(e,tp,eg,ep,ev,re,r,rp)
		if ef~=nil and not ef:IsDeleted() then
			Duel.Hint(HINT_CARD,0,c:GetCode())
			ef:Reset()
		end
		if flagcode~=nil then e:GetHandler():ResetFlagEffect(flagcode) end
		e:Reset()
	end

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_MOVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(pokeutil.mcon)
	e4:SetOperation(pokeutil.mop)
	c:RegisterEffect(e4)
end

function pokeutil.energyAttach(c,condCust,costCust,tgCust,opCust)

	function pokeutil.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if(tgCust~=nil) then
			tgCust(e,tp,eg,ep,ev,re,r,rp,chk)
		else
			if chkc then return chkc:IsLocation(LOCATION_MZONE) end
			if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			Duel.SelectTarget(tp,Card.IsFaceUp,tp,LOCATION_MZONE,0,1,1,nil)
		end

	end
	function pokeutil.activate(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))
			if(opCust~=nil) then
				opCust(e,tp,eg,ep,ev,re,r,rp,tc)
			end
		end
		
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	if (costCust~=nil) then
		e1:SetCost(costCust)
	end
	if (condCust~=nil) then
		e1:SetCondition(condCust)
	end
	e1:SetTarget(pokeutil.target)
	e1:SetOperation(pokeutil.activate)
	c:RegisterEffect(e1)

end

function pokeutil.toolAttach(c,condCust,costCust,tgCust,opCust)

	function pokeutil.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if(tgCust~=nil) then
			tgCust(e,tp,eg,ep,ev,re,r,rp,chk)
		else
			if chkc then return chkc:IsLocation(LOCATION_MZONE) end
			if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(pokeutil.toolfilt,tp,LOCATION_MZONE,0,1,nil) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			Duel.SelectTarget(tp,pokeutil.toolfilt,tp,LOCATION_MZONE,0,1,1,nil)
		end

	end
	function pokeutil.activate(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))
			if(opCust~=nil) then
				opCust(e,tp,eg,ep,ev,re,r,rp)
			end
		end
		
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	if (costCust~=nil) then
		e1:SetCost(costCust)
	end
	if (condCust~=nil) then
		e1:SetCondition(condCust)
	end
	e1:SetTarget(pokeutil.target)
	e1:SetOperation(pokeutil.activate)
	c:RegisterEffect(e1)

end

--05/feb/26 - Evolution function
-- c=the evolution card (in hand) | id =its card ID | prevStage = the card ID of the basic it evolves from
function pokeutil.InitStage(c,id,prevStage)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    --e1:SetCountLimit(1,id)

    -- condition: must have correct base on field for >=1 turn
    e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
        return Duel.IsExistingMatchingCard(pokeutil.stageFilter,tp,LOCATION_MZONE,0,1,nil,prevStage)
    end)
    -- target: select the base Pokémon
    e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then
            return Duel.IsExistingMatchingCard(pokeutil.stageFilter,tp,LOCATION_MZONE,0,1,nil,prevStage)
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local g=Duel.SelectMatchingCard(tp,pokeutil.stageFilter,tp,LOCATION_MZONE,0,1,1,nil,prevStage)
        if #g>0 then
            e:SetLabelObject(g:GetFirst())
            Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
        end
    end)
    -- operation: evolve (if base is in the extra monster zone, move it to a free main zone before summoning, if no free main zone, swap it with a main zone monster then summon and then swap again)
    e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
        local c=e:GetHandler()
        local base=e:GetLabelObject()
		local prevDam=base:GetCounter(0x1300)
        if not base or not c:IsRelateToEffect(e) then return end
        local seq=base:GetSequence()
		local zone = 1 << seq
        -- summon evolution into a main zone
        if base and seq<5 then
			-- transfer attachments
            local mat=Group.CreateGroup()
            mat:Merge(base:GetOverlayGroup())
            mat:AddCard(base)
            c:SetMaterial(mat)
			Duel.Overlay(c,mat,false)
			if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK,zone)~=0 then
				if prevDam>0 then
                c:AddCounter(0x1300,prevDam)
            	end
			end
		else
			--Alt for summoning when base is in extra monster zone
			-- find a free main monster zone
			local freeZone = pokeutil.GetFirstEmptyMainZone(tp)
			if freeZone~=nil then
				--local freeZone=math.log(freeZone,2)

				-- move base to free main zone
				Duel.MoveSequence(base,freeZone)
				-- transfer attachments
				local mat=Group.CreateGroup()
				mat:Merge(base:GetOverlayGroup())
				mat:AddCard(base)
				c:SetMaterial(mat)
				Duel.Overlay(c,mat,false)
				if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK,1<<freeZone)~=0 then
					if prevDam>0 then
					c:AddCounter(0x1300,prevDam)
					end
					Duel.MoveSequence(c,5) -- move back to extra monster zone
				end
			else
				-- no free main zone, swap with a random main zone monster
				local g=Duel.GetMatchingGroup(Card.IsMonster,tp,LOCATION_MZONE,0,nil)
				local swapMonster=g:GetFirst()

				--local swapMonster=g:RandomSelect(tp,1):GetFirst()
				if swapMonster~=nil then
					Duel.SwapSequence(swapMonster,base)
					local baseSeq=base:GetSequence()
					-- transfer attachments
					local mat=Group.CreateGroup()
					mat:Merge(base:GetOverlayGroup())
					mat:AddCard(base)
					c:SetMaterial(mat)
					Duel.Overlay(c,mat,false)
					if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK,1<<baseSeq)~=0 then
						if prevDam>0 then
						c:AddCounter(0x1300,prevDam)
						end
						Duel.SwapSequence(c,swapMonster) -- move back to extra monster zone
					end
				end
			end
        end
    end)

    c:RegisterEffect(e1)
end

-- helper filter: correct base Pokémon and must have been on field for >=1 turn
function pokeutil.stageFilter(c,prevStage)
    return c:IsFaceup()
        and c:IsCode(prevStage)
        and c:GetTurnID() < Duel.GetTurnCount()
end




function pokeutil.stadcon(e,tp,eg,ep,ev,re,r,rp)
	function pokeutil.stadfilt(c)
		return c:IsCode(e:GetHandler():GetCode()) 
	end
    return Duel.GetMatchingGroupCount(pokeutil.stadfilt,tp, LOCATION_FZONE, LOCATION_FZONE,nil)==0
end

-- returns the sequence index (0–4) of the first empty main monster zone, or nil if all are occupied
function pokeutil.GetFirstEmptyMainZone(tp)
    for i=0,4 do
        if Duel.GetFieldCard(tp, LOCATION_MZONE, i)==nil then
            return i
        end
    end
    return nil
end

--Filter to get pokemons on the bench
function pokeutil.filterM(c)
	return c:GetSequence()<5
end
--Filter to get pokemons in the active spot
function pokeutil.filterEx(c)
	return c:GetSequence()>=5
end
function pokeutil.toolfilt(c)
	return c:GetOverlayGroup():FilterCount(Card.IsSetCard,nil,0x720)==0
end
return pokeutil