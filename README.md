JC2MP-EnhancedChat
==================

More added Chat possibilities for JC2MP

- Global Chat
- Team Chat (the very default, not recommended)
- Local Chat
- Car Chat

To toggle between these type F2 on your keyboard. By default the Chat Mode is the Global Chat.
You can change the key in the init of the client file: self.key = "Your wished key"

Additional commands:

- /setlocal [number] to set a local chat radius in which everyone receives your message
- /setlocal to set local chat radius to default (20m)

The default radius can be changed in the init of the server file: self.distance = "amount of meters"

With the release of v1.2 admin systems are supported. Just add admin SteamIDs in "server/admins.txt". They will be detected automatically when the module loads. 

Future ideas:
- MultiColor Chat Strings (at the moment really difficult to realize)


Release: Version 1.1
====================

Changelog:

- change local chat radius with /setlocal number and reset it with /setlocal
- surpressing commands output (beginning with a "/")
- removing unneeded network communication to save maximum bandwidth
- every chat input is saved in the console. Allowing to save chat histories

Release: Version 1.2
====================

Changelog:

- admin support (add admins SteamIDs in "server/admins.txt" to prevent sending admin messages twice")
