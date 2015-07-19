<?php

/*
 * Extracts game history from a Game Dev Tycoon save
 */

function weekToDate($weeks)
{
    $dWeek = $weeks % 4;
    $dMonth = floor($weeks / 4 % 12);
    $dYear = floor($weeks / 4 / 12);
    return sprintf("Y%02d M%02d W%d", $dYear, $dMonth, $dWeek);
}

$file = @$argv[1] ? : exit;
$saveStruct = json_decode(file_get_contents($file));
$engines = $saveStruct->company->engines;
$games = $saveStruct->company->gameLog;
$processedGames = [];

fputcsv(STDOUT, [
    'GUID',
    'Title',
    'Genre',
    'Second Genre',
    'Topic',
    'Size',
    'Audience',
    'Engine',
    'Hype',
    'Score',
    'Bugs',
    'Initial Rank',
    'Top Rank',
    'Release Date',
    'Costs',
    'Sales',
    'Amount Sold',
    'New Fans'
]);

foreach ($games as $id => $game) {
    $processedGames[$id] = [];
    $processedGames[$id]['id'] = $game->id;
    $processedGames[$id]['title'] = $game->title;
    $processedGames[$id]['genre'] = $game->genre;
    $processedGames[$id]['secondGenre'] = isset($game->secondGenre) ? $game->secondGenre : '';
    $processedGames[$id]['topic'] = $game->topic;
    $processedGames[$id]['gameSize'] = $game->gameSize;
    $processedGames[$id]['targetAudience'] = $game->targetAudience;
    $processedGames[$id]['engine_id'] = isset($game->engine_id) ? $engines[$game->engine_id - 1]->name : '';
    $processedGames[$id]['hypePoints'] = round($game->hypePoints);
    $processedGames[$id]['score'] = number_format($game->score, 2, ',', '');
    $processedGames[$id]['bugs'] = $game->bugs;
    $processedGames[$id]['initialSalesRank'] = ($game->initialSalesRank != -1) ? $game->initialSalesRank : '';
    $processedGames[$id]['topSalesRank'] = ($game->topSalesRank != -1) ? $game->topSalesRank : '';
    $processedGames[$id]['releaseDate'] = weekToDate($game->releaseWeek);
    $processedGames[$id]['costs'] = round($game->costs);
    $processedGames[$id]['totalSales'] = round($game->totalSales);
    $processedGames[$id]['amountSold'] = round($game->amountSold);
    $processedGames[$id]['fansChanged'] = round($game->fansChanged);
    fputcsv(STDOUT, $processedGames[$id]);
}
