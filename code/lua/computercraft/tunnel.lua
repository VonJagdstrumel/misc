-- WARNING: Not finished yet
-- Slot 1 = coal
-- Slot 2 = chest
-- Slot 3 = torch

local tArgs = { ... }
if #tArgs ~= 2 then
    print("Usage: tunnel <length> <rows>")
    return
end

local length = tonumber(tArgs[1])
if length < 1 then
    print("Length must be positive")
    return
end

local rows = tonumber(tArgs[2])
if rows < 1 then
    print("Rows must be positive")
    return
end

local direction = false

local function refuel()
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel == "unlimited" or fuelLevel > 0 then
        return -- No need to refuel
    end

    local function tryRefuel()
        turtle.select(1) -- Select coal

        if turtle.getItemCount(1) > 0 and turtle.refuel(1) then -- Try to refuel
            return true -- Success
        end

        return nil -- Error if can't refuel
    end

    if not tryRefuel() then -- If can't refuel
        print("Waiting for refuel.")

        while not tryRefuel() do
            sleep(1)
        end

        print("Resuming.")
    end
end

local function dropToChest()
    for n = 4, 16 do
        if turtle.getItemCount(n) == 0 then
            return -- Don't drop if any slot is empty
        end
    end

    local function tryDropToChest()
        turtle.select(2) -- Select chest

        if turtle.getItemCount(2) > 0 and turtle.place() then -- Try to place it
            for n = 4, 16 do
                turtle.select(n)
                turtle.drop() -- Drop everything to it
            end

            return true -- Success
        end

        return nil -- Error if can't drop
    end

    turtle.turnRight()
    turtle.turnRight()

    if not tryDropToChest() then -- If can't drop to chest
        print("Waiting for chest.")
    
        while not tryDropToChest() do
            sleep(1)
        end
    
        print("Resuming.")
    end

    turtle.turnRight()
    turtle.turnRight()
end

--[[
local function placeTorch()
    local function tryPlaceTorch()
        turtle.select(3) -- Select torch
        if turtle.getItemCount(3) > 0 and turtle.placeDown() then -- Try to place it
            return true -- Success
        end
        return nil -- Error if can't place it
    end

    turtle.down()
    local hasBlock = turtle.detectDown()
    turtle.up()

    if hasBlock then -- Check if there is a block below us
        tryPlaceTorch()
    end
end
]]

local function tryDig()
    dropToChest()

    while turtle.detect() do -- If there is something in front of us
        if not turtle.dig() then -- Try to dig
            return nil -- Error if not possible
        end

        sleep(0.5)
    end

    return true -- Cleared
end

local function tryDigUp()
    dropToChest()

    while turtle.detectUp() do -- If there is something over us
        if not turtle.digUp() then -- Try to dig
            return nil -- Error if not possible
        end
    
        sleep(0.5)
    end

    return true -- Cleared
end

local function tryDigDown()
    dropToChest()

    while turtle.detectDown() do -- If there is something below us
        if not turtle.digDown() then -- Try to dig
            return nil -- Error if not possible
        end

        sleep(0.5)
    end

    return true -- Cleared
end

local function tryForward()
    refuel()

    while not turtle.forward() do -- If can't go forward
        if not tryDig() then -- Try to dig
            return nil -- Error if not possible
        elseif not turtle.attack() then -- Try to attack
            sleep(0.5) -- Wait if all clear
        end
    end

    return true -- Moved
end

local function tryNextRow()
    local function turnByDirection()
        if direction then
            turtle.turnRight()
        else
            turtle.turnLeft()
        end
    end

    turnByDirection()

    if not tryForward() then -- Try to engage next row
        return nil
    end

    turnByDirection()
    direction = not direction -- Alternate turns
    return true
end

print("Started.")

for m = 1, rows do
    for n = 1, length do
        tryDigUp()
        tryDigDown()

        if n < length and not tryForward() then -- If 
            print("Aborting.")
            return
        else
            print("Row complete.")
        end
    end

    if m < rows and not tryNextRow() then
        print("Aborting.")
        return
    else
        print("Finished.")
    end
end
