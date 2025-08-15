print("[InfiniteAmmo] Loaded!")

local AMMO_REGAIN_AMOUNT = 10	-- Count, Add how many of ammo for each TICK_PER_TIME
local TICK_PER_TIME = 100		-- Millisecond, Usually doesnt need to change

local PlayerCharacterTracker = {}

ExecuteWithDelay(2000, function()
	RegisterHook("/FPSController/Blueprints/BP_FPSCharacter.BP_FPSCharacter_C:ReceivePossessed", function(FPSCharacter, Controller)
		local FPSCharacterObj = FPSCharacter:get()
		if not FPSCharacterObj:IsPlayerControlled() then
			return
		end
	
		PlayerCharacterTracker[FPSCharacterObj.PlayerState.PlayerID] = FPSCharacterObj
	end)
end)

LoopAsync(TICK_PER_TIME, function()
	ExecuteInGameThread(function()
		for ID, FPSCharacter in pairs(PlayerCharacterTracker) do
			if not FPSCharacter:IsValid() then
				PlayerCharacterTracker[ID] = nil
			end

			local AFPSItem = FPSCharacter.EquippedItem
			if not AFPSItem:IsValid() then
				goto continue
			end

			if not AFPSItem:CanAddAmmo(AMMO_REGAIN_AMOUNT) then
				goto continue
			end

			AFPSItem:AddAmmo(false, AMMO_REGAIN_AMOUNT)
			AFPSItem:ServerCheckAmmo()
			AFPSItem.Delay = 0.0

			::continue::
		end
	end)
end)
