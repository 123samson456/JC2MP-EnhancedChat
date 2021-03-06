class 'BetterChat'

function BetterChat:__init(args)
    admins = {}
    Network:Subscribe("toggle", self, self.Mode)
    Events:Subscribe("PlayerJoin", self, self.Join)
    Events:Subscribe("PlayerChat", self, self.Chat)
    self:loadAdmins("server/admins.txt")
    self.globalchatcolor = Color.PaleGoldenRod
    self.carchatcolor = Color.LawnGreen
    self.localchatcolor = Color.Sienna
    self.teamchatcolor = Color.DeepSkyBlue
    self.distance = 20
    self.toggle = 0
end

function BetterChat:loadAdmins(filename)
	local file = io.open(filename, "r")
	local i = 0
	if file == nil then
		print("No admins found")
		return
	end
	for line in file:lines() do
		i = i + 1
		if string.sub(filename, 1, 2) ~= "--" then
			admins[i] = line
			print("Admins Found: " .. line)
		end
	end
	file:close()
end

function isAdmin(player)
	local adminstring = ""
	for i,line in ipairs(admins) do
		adminstring = adminstring .. line .. " "
	end
	if(string.match(adminstring, tostring(player:GetSteamId()))) then
		return true
	end
	return false
end

function BetterChat:Join(args)
    args.player:SetValue("chat",0)
    args.player:SetValue("team",math.random(1,2))
end

function BetterChat:Mode(toggler, player)
    player:SetValue("chat", toggler)
end

function BetterChat:Chat(args)
    if (isAdmin(args.player)) then
        return false
    else
        if args.text:sub(1,1) != "/" then
            local chatsetting = args.player:GetValue("chat")
            if chatsetting == 0 then
                Chat:Broadcast("[Global] "..args.player:GetName()..": "..args.text,self.globalchatcolor)
                print("[Global] "..args.player:GetName()..": "..args.text)
                return false
            elseif chatsetting == 1 then
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
            elseif chatsetting == 2 then
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
            elseif chatsetting == 3 then
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
                    if (tonumber(cmd_args[2]) != nil) then
                        if (tonumber(cmd_args[2]) >= 3 and tonumber(cmd_args[2]) <= 40) then
                            args.player:SetValue("loc_dist",tonumber(cmd_args[2]))
                            args.player:SendChatMessage("You have changed the radius to "..cmd_args[2],Color.Green)
                        else
                            if (tonumber(cmd_args[2]) <= 3) then
                                args.player:SendChatMessage("Please enter a value that is bigger 3",Color.FireBrick)
                            elseif (tonumber(cmd_args[2]) >= 40) then
                                args.player:SendChatMessage("Please enter a value that is less than 40",Color.FireBrick)
                            end
                        end
                    else
                        args.player:SendChatMessage("Please enter a number",Color.FireBrick)
                    end
                elseif count >= 3 then
                    args.player:SendChatMessage("Wrong Format. Please use: /setformat number or /setformat to reset to default",Color.FireBrick)
                end
            end
            return false
        end
    end
end

betterchat = BetterChat()
