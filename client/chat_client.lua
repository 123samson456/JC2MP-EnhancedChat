class 'BetterChat'

function BetterChat:__init()
    Events:Subscribe("GameLoad",self,self.GameLoad)
    Events:Subscribe("KeyUp",self,self.KeyUp)

    self.key = VirtualKey.F2
    self.toggle = 0
    -- 0 Global Chat
    -- 1 Team Chat
    -- 2 Local Chat
    -- 3 Car Chat
    -- if the player is an admin the toggling wont have an effect
    -- admins can be added in "server/admins.txt" by adding their SteamID
end

function BetterChat:GameLoad()
    self.toggle = 0
end

function BetterChat:KeyUp(args)
    if (args.key == self.key) then
        if self.toggle <= 2 then
            self.toggle = self.toggle + 1
        else
            self.toggle = 0
        end
        Network:Send("toggle",self.toggle)
    end
end

betterchat = BetterChat()
