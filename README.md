# pipe-game

This small puzzle game for mobile phones was developed as my personal project. I deployed it on the [Google Play Store](https://play.google.com/store/apps/details?id=ch.aurapps.pipes) and on the Apple App Store (I had to take down the Apple version due to the high annual developer fee, which is required to have apps on the app store.).

## Game Objective
The objective of the game is to connect the different colored pipes by laying new pipes in the sandbox. It also involves blasting away rocks that are in the way. The whole game has 3 worlds with 45 levels each. 

## Level Generator
The level files store the initial configuration of each level. They were generated using a MATLAB script and then stored in a txt file.

## Assets & Code
All visual assets were created by me using inkscape. The sound files are from freesound.org under the creative commons license. The background music is by Eric Matyas from [Soundimage](http://soundimage.org/) under the attribution license. The code is written in [lua](https://www.lua.org/) and uses the [Solar2d](https://solar2d.com/) game engine which provides some useful plugins.

## Ad Plugin and Permium Version
I hoped to generate a very low passive income by using ad revenue on the app. Due to the very low number of players, the profit was not very high. A plugin is used to show a small ad after each level is completed. Additionally, there exists an option to purchase a premium version which deactivates the ads.

## Gameplay

A video of the gameplay can be seen on [youtube](https://youtu.be/S9kMsL2g9cM).

![Screenshot of pipe-game](https://github.com/aurelappius/pipe-game/blob/master/Screenshots/1.PNG)