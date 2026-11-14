-- Raylebe, Beacon of the Ghoti
local s,id=GetID()
function s.initial_effect(c)
-- Efeito 1: Durante a Main Phase (Efeito Rápido), bana 1 monstro Peixe da mão ou Cemitério para Invocar esta carta da mão
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(id,0))
e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
e1:SetType(EFFECT_TYPE_QUICK_O)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetRange(LOCATION_HAND)
e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
e1:SetCountLimit(1,id)
e1:SetCondition(function() return Duel.IsMainPhase() end)
e1:SetCost(s.spcost)
e1:SetTarget(s.sptg)
e1:SetOperation(s.spop)
c:RegisterEffect(e1)

-- Efeito 2: Efeito Rápido na Main Phase do oponente para realizar Invocação-Sincro usando esta carta
local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(id,1))
e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
e2:SetType(EFFECT_TYPE_QUICK_O)
e2:SetCode(EVENT_FREE_CHAIN)
e2:SetRange(LOCATION_MZONE)
e2:SetHintTiming(0,TIMING_MAIN_END)
e2:SetCountLimit(1,{id,1})
e2:SetCondition(s.sccon)
e2:SetTarget(s.sctg)
e2:SetOperation(s.scop)
c:RegisterEffect(e2)

-- Efeito 3: Pode ser tratado como Regulador para a Invocação-Sincro de um monstro Peixe
local e3=Effect.CreateEffect(c)
e3:SetType(EFFECT_TYPE_SINGLE)
e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
e3:SetCode(EFFECT_CAN_BE_TUNER)
e3:SetRange(LOCATION_MZONE)
e3:SetValue(s.tnval)
c:RegisterEffect(e3)

-- Efeito 4: Registra quando esta carta é banida para se adicionar à mão na próxima Standby Phase
local e4=Effect.CreateEffect(c)
e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
e4:SetCode(EVENT_REMOVE)
e4:SetOperation(s.regop)
c:RegisterEffect(e4)
end

-- Lógica do Efeito 1 (Quick Effect na Main Phase: banir Peixe da mão/GY para entrar da mão)
function s.cfilter(c)
return c:IsRace(RACE_FISH) and c:IsAbleToRemoveAsCost()
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		end
		function s.spop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
			end

			-- Lógica do Efeito 2 (Quick Synchro na Main Phase do oponente)
			function s.sccon(e,tp,eg,ep,ev,re,r,rp)
			return Duel.IsTurnPlayer(1-tp) and Duel.IsMainPhase()
			end
			function s.scfilter(c,mc)
			return c:IsSynchroSummonable(mc)
			end
			function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
			if chk==0 then return Duel.IsExistingMatchingCard(s.scfilter,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
				end
				function s.scop(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
					local g=Duel.GetMatchingGroup(s.scfilter,tp,LOCATION_EXTRA,0,nil,c)
					if #g>0 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
						local sg=g:Select(tp,1,1,nil)
						Duel.SynchroSummon(tp,sg:GetFirst(),c)
						end
						end

						-- Lógica do Efeito 3 (Pode ser tratado como Regulador apenas para Synchro Peixe)
						function s.tnval(e,c)
						return c:IsRace(RACE_FISH)
						end

						-- Lógica do Efeito 4 (Adicionar à mão na próxima Standby Phase após ser banido)
						function s.regop(e,tp,eg,ep,ev,re,r,rp)
						local c=e:GetHandler()
						local e1=Effect.CreateEffect(c)
						e1:SetDescription(aux.Stringid(id,2))
						e1:SetCategory(CATEGORY_TOHAND)
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
						e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
						e1:SetRange(LOCATION_REMOVED)
						e1:SetCountLimit(1,{id,2})
						e1:SetCondition(s.thcon)
						e1:SetTarget(s.thtg)
						e1:SetOperation(s.thop)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
						e1:SetLabel(Duel.GetTurnCount())
						c:RegisterEffect(e1)
						end
						function s.thcon(e,tp,eg,ep,ev,re,r,rp)
						return Duel.GetTurnCount()==e:GetLabel()+1
						end
						function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
						local c=e:GetHandler()
						if chk==0 then return c:IsAbleToHand() end
							Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
							end
							function s.thop(e,tp,eg,ep,ev,re,r,rp)
							local c=e:GetHandler()
							if c:IsRelateToEffect(e) then
								Duel.SendtoHand(c,nil,REASON_EFFECT)
								Duel.ConfirmCards(1-tp,c)
								end
								end
