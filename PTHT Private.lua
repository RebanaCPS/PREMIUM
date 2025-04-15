EditToggle("ModFly", true)
EditToggle("AntiLag", true)

local Looping = 0

function path(x, y, state)
    SendPacketRaw(false, {state = state,
        px = x, 
        py = y,
        x = x*32, 
        y = y*32})
end

function h2(x, y, id)
    SendPacketRaw(false,{type = 3,
        value = id,
        px = x,
        py = y,
        x = x*32,
        y= y*32})
end

function getTree()
    local count = 0
    for y = ey, 0, -1 do
        for x = 0, ex, 1 do
            if GetTile(x, y).fg == 0 and (GetTile(x, y +1).fg ~= 0 and GetTile(x, y +1).fg % 2 == 0) then
                count = count + 1
            end
        end
    end
    return count
end

function getReady()
    local ready = 0
    for y = ey, 0, -1 do
        for x = 0, ex, 1 do
            if GetTile(x, y).fg == harvestid and GetTile(x, y).readyharvest then
                ready = ready + 1
            end
        end
    end
    return ready
end

function harvest()
    if getReady() > 0 then
        for y = eyy, 0, -1 do
LogToConsole(" `2Harvest`8Line `8 = `#"..y)
            for x = 0, exx, 1 do
                if (GetTile(x, y).fg == harvestid and GetTile(x, y).readyharvest) then
                    path(x, y, plantid)
                    h2(x, y, 18)
                    Sleep(Panen)
                end
            end
        end
    end
end

function harvest2()
    if getReady() > 0 then
        for y = eyy, 0, -1 do
LogToConsole("`2Check Harvest = `#"..y)
            for x = 0, exx, 1 do
                if (GetTile(x, y).fg == harvestid and GetTile(x, y).readyharvest) then
                    path(x, y, plantid)
                    h2(x, y, 18)
                    Sleep(Panen)
                end
            end
        end
    end
end

function uws()
    if getTree() == 0 then
        Sleep(500) 
        SendPacket(2, "action|dialog_return\ndialog_name|ultraworldspray") 
        Sleep(4000) 
        harvest() 
    Sleep(50)
    harvest2()
    elseif getTree() ~= 0 then 
        plant() 
        Sleep(1000)
    end
end

function plant()
    if getReady() < 20000 then
        for y = ey, 0, -1 do
LogToConsole("`2Plant Line `8 = `#"..y)
            for x = 0, ex, 10 do
                if GetTile(x,y).fg == 0 and (GetTile(x,y +1).fg ~= 0 and GetTile(x,y+1).fg %2 == 0) then
                    path(x, y, 32)
                    h2(x, y, plantid)
                    Sleep(Nanem)
                end
            end
            for x = ex, 0, -1 do
                if GetTile(x,y).fg == 0 and (GetTile(x,y +1).fg ~= 0 and GetTile(x,y+1).fg %2 == 0) then
                    path(x, y, 48)
                    h2(x, y, plantid)
                    Sleep(Nanem)
                end
            end
        end
    end
uws() 
end

for i = 1, 3 do
    SendPacket(2, [[action|input
|text| `8 [`bMade by `bRebana`8]  ]])
    Sleep(1000)
end

for i = 1, Loop do
Sleep(200)
    harvest() 
Sleep(100)
  harvest2()
plant()
    Looping = Looping + 1
    SendPacket(2, "action|input\ntext|`2Success PTHT: `b( `9"..Looping.." `b)  Script `bBy: `bRebana ")
end
