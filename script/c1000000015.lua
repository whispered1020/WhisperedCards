-- Racnel, the Ghoti Swarm
local s,id=GetID()
function s.initial_effect(c)
-- Efeito 1: Se esta carta for banida, adicione 1 "The Most Distant, Deepest Depths" do Deck ou banimento à mão
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(id,0))
e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e1:SetProperty(EFFECT_FLAG_DELAY)
e1:SetCode(EVENT_REMOVE)
e1:SetCountLimit(1,id)
e1:SetTarget(s.thtg)
e1:SetOperation(s.thop)
c:RegisterEffect(e1)

-- Efeito 2: Registra quando esta carta é banida para se Invocar na próxima Standby Phase
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
e2:SetCode(EVENT_REMOVE)
e2:SetOperation(s.regop)
c:RegisterEffect(e2)

-- Efeito 3: Quick Effect na Main Phase do oponente (se Invocado por Invocação-Especial neste turno) para Synchro Peixe
local e3=Effect.CreateEffect(c)
e3:SetDescription(aux.Stringid(id,2))
e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
e3:SetType(EFFECT_TYPE_QUICK_O)
e3:SetCode(EVENT_FREE_CHAIN)
e3:SetRange(LOCATION_MZONE)
e3:SetHintTiming(0,TIMING_MAIN_END)
e3:SetCountLimit(1,{id,2})
e3:SetCondition(s.sccon)
e3:SetTarget(s.sctg)
e3:SetOperation(s.scop)
c:RegisterEffect(e3)
end
s.listed_names={8794055} -- ID oficial de "The Most Distant, Deepest Depths"

-- Lógica do Efeito 1 (Buscar/Recuperar "The Most Distant, Deepest Depths")
function s.thfilter(c)
return c:IsCode(8794055) and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
	end
	function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
		end

		-- Lógica do Efeito 2 (Retornar na próxima Standby Phase após ser banido)
		function s.regop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1,{id,1})
		e1:SetCondition(s.spcon)
		e1:SetTarget(s.sptg)
		e1:SetOperation(s.spop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		e1:SetLabel(Duel.GetTurnCount())
		c:RegisterEffect(e1)
		end
		function s.spcon(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetTurnCount()==e:GetLabel()+1
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

				-- Lógica do Efeito 3 (Quick Synchro de Peixe se Invocado Especialmente neste turno)
				function s.sccon(e,tp,eg,ep,ev,re,r,rp)
				return Duel.IsTurnPlayer(1-tp) and Duel.IsMainPhase()
				and e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
				end
				function s.scfilter(c,mc)
				return c:IsRace(RACE_FISH) and c:IsSynchroSummonable(mc)
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
