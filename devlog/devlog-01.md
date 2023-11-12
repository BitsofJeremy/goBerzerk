### goBerzerk - DevLog 01

https://d4t4.cc/devlog-01-goberzerk/

 - Copied most of the project source from the EtherDasher code base
 - Removed EtherDasher gameplay and mechanics that were unneeded
 - Added a player weapon [SpikeBall]
 - Replaced some sounds
 - Created a base Robot

## Screenshots and game play


![screenshot1](devlog/images/screenshot1.png)


![screenshot2](devlog/images/screenshot2.png)


[Gameplay Recording ](devlog/videos/ScreenRecording2021-08-25.mp4)



## TODO

#### Main:

    - Procedural generation of levels
    - Add EvilOtto timer
    - Change to larger screensize
    - Figure out game mechanics
        - Add bonus for destroying all robots
        - Change levels re-runs level generation
    - Rework HUD to more like original Berzerk game
        - Find a old school font


#### Player:

    - Change out to better player character
    - Figure out how to shoot lazers in cardinal directions


#### Robot:

    - Spawn nicely to NOT kill player on game start
    - Spawn more robots on level up
    - Fix hurt() to play sound and aninmation
    - Create a sprite and animations
    - Create a fricken lazer
    - Get a lazer sound
    - Script to follow and shoot player with lazers
        - Maybe a ray cast to detect player then shoot?
    - Script to randomly play taunts

#### SpikeBall -> FrickenLazers

    - Turn into a fricken lazer [sprite/shader]
    - Get a lazer sound


#### EvilOtto:

    - Start to create it
    - Figure out how to bounce?
        - Animation player with squash?
    - Script to follow player
        - Maybe a ray cast to detect player then set velocity and direction?
    - Script to randomly play taunts
