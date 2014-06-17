class 'BetterChat'

function BetterChat:__init(args)
    Network:Subscribe("toggle", self, self.Mode)
    Network:Subscribe("player", self, self.Player)
    Events:Subscribe("PlayerChat", self, self.Chat)
    Events:Subscribe("PlayerJoin", self, self.Join)
    self.globalchatcolor = Color.PaleGoldenRod
    self.carchatcolor = Color.LawnGreen
    self.localchatcolor = Color.Sienna
    self.teamchatcolor = Color.DeepSkyBlue
    self.distance = 20
end

function BetterChat:Join(args)
    self.toggle = 0
    args.player:SetValue("chat",0)
    args.player:SetValue("team",math.random(1,2))
    args.player:SetValue("loc_dist",nil)
end

function BetterChat:Mode(toggler)
    self.toggle = tonumber(toggler)
end

function BetterChat:Player(player)
    ply = player
    ply:SetValue("chat",self.toggle)
end

function BetterChat:Chat(args)
    if args.text:sub(1,1) != "/" then
        self.chat = args.player:GetValue("chat")
        if self.chat == 0 then
            Chat:Broadcast("[Global] "..args.player:GetName()..": "..args.text,self.globalchatcolor)
            print("[Global] "..args.player:GetName()..": "..args.text)
            return false
        elseif self.chat == 1 then
            for player in Server:GetPlayers() do
                if player:GetValue("team") == 1 then
                    player:SendChatMessage("[Team] "..args.player:GetName()..": "..args.text,self.teamchatcolor)
                    print("[Team_1] "..args.player:GetName()..": "..args.text)
                else
                    player:SendChatMessage("[Team] "..args.player:GetName()..": "..args.text,self.teamchatcolor)
                    print("[Team_2] "..args.player:GetName()..": "..args.text)
                end
            end
            return false
        elseif self.chat == 2 then
            for player in Server:GetPlayers() do
                if (player:GetWorld() == args.player:GetWorld()) then
                    local dist = args.player:GetValue("loc_dist")
                    if dist != nil then
                        if (Vector3.Distance(args.player:GetPosition(),player:GetPosition()) <= args.player:GetValue("loc_dist")) then
                            player:SendChatMessage("[Local] "..args.player:GetName()..": "..args.text,self.localchatcolor)
                            print("[Local] "..args.player:GetName()..": "..args.text)
                            return false
                        end
                    else
                        if (Vector3.Distance(args.player:GetPosition(),player:GetPosition()) <= self.distance) then
                            player:SendChatMessage("[Local] "..args.player:GetName()..": "..args.text,self.localchatcolor)
                            print("[Local] "..args.player:GetName()..": "..args.text)
                            return false
                        end
                    end
                end
            end
        elseif self.chat == 3 then
            if args.player:InVehicle() then
                local vehicle = args.player:GetVehicle()
                for index,player in ipairs(vehicle:GetOccupants()) do
                    player:SendChatMessage("[Car] "..args.player:GetName()..": "..args.text,self.carchatcolor)
                    print("[Car] "..args.player:GetName()..": "..args.text)
                end
            else
                args.player:SendChatMessage("You have to be in a vehicle to use the Car Chat!",Color.FireBrick)
            end
            return false
        end
    else
        local cmd_args = string.split(args.text," ",true)
        if cmd_args[1] == "/setlocal" then
            local count = table.count(cmd_args)
            if count == 1 then
                args.player:SetValue("loc_dist",nil)
                args.player:SendChatMessage("Local Chat Radius has been changed to default",Color.Green)
            elseif count == 2 then
                if (tonumber(cmd_args[2]) >= 3 and tonumber(cmd_args[2]) <= 40) then
                    args.player:SetValue("loc_dist",tonumber(cmd_args[2]))
                    args.player:SendChatMessage("You have changed the radius to "..cmd_args[2],Color.Green)
                else
                    if (tonumber(cmd_args[2]) <= 3) then
                        args.player:SendChatMessage("Please enter a value that is bigger 3",Color.FireBrick)
                    elseif (tonumber(cmd_args[2]) >= 40) then
                        args.player:SendChatMessage("Please enter a value that is less than 40",Color.FireBrick)
                    else
                        args.player:SendChatMessage("Please enter a number",Color.FireBrick)
                    end
                end
            elseif count >= 3 then
                args.player:SendChatMessage("Wrong Format. Please use: /setformat number or /setformat to reset to default",Color.FireBrick)
            end
        end
        return false
    end
end

betterchat = BetterChat()
