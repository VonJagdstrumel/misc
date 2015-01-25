local http = require('socket.http')
require('io')
require('date')
-- Requires http://lua-users.org/wiki/SortedIteration
dofile('orderedPairs.lua')

function string:split(sep)
  local sep, fields = sep or ' ', {}
  local pattern = string.format('([^%s]+)', sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

function trim(str)
  return string.gsub(str, '^%s*(.-)%s*$', '%1')
end

if #arg < 1 or #arg > 2 then
  print('usage: ' .. arg[0] .. ' group [ week ]')
  os.exit(1)
end

local woy = (arg[2] or os.date('%U')) + 0 -- %W for a week with Monday as first day
local week = {} -- Week array
local localFile = './basic.ics' -- Local cache file
local pageContent = http.request('http://gestionedt.emploisdutempssrc.net/edt/ical/INFO/' .. arg[1] .. '/basic.ics') -- Get data
local fileHandler = io.open(localFile, 'w') -- Open local file in write mode
fileHandler:write(pageContent) -- Put data to cache
fileHandler:close() -- Close local file

for line in io.lines(localFile) do -- For each line of local file
  splittedLine = trim(line):split(':') -- Split line onto ':'

  if string.find(line, '^BEGIN:VEVENT') then
    event = {} -- Check event block start
  elseif string.find(line, '^DTSTART;') then
    event[1] = date(splittedLine[2]) -- Get begining date
  elseif string.find(line, '^DTEND;') then
    event[2] = date(splittedLine[2]) -- Get end date
  elseif string.find(line, '^SUMMARY:') then
    event[3] = trim(splittedLine[2]) -- Get description
  elseif string.find(line, '^END:VEVENT') then -- Check event block end
    eDate = date(event[1]) -- Parse begining date

    if eDate:getisoweeknumber() == woy then -- Keep only if 
      dow = eDate:getisoweekday() -- Get week number
      if week[dow] == nil then
        week[dow] = {} -- Insert new day array in week
      end
      table.insert(week[dow], event) -- Insert event in day
    end
  end
end

if #week == 0 then -- Test if week is empty
  print('Week ' .. woy .. ' not found!')
  os.exit(2)
end

for _, weekDay in orderedPairs(week) do -- For each day
  table.sort(weekDay, function(a, b) return a[1]:fmt('%H:%M') < b[1]:fmt('%H:%M') end) -- Order events by time
  print(weekDay[1][1]:fmt('%A %d %B')) -- Print day
  for _, dayEvent in pairs(weekDay) do -- For each event that day
    print("\t" .. dayEvent[1]:fmt('%H:%M') .. " - " .. dayEvent[2]:fmt('%H:%M') .. " : " .. dayEvent[3]) -- Print it
  end
  print() -- Print new line
end
