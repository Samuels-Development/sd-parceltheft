# sd-parceltheft

`sd-parceltheft` is a straightforward script that lets players steal parcels from houses and open them for random rewards. Parcels are synced globally, with taken parcels respawning after a set time. The script includes 23 default locations, with easy customization to add more. Props dynamically spawn and despawn based on player proximity.

## 🎥 Preview
https://streamable.com/6bnx5d

## 🔔 Contact
Author: Samuel#0008  
Discord: [Join the Discord](https://discord.gg/samueldev)
Store: [Click Me](https://fivem.samueldev.shop)

## 💾 Installation
1. Download the latest release from the [GitHub repository](https://github.com/Samuels-Development/sd-parceltheft/releases).
2. Extract the downloaded file and rename the folder to `sd-parceltheft`.
3. Place the `sd-parceltheft` folder into your server's `resources` directory.
4. Add `ensure sd-parceltheft` to your `server.cfg` to ensure the resource starts with your server.

## 📦 Item
1. Add an item called 'parcel' to your inventory or framework.

If you're using `qb-core`, add it in `qb-core/shared/items.lua` or to the items table in the database for ESX. 

In the case of `ox_inventory`, add the following to the items.lua:
```lua
	["parcel"] = {
		label = "Parcel",
		weight = 350,
		stack = false,
		close = true,
		consume = 0,
		description = "Small package filled with something.",
		client = {
			image = "parcel.png",
		},
		server = {
			export = 'sd-parceltheft.useParcel'
		}
	},
```

## 📖 Dependencies
[sd_lib](https://github.com/Samuels-Development/sd_lib/releases)

Supported Frameworks: QBCore, Qbox (`qbox` at checkout), ESX

Interaction Methods:
- Target: qb-target, qtarget, ox_target
- TextUI: qb-drawtext (qb-core function), cd_drawtextui, ox_lib textui
