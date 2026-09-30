--Metaphys Executor Prime
--Scripted by: Pedroribeiro
--Revised by: Whispered
local s,id=GetID()
function s.initial_effect(c)
--Requerimentos de Sincronia: 1 ou mais Tuners + "Metaphys Executor"
Synchro.AddProcedure(c,nil,1,99,Synchro.NonTuner(s.matfilter),1,1)
c:EnableReviveLimit()
-- Efeito 1: Efeito Rápido para banir 1 monstro do campo e Invocar Metaphys do banimento
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(id,0))
e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
e1:SetType(EFFECT_TYPE_QUICK_O)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetRange(LOCATION_MZONE)
e1:SetCountLimit(1,id) -- Hard Once Per Turn (Efeito 1)
e1:SetCondition(s.spcon) -- Condição: Oponente precisa controlar cartas
e1:SetCost(s.spcost)
e1:SetTarget(s.sptg)
e1:SetOperation(s.spop)
c:RegisterEffect(e1)
-- Efeito 2: Durante a End Phase, bane 1 monstro Metaphys do Deck
local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(id,1))
e2:SetCategory(CATEGORY_REMOVE)
e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) -- Ativação obrigatória
e2:SetCode(EVENT_PHASE+PHASE_END)
e2:SetRange(LOCATION_MZONE)
e2:SetCountLimit(1,id+100) -- Hard Once Per Turn (Efeito 2)
e2:SetTarget(s.bndtg)
e2:SetOperation(s.bndop)
c:RegisterEffect(e2)
-- Efeito 3: Se esta carta for banida, embaralha monstros do GY/Banimento para se Auto-Invocar
local e3=Effect.CreateEffect(c)
e3:SetDescription(aux.Stringid(id,2))
e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
e3:SetCode(EVENT_REMOVE)
e3:SetCountLimit(1,id+200) -- Hard Once Per Turn (Efeito 3)
e3:SetTarget(s.sretg)
e3:SetOperation(s.sreop)
c:RegisterEffect(e3)
end

-- --- Filtro do Material Não-Tuner específico ("Metaphys Executor") ---
function s.matfilter(c,scard,sumtype,tp)
return c:IsCode(45148985)
end

-- --- LÓGICA DO EFEITO 1 (Efeito Rápido de Invocação) ---
-- Condição estilo Cyber Dragon: Conta se o número de cartas do oponente no campo é maior que 0
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	function s.spfilter(c,e,tp)
	return c:IsSetCard(0x105) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
		end
		function s.spop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
				end

				-- --- LÓGICA DO EFEITO 2 (Banir do Deck na End Phase) ---
				function s.bndfilter(c)
				return c:IsSetCard(0x105) and c:IsMonster() and c:IsAbleToRemove()
				end
				function s.bndtg(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return true end
					Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
					end
					function s.bndop(e,tp,eg,ep,ev,re,r,rp)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local g=Duel.SelectMatchingCard(tp,s.bndfilter,tp,LOCATION_DECK,0,1,1,nil)
					if g:GetCount()>0 then
						Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
						end
						end

						-- --- LÓGICA DO EFEITO 3 (Efeito ao ser Banido) ---
						function s.tdfilter(c)
						return c:IsMonster() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:HasLevel() and not c:IsCode(id) and c:IsAbleToDeck()
						end
						function s.sretg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
						if chkc then return false end
							local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
							if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
								and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
								and g:CheckWithSumEqual(Card.GetLevel,12,1,99) end

								Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
								local sg=g:SelectWithSumEqual(tp,Card.GetLevel,12,1,99)
								Duel.SetTargetCard(sg)

								Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
								Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
								end
								function s.sreop(e,tp,eg,ep,ev,re,r,rp)
								local c=e:GetHandler()
								local tg=Duel.GetTargetCards(e)
								if tg:GetCount()==0 then return end

									Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
									local g=Duel.GetOperatedGroup()
									local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)

									if ct>0 and c:IsRelateToEffect(e) then
										Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
										end
										end
