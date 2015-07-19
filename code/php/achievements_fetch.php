<?php

/*
 * Fetch user's Steam achievements and process stats as CSV
 */

$apiKey = @$argv[1] ? : exit;
$steamId = @$argv[2] ? : exit;

$gameListRaw = @file_get_contents(sprintf('http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=%s&steamid=%s&include_played_free_games=1', $apiKey, $steamId));

if ($gameListRaw) {
    $gameListParsed = json_decode($gameListRaw);

    if (isset($gameListParsed->response->games)) {
        $gameList = $gameListParsed->response->games;

        $index = 1;
        fputcsv(STDOUT, [
            'gameName',
            'achievementCountUnlocked',
            'achievementCountAvailable',
            'achievementCountRemaining',
            'achievementUnlockRate'
        ]);

        foreach ($gameList as $game) {
            if ($game->playtime_forever) {
                $achievementListRaw = @file_get_contents(sprintf('http://api.steampowered.com/ISteamUserStats/GetPlayerAchievements/v0001/?key=%s&steamid=%s&appid=%d', $apiKey, $steamId, $game->appid));

                if ($achievementListRaw) {
                    $achievementListParsed = json_decode($achievementListRaw);

                    if (isset($achievementListParsed->playerstats->achievements)) {
                        $achievementList = $achievementListParsed->playerstats->achievements;

                        $achievementCountUnlocked = 0;
                        $achievementCountAvailable = count($achievementList);

                        foreach ($achievementList as $achievement) {
                            if ($achievement->achieved) {
                                ++$achievementCountUnlocked;
                            }
                        }

                        if ($achievementCountUnlocked) {
                            ++$index;
                            fputcsv(STDOUT, [
                                $achievementListParsed->playerstats->gameName,
                                $achievementCountUnlocked,
                                $achievementCountAvailable,
                                sprintf('=C%d-B%d', $index, $index),
                                sprintf('=B%d/C%d', $index, $index)
                            ]);
                        }
                    }
                }
            }
        }
    }
}
