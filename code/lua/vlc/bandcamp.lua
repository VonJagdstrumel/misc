--[[
  $Id$

  Translate Bandcamp audio webpages URLs to the corresponding MP3 URL.
  Put this script into "VLCPATH/lua/playlist".
  Open a network URL like "http://droidbishop.bandcamp.com/track/exodus".

  Copyright © 2014 Steve Forget

  Authors: Steve A. Forget (http://www.behindtheshell.fr/)

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston MA 02110-1301, USA.
--]]

function unescape(str)
  str = string.gsub(str, '&lt;', '<')
  str = string.gsub(str, '&gt;', '>')
  str = string.gsub(str, '&quot;', '"')
  str = string.gsub(str, '&apos;', "'")
  str = string.gsub(str, '&#(%d+);', function(n) return string.char(n) end)
  str = string.gsub(str, '&amp;', '&')
  return str
end

function probe()
  return vlc.access == "http" and string.match(vlc.path, "%.bandcamp%.com/track/.+")
end

function parse()
  if string.match(vlc.path, "%.bandcamp%.com/track/.+") then
    while true do
      line = vlc.readline()
      if not line then break end

      if string.match(line, "trackinfo:") then
        _, _, path = string.find(line, "\"mp3%-128\":\"([^\"]+)\"")
        _, _, name = string.find(line, "\"title\":\"([^\"]*)\"")
        name = unescape(name)
        _, _, duration = string.find(line, "\"duration\":([^%.]*)")
      end

      if string.match(line, "artist:") then
        _, _, artist = string.find(line, "artist: \"([^\"]*)\"")
        artist = unescape(artist)
      end

      if string.match(line, "album_title :") then
        _, _, album = string.find(line, "album_title : \"([^\"]*)\"")
        album = unescape(album)
      end

      if string.match(line, "artFullsizeUrl:") then
        _, _, arturl = string.find(line, "artFullsizeUrl: \"([^\"]*)\"")
      end
    end

    _, _, url = vlc.access .. "://" .. vlc.path

    return { { path = path; name = name; title = name; artist = artist; album = album; url = url; arturl = arturl; duration = duration } }
  end

  return {}
end
