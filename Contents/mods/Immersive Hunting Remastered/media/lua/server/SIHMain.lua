function DropTraceSmall(player, character)
		local inv = player:getInventory();
		local trace = inv:getFirstTypeRecurse("SIHTraceSmall");
		if trace then
			local playerItem = {}
			local BagItem    = {}
			local items2 = getPlayer():getInventory():getItems();

        for i=1, items2:size() do
            if items2:get(i-1).getItemContainer ~= nil then
                innercontainer = items2:get(i-1):getItemContainer():getItems()
                if items2:get(i-1):getItemContainer():getFirstTypeRecurse("SIHTraceSmall") then
                    items2:get(i-1):getItemContainer():Remove("SIHTraceSmall")
                end
                for q=0, innercontainer:size() - 1 do
                    table.insert(BagItem,innercontainer:get(q):getType())
                end
            end
            table.insert(playerItem,items2:get(i-1):getType())
        end

        local itemString = table.concat(playerItem, ",")
        local bagString = table.concat(BagItem, ",")

        print(bagString)
		
		local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHTrackSmall");
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		inv:Remove('SIHTraceSmall');
		
		end
end

function DropTraceBig(player, character)
		local inv = player:getInventory();
		local trace = inv:getFirstTypeRecurse("SIHTraceBig");
		if trace then
			local playerItem = {}
			local BagItem    = {}
			local items2 = getPlayer():getInventory():getItems();

        for i=1, items2:size() do
            if items2:get(i-1).getItemContainer ~= nil then
                innercontainer = items2:get(i-1):getItemContainer():getItems()
                if items2:get(i-1):getItemContainer():getFirstTypeRecurse("SIHTraceBig") then
                    items2:get(i-1):getItemContainer():Remove("SIHTraceBig")
                end
                for q=0, innercontainer:size() - 1 do
                    table.insert(BagItem,innercontainer:get(q):getType())
                end
            end
            table.insert(playerItem,items2:get(i-1):getType())
        end

        local itemString = table.concat(playerItem, ",")
        local bagString = table.concat(BagItem, ",")

        print(bagString)
		
		local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHTrackBig");
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		inv:Remove('SIHTraceBig');
		
		end
end

function DropBirdSighting(player, character)
		local inv = player:getInventory();
		local trace = inv:getFirstTypeRecurse("SIHSpottedBird");
		if trace then
			local playerItem = {}
			local BagItem    = {}
			local items2 = getPlayer():getInventory():getItems();

        for i=1, items2:size() do
            if items2:get(i-1).getItemContainer ~= nil then
                innercontainer = items2:get(i-1):getItemContainer():getItems()
                if items2:get(i-1):getItemContainer():getFirstTypeRecurse("SIHSpottedBird") then
                    items2:get(i-1):getItemContainer():Remove("SIHSpottedBird")
                end
                for q=0, innercontainer:size() - 1 do
                    table.insert(BagItem,innercontainer:get(q):getType())
                end
            end
            table.insert(playerItem,items2:get(i-1):getType())
        end

        local itemString = table.concat(playerItem, ",")
        local bagString = table.concat(BagItem, ",")

        print(bagString)
		
		local item = InventoryItemFactory.CreateItem("ImmersiveHunting.SIHTrackBird");
		getPlayer():getCurrentSquare():AddWorldInventoryItem(item, 0, 0, 0);
		inv:Remove('SIHSpottedBird');
		
		end
end

function SIHOneMinuteDropThatBeat()
    for playerIndex = 0, getNumActivePlayers()-1 do
        local player = getSpecificPlayer(playerIndex);
		if not getPlayer() then return end
		if getPlayer():getHoursSurvived() > 0.005 then
		DropTraceSmall(player, character);
		DropTraceBig(player, character);
		DropBirdSighting(player, character);
		end
    end
end
Events.EveryOneMinute.Add(SIHOneMinuteDropThatBeat);
