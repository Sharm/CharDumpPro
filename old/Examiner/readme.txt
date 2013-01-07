Examiner - An Advanced Inspection Mod
-------------------------------------
Examiner is an advanced inspection mod which you can use to check other players gear, talents, honor and arena team details.

When you inspect someone, it will show a stat summery of all their equipped gear combined.
Please note that these values are from gear alone, and will not include bonuses from buffs, talents or normal base stats.

Each player you inspect, will be cached so you can look them up later, even when they are no where near you.
This option can be disabled if you prefer not to cache the people you inspect. To cache honor and arena details, you must
enable the option to do so under the config page. Talents are not cached.

You can bind a key to inspect your target, you can even bind a key to inspect whoever is under your mouse (stealth inspection).
To set this up, open the Key Bindings dialog and look under "Examiner".

Examiner uses about 175 kb of memory with no players cached.

Compare Gear
------------
To compare one person's gear with another, you can mark a target for compare by right clicking on the
"Stats" button to get a drop down menu to open, this menu will have an entry called "Mark for Compare".
When marked for compare, the Stats page will no longer show the actual stats of your inspected person,
but will instead show the difference in stats compared to the person you marked for compare.

Sending Inspect Data to Another Player
--------------------------------------
Examiner can send the inspected data to another person who has Examiner. This is done through the AddOn Whisper Channel.
By default, accepting addon messages in Examiner is disabled, you have to enable this on the Configurations page.

To send a player you have inspected to another person with Examiner, you have to first inspect a person or load them from your cache.
After having done this, right click on the "Stats" button and select "Send To..." and fill in the name of the person you wish to send it to.
If the send was successful and the person you sent it to received it, you will get a note in the chat frame that they got it.

Model Frame Controls
--------------------
Left Click + Move:		Moves the Model
Right Click + Move:		Rotates the Model
Mousewheel:				Zoom
Ctrl + Left Click:		Change Background
Ctrl + Right Click:		Toggle Background

Slash Commands
--------------
The slash command for Examiner is /examiner or just /ex.

Although you probably wont need to use any slash commands as almost everything is available from the UI,
there are a few things which can only be done through slash commands.

/ex inspect 'unit' or /ex i 'unit'
This one will inspect the given unit (target, focus, party3 etc). If no unit token is given, it will inspect target and then player if no target exist.

/ex si 'itemLink'
This command will scan just a single item and list its combined stats in the chat frame.
Holding down ALT while the mouse is over an item in Examiner will show a tooltip with the stats like this.

/ex compare 'itemLink1' 'itemLink2'
Compares two items and lists the stat differences.

/ex arena 'rating'
Shows you the amount of arena points the given rating gives for 2v2, 3v3 and 5v5.

/ex scale 'value'
Changes the scale of the Examiner window.

/ex clearcache
Clears the entire cache of Examiner.

Special Thanks
--------------
- Chester, the original author of SuperInspect, who gave me the idea to make this mod.
- Haldamir of Gorgonnash, for the German translation.
- omosiro, who made the Korean translation.
- g3gg0, changes to the German translation & author to one of the SuperInspect versions.
- Pettigrow of Sinstralis, for the translation to French.
- Siphony of EU-Onyxia, updated German translation.