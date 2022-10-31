# SortingSynth

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
An iOS synthesizer that uses a variety of sorting algorithms to generate sound patterns.

### App Evaluation
- **Category:** Music / Education
- **Mobile:** This app will be primarily developed for mobile but 
- **Story:** Takes a random array of integers and sorts them. For each sort, it generates a synthesized tone. For each synthsized tone, it is matched to a musical key signature, including 12-tone chromatic scale. The user can adjust different settings to change the sound.
- **Market:** This turns the iPhone into a musical instrument. Any musician could use this to create sounds. 
- **Habit:** This is intentionally designed to not be a social application. The user will be able to share their recordings/generated sounds. 
- **Scope:** This is an instrument, it's sounds can be directly output from the iphone to a device that receives audio input. The recording can be shared to various socials or directly downloaded to the device to be sampled later.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

1) User can register
2) User can log in
3) User can change volume
4) User can change oscillator
5) User can +/- octaves
6) User can select musical keys
7) User can change sorting algorithm


**Optional Nice-to-have Stories**

1) User can record
2) User can add effects
3) User can "share" a recording
4) User can direct download the recording

### 2. Screen Archetypes

* Login
* Register
   * Upon Download/Reopening of the application, the user is prompted to log in to gain access to their recordings
* Synth Screen
    * User can generate sounds on this screen
    * User has a transport controls available to control playback and initiate record
* Recordings
    * User can save recordings played from synth screen to cloud storage
* Settings
    * User can change oscillator type, musical key signature, speed, octave range (array size), and other settings.
 

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Synth
* Recordings

**Flow Navigation** (Screen to Screen)

* Forced Log-in -> Account creation if no log in is available
* Synth Screen -> Jumps to settings
* Settings -> Toggle settings
* Recordings -> Replay recordings and share -> Jumps to modal iOS share screen


## Wireframes

![](wireframe.png | width=600)

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
