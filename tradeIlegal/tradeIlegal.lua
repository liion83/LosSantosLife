local DrawMarkerShow = true

-- -900.0, -3002.0, 13.0
-- -800.0, -3002.0, 13.0
-- -1078.0, -3002.0, 13.0

local Price = 1500

local Position = {
    Recolet={x=-1000.0,y=-3002.0,z=13.0, distance=20}, -- Pick up Position
    traitement={x=-1078.0,y=-3002.0,z=13.0, distance=20}, -- Rolling Position
    vente={x=-950.0,y=-3002.0,z=13.0, distance=20} -- Sell Position
}

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextProportional(0)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y)
end

function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

local ShowMsgtime = {msg="",time=0}

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      if ShowMsgtime.time ~= 0 then
        drawTxt(ShowMsgtime.msg, 0,1,0.5,0.8,0.6,255,255,255,255)
        ShowMsgtime.time = ShowMsgtime.time - 1
      end
    end
end)

Citizen.CreateThread(function()
    while true do
       Citizen.Wait(0)
       if DrawMarkerShow then
          DrawMarker(1, Position.Recolet.x, Position.Recolet.y, Position.Recolet.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
          DrawMarker(1, Position.traitement.x, Position.traitement.y, Position.traitement.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
          DrawMarker(1, Position.vente.x, Position.vente.y, Position.vente.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 0, 255, 75, 0, 0, 2, 0, 0, 0, 0)
       end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPos = GetEntityCoords(GetPlayerPed(-1))

        local distanceWeedFarm = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.Recolet.x, Position.Recolet.y, Position.Recolet.z, true)
        if distanceWeedFarm < Position.Recolet.distance then
           ShowInfo('~b~Press on ~g~E~b~ for Pick up', 0)
           if IsControlJustPressed(1,38) then
                local weedcount = 0
                TriggerEvent("player:getQuantity", 1, function(data)
                    weedcount = data.count
                end)
                if weedcount < 30 then
                        ShowMsgtime.msg = '~g~ Pick up ~b~Cannabis'
                        ShowMsgtime.time = 150
                        Wait(2500)
                        ShowMsgtime.msg = '~g~ + 1 ~b~Cannabis'
                        ShowMsgtime.time = 150
                        TriggerEvent("player:receiveItem", 1, 1)
                else
                        ShowMsgtime.msg = '~r~ Inventory Full !'
                        ShowMsgtime.time = 150
                end
           end
        end

        local distanceWeedFarm = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.traitement.x, Position.traitement.y, Position.traitement.z, true)
        if distanceWeedFarm < Position.traitement.distance then
           ShowInfo('~b~Press on ~g~E~b~ for Rolling ~b~Cannabis', 0)
           local weedcount = 0

           TriggerEvent("player:getQuantity", 1, function(data)
                weedcount = data.count
           end)

           Citizen.Trace(weedcount)
           if IsControlJustPressed(1,38) then
                if weedcount ~= 0 then
                        ShowMsgtime.msg = '~g~ Rolé le ~b~Cannabis'
                        ShowMsgtime.time = 150
                        Wait(2500)
                        ShowMsgtime.msg = '~g~ + 1 ~b~Cannabis Rolling'
                        ShowMsgtime.time = 150
                        
                        TriggerEvent("player:looseItem", 1, 1)
                        TriggerEvent("player:receiveItem", 3, 1) 
                else
                        ShowMsgtime.msg = '~r~ You have not Cannabis !'
                        ShowMsgtime.time = 150
                end
           end
        end

        local distanceWeedFarm = GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, Position.vente.x, Position.vente.y, Position.vente.z, true)
        if distanceWeedFarm < Position.vente.distance then
           ShowInfo('~b~ Press on ~g~E~b~ for Sell', 0)
           local weedcount = 0
           TriggerEvent("player:getQuantity", 3, function(data)
                weedcount = data.count
           end)
           Citizen.Trace(weedcount)
           if IsControlJustPressed(1,38) then
                if weedcount ~= 0 then
                        ShowMsgtime.msg = '~g~ Sell ~b~Cannabis Rolling'
                        ShowMsgtime.time = 150
                        Wait(2500)
                        ShowMsgtime.msg = '~g~ +'.. Price ..'$'
                        ShowMsgtime.time = 150
                        TriggerEvent("player:sellItem", 3, Price)
                else
                        ShowMsgtime.msg = '~r~ You have not Cannabis Rolling !'
                        ShowMsgtime.time = 150
                end
           end
        end

    end
end)