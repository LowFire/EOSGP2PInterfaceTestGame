# EOSG P2P Interface Test Game
## About
This test game was created to demonstrate some of the functionality of the P2P interface and  EOSGMultiplayerPeer class in the EOS Godot addon and provide a simple example of it's use. The game is a basic top-down shooter where players fight each other in an arena and get points for frags. Players can either host their own game or connect to an existing one.

## How to get the game working

There are some things that need to be done before the game will work.

First, you will need to install the EOS Godot addon. This repo doesn't have the addon committed to it so you will have to download and install it yourself. Intallation is very simple if you've installed addons before, but just in case, this is how you do it:

* Download the plugin from here: https://github.com/3ddelano/epic-online-services-godot/releases
* Inside the zip folder, drag and drop the `addons` folder directly into the project's root directiory

And thats all for the addon installation.

Next, you will need to create an Epic Games account and set up an organization in their developer portal if you haven't done so already. This is required if you want to use the EOS Godot addon for this project and any other project you work on. To do this, just follow the instructions on how to set up your own organization and product from the Epic Game's website: https://dev.epicgames.com/docs/epic-online-services/eos-get-started/services-quick-start#step-1---set-up-an-epic-games-account-and-organization

You will also need to create an epic product, which will contain the game's client and product credentials. These are needed for the addon to access Epic Online Service's backend. To get an epic product up and running, follow these steps:

* Sign into your Epic Games account and go to the developer portal
* From the developer portal, click on "New Product" from the menu on the left. Type in the name of your product and click "Create Product". Once your product is created, it should show up in the list of products under "Your Products" in the developer portal.
* Next to the product's name, click the cog icon.
* Under "Clients", there should be a big empty section where it says "No clients yet". Click on the blue link below it to go to the clients section.
* In the clients section under "Clients", click the "Add New Client" button. 
* In this menu, simply type in a client name for your client.
* In that same menu, click the "Add new client policy" button that should be right below where you typed in your client's name. This will bring up a new menu to create a client policy.
* Type in the name of your new client policy. Under "Client policy type" select the "Peer2Peer" option, and then hit "Add new client policy".
* Once you've created your new client policy, it should have brought you back to the create client menu. Hit "Create Client", and your new client should have been created with the new client policy attached.

And this is it for setting up an epic product. 

Next, you need to grab the product's credentials and paste them into a file called `product_details.gd`. This gdscript file is used to store important product credentails and are accessed by the game when it attempts to create and initialize the EOS platform. `product_details.gd` is found at the root directory of the project.

You can find the product's credentials in the product's settings in the developer's portal (The same place that you created your first client.)

![product_settings](https://github.com/LowFire/EOSGP2PInterfaceTestGame/assets/33795345/5897d15f-7a01-4272-a4ff-8eaef6c85cd4)

Just copy and paste each key into their corrisponding fields in `product_details.gd`. The `encryption_key` is the last field in the file and it is a 64 character hexidecimal value that is used to encrypt your product credentials. This key is not important for this sample project and can be skipped.

And that should be it for setting up the game.

## Authenticating using developer credentials

In order to play the game, EOS needs to authenticate you as a player somehow. When you first start the game, it allows you to do this in two different ways as shown by the first menu: 

![gamefirstscreen](https://github.com/LowFire/EOSGP2PInterfaceTestGame/assets/33795345/b2ec6290-8e59-4dd9-af63-2a692eb0c7d3)

The easist way is to simply authenticate by using your local device id, which is what the button below allows you to do. This is fine if you are running instances of the game on separate devices, but if you want to run multiple instances on the same device, you will have to authenticate using developer credentials.

Epic Games provides something called a "Dev Auth Tool" that allows you to start up a server that provides developer credentails that can be used to authenticate with EOS. This tool is available when you download the EOS SDK from the developer portal. The tool can be found in the `Tools` folder in the SDK. Just look for an exe file called `EOS_DevAuthTool.exe`. When you find it, simply run the exe and it should bring up a menu asking for a port that you want the dev auth tool server to listen for. Enter in port number 7878, as this is the port that the game will be trying to access the server on.

Once you've entered the port number, the server should be active. You can now add developer credentials by logging in epic games and providing a credential name. This is the name you enter in when you log into the game using developer credentials.

Before you can start authenticating using developer credentials though, there's one more extra thing that you need to do from the developer portal in the Epic Games website, and that's set up an application for your product. To do this, follow these steps:

* From the developer's portal, click on your product that's under the "Your Products" section.
* In the menu on the left, go to "Epic Account Services".
* From here, there should be a list of applications for your product listed under "Applications". There should be a single entry for your product. If not, click on "Create Application" on the top right.
* To configure your application, click on one of the three options listed near the application to start configuring it.
* In the next menu, on the top right, click on permissions and then simply hit "Save Changes" at the bottom. Configuration isn't needed here.
* Next, click on "Linked Clients" at the top right and select your client. Click "Save Changes".

And thats it. You should now be able to authenticate using developer credentials.

Something important to note. When running multiple instances, each instance needs to be authenticated using different developer credentials. If you try to log into different instances using the same crednetials, attempting to connect to a game will not work. This means that you'll have to make multiple Epic Games accounts if you want to create multiple developer credentials to authenticate with. On top of that, you need to invite each of those accounts to your organization, otherwise they won't be able to authenticate. Just keep that in mind.

## How to host/connect to another game

Hosting and connecting to another game is easy. When you log into the game, you will be given two options; "Create Server" or "Create Client". Simply select "Create Server" if you want to host a game and it will immediatly start the game. If you select "Create Client", it will bring you to another menu asking for the remote user id of the host you're trying to connect to. This id is used to uniquely identify players connected to the game from EOS's backend. The user id of a player is displayed at the top right of the screen:

![userid](https://github.com/LowFire/EOSGP2PInterfaceTestGame/assets/33795345/bf9d4e8f-cf24-4630-898b-c54e189125e5)

Copy and paste this from the host's instance to the remote user id field and then hit "Connect". The client should connect to the host with no issues.
