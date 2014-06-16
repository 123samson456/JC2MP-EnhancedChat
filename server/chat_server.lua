class 'CarChat'

function CarChat:__init(args)
    Network:Subscribe("toggle", self, self.Mode)
    Network:Subscribe("player", self, self.Player)
    Events:Subscribe("PlayerChat", self, self.Chat)
    Events:Subscribe("PlayerJoin", self, self.Join)
    self.globalchatcolor = Color.PaleGoldenRod
    self.carchatcolor = Color.LawnGreen
    self.teamchatcolor = Color.DeepSkyBlue
end

function CarChat:Join(args)
    self.toggle = 0
    args.player:SetValue("chat",0)
    args.player:SetValue("team",math.random(1,2))
end

function CarChat:Mode(toggler)
    self.toggle = tonumber(toggler)
end

function CarChat:Player(player)
    ply = player
    ply:SetValue("chat",self.toggle)
end

function CarChat:Chat(args)
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
        Network:SendNearby(args.player,"player_1",args.player:GetName())
        Network:SendNearby(args.player,"local_1",args.text)
        Network:Send(args.player,"player_2",args.player:GetName())
        Network:Send(args.player,"local_2",args.text)
        print("[Local] "..args.player:GetName()..": "..args.text)
        return false
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
end

carchat = CarChat()
