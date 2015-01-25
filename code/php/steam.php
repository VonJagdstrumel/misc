<?php

/*
 * List all the games from a public Steam account using SteamAPI
 * Set up SteamAPI key
 * Call with 'steamId' GET parameter
 */

function compareByName($a, $b)
{
    return strcmp($a->name, $b->name);
}

$steamApiKey = '';
$steamId = !empty($_GET['steamId']) ? $_GET['steamId'] : exit;
$dataWrapper = json_decode(file_get_contents("http://api.steampowered.com/IPlayerService/GetOwnedGames/v0001/?key=$steamApiKey&steamid=$steamId&include_appinfo=1"));
usort($data->response->games, 'compareByName');
?>
<!DOCTYPE html>
<html lang="fr">
    <head>
        <title><?= $data->response->game_count ?> game<?= ($data->response->game_count > 1) ? 's' : '' ?>!</title>
        <meta charset="utf-8">
        <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:900' rel='stylesheet' type='text/css'>
        <style>
            body {
                text-align: center;
                font-family: sans-serif;
                font-size: 10pt;
            }

            a:link, a:visited, a:hover, a:active {
                color: black;
            }

            a:link, a:visited {
                text-decoration: none;
            }

            a:hover, a:active {
                text-decoration: underline;
            }

            body > div {
                font-family: 'Source Sans Pro';
                font-weight: 900;
                font-size: 30pt;
            }

            body > div span {
                font-size: 40pt;
                padding: 0 10px;
                border-radius: 20px;
                border: 1px gainsboro solid;
                background-color: whitesmoke;
            }

            ul {
                list-style-type: none;
                padding: 0;
            }

            ul li {
                overflow: hidden;
                float: left;
                margin: 10px;
                border-radius: 10px;
                border: 1px silver solid;
                background-color: gainsboro;
            }

            ul li a {
                display: block;
                width: 184px;
                padding: 10px;
            }

            ul li a div.logo {
                height: 69px;
            }

            ul li a div.name {
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                height: 1em;
                line-height: 1em;
                padding-bottom: 1px;
                margin-top: 5px;
            }
        </style>
    </head>
    <body>
        <div>Yaw, dis niggah haz about <span><?= $data->response->game_count ?></span> game<?= ($data->response->game_count > 1) ? 's' : '' ?>!</div>
        <ul>
            <?php
            foreach ($data->response->games as $entry):
                ?>
                <li><a href="http://store.steampowered.com/app/<?= $entry->appid ?>">
                    <div class="logo"><img src="<?= !empty($entry->img_logo_url) ? "http://media.steampowered.com/steamcommunity/public/images/apps/{$entry->appid}/{$entry->img_logo_url}.jpg" : 'http://image.noelshack.com/fichiers/2014/27/1404413805-trollface.png' ?>" alt="<?= $entry->name ?>"></div>
                    <div class="name"><?= $entry->name ?></div>
                </a></li>
                <?php
            endforeach;
            ?>
        </ul>
    </body>
</html>