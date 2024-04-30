Q1 - Fix or improve the implementation of the below methods

function onLogout(player)
	if player:getStorageValue(1000) == 1 then
		player:setStorageValue(1000, -1) -- My approach to improve this method was to remove
	end									 -- the first function, as it would be faster to just
	return true							 -- set the storagevalue of the player on the onLogout.
end										 -- I had my doubts about putting it on the addEvent
										 -- it would bug somehow if the player fast relloged
										 -- or if he was offline when the function happened, so removing it was to prevent that aswell

Q2 - Fix or improve the implementation of the below method

function printSmallGuildNames(memberCount)
	local selectGuildQuery = db.storeQuery("SELECT 'name' FROM 'guilds' WHERE 'max_members' < "..membercount)
	local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount)) -- On this one I first corrected the writting of the storeQuery.
	local guildName = result.getString("name")									 -- The rest didn't seem to be wrong, so I just added the
	print(guildName) 															 -- result.free that was missing, so It can store future results.
	result.free(resultId)
end


Q3 - Fix or improve the name and the implementation of the below method

function removePlayerPartyMember(playerId, membername)
	player = Player(playerId)
	local party = player:getParty()
												-- On this one, he was comparing V, that is a player, with the Player(membername),
	for k,v in pairs(party:getMembers()) do		-- but this function gets the player by the id, not the name, so I switched and compared the name of v
		if v:getName() == membername then		-- with the membername that the functions receives from the call. I also break after finding the member with the name that was input
			party:removeMember(v)				-- to prevent any bug or unnecessary checks of the For.
			break
		end
	end
end

Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
	Player* player = g_game.getPlayerByName(recipient); -- This Q4 was kind of tricky, and I assume that I'm not 100% sure about when to delete the pointers
	if (!player) 										-- and everybody I asked and every reference I found about it was unsure about the best way to prevent the leak.
	{
		player = new Player(nullptr);
		if (!IOLoginData::loadPlayerByName(player, recipient)) 
		{
			delete player;								-- So starting with the basics, in case he couldn't load the player in this if
			return;										-- I delete the pointer to avoid memory usage.
		}
	}

Item* item = Item::CreateItem(itemId);
	if (!item) 
	{
		delete player;              -- In case the itemId is invalid and he doesn't create the item, I delete the player for the same reason above
		delete item;				-- and also delete the item, because I was unsure that if the item being null was sufficient to not delete the pointer
		return;						-- so just in case, I deleted it to prevent.
	}

	g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

	if (player->isOffline()) 
	{
		IOLoginData::savePlayer(player);
	}
	delete player;      -- If everything went ok and he delivered the item to the existing or created player, I delete the pointers to
	delete item;        -- deallocate the memory and prevent any kind of leak, but I'm not a hundred percent sure if it's necessary to be honest. The same about deleting the item in the previous If, since he was null.
}





