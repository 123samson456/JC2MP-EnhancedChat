class 'CarChat'

function CarChat:__init()
    Events:Subscribe("GameLoad",self,self.GameLoad)
    Events:Subscribe("KeyUp",self,self.KeyUp)

    Network:Subscribe("player_1",self,self.GetPly1)
    Network:Subscribe("player_2",self,self.GetPly2)
    Network:Subscribe("local_1",self,self.GetMsg1)
    Network:Subscribe("local_2",self,self.GetMsg2)

    self.key = VirtualKey.F2
    self.toggle = 0
    -- 0 Global Chat
    -- 1 Team Chat
    -- 2 Local Chat
    -- 3 Car Chat

    self.localcolor = Color.Sienna
end

function CarChat:GameLoad()
    self.toggle = 0
end

function CarChat:KeyUp(args)
    if (args.key == self.key) then
        if self.toggle <= 2 then
            self.toggle = self.toggle + 1
            Network:Send("toggle",tostring(self.toggle))
            Network:Send("player",LocalPlayer)
        else
            self.toggle = 0
            Network:Send("toggle",tostring(self.toggle))
            Network:Send("player",LocalPlayer)
        end
    end
end

function CarChat:GetPly1(ply)
    self.player = ply
end
function CarChat:GetPly2(ply2)
    self.player2 = ply2
end
function CarChat:GetMsg1(msg)
    self.text = tostring(msg)
    Chat:Print("[Local] "..self.player..": "..self.text,self.localcolor)
end
function CarChat:GetMsg2(msg2)
    self.text2 = tostring(msg2)
    Chat:Print("[Local] "..self.player2..": "..self.text2,self.localcolor)
end

carchat = CarChat()
