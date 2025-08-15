print("[InfiniteAmmo] Loaded!")

local TIME_PER_TICK = 1000		-- Millisecond, How many of milliseconds we do a check and modify, usually doesnt need to change

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

LoopAsync(TIME_PER_TICK, function()
	ExecuteInGameThread(function()
		for ID, FPSCharacter in pairs(PlayerCharacterTracker) do
			if not FPSCharacter:IsValid() then
				PlayerCharacterTracker[ID] = nil
			end

			local FPSRangedWeapon = FPSCharacter.EquippedItem
			if not FPSRangedWeapon:IsValid() then
				goto continue
			end

			FPSRangedWeapon.Magazines = {32767,32767}
			FPSRangedWeapon.CurrentAmmo = 32767

			::continue::
		end
	end)
end)
