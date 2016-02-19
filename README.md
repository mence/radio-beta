# Radio Beta Release

Tested on OSX 10.10.5
Release 1.0.23.90.g42187855

## Primary functional tests

* I can create a radio station for an artist
* I can create a radio station for a song
* I can create a radio station for a genre
* Starting a radio station creates the radio queue
* I can thumbs up the currently playing song
* I can thumbs down the currently playing song
* Creating a station saves it to my stations

## Exploratory and Other Tests

* Shuffle should be disabled
* Queue (Next Tracks) should be filled with songs from radio
* Manually queued songs should trump the Radio queue (Next Tracks)
* Starting Radio
    * From song (right-click)
    * From artist (right-click)
    * From artist (page, dropdown menu)
    * From radio page
    * From playlist
        * Manually created playlist
        * Spotify created playlist
* Empty playlist should not create a radio
* Essential functions should not be disrupted by starting/switching to a radio
  * Play controls
  * System play controls
  * Private sessions
* Integrations should still behave
  * Lyrics / MusicMatch
* Currently playing Radio station should be indicated in Your Stations
* Upvote a song
    - Should lead to regenerated radio queue?
    - Should create + add to Liked from Radio
* Downvote a song
    - Song should never appear in the list again
* Clicking current song should take me to the Radio
* After quitting mid-stream, I should be able to return to the song?

## Notes

* Radio stations list becomes unwieldy at large numbers (eg >20).
* Not possible to rate past songs (ala Pandora)
* Clicking play on album cover after pausing in Radio restarts the song
* Only way to upvote/downvote a Radio song is on Radio page (secondary clickthrough to Radio page required from currently playing)
* Recommended Radio stations does not regenerate based on Radio interaction
* Cannot search for Radio stations
* VERY GENERAL: Hard to differentiate between a playlist and Radio sometimes. For instance, Discover playlists can feel a bit like Radio
* Liking (upvoting) a song takes a small amount of time to appear in Liked From Radio playlist
* No way to train Radio ahead of time (eg through Next Songs).
* Is Radio truly drawing from a genre list? Seems like there is 50-100 songs that are essentially just on random?
* Can't create a user radio?

## Bugs

* Genre Radio Station buttons do not render as links
    - My guess is this is somewhere in GLUE to work it out. Potentially the button-info class is being overridden. Guess this one really depends on what the style guide calls for in this case.
* Manually created (collaborative?) radio station does not queue tracks
* List of radio stations does not wrap around when clicking next?
* After quitting mid-stream, returning to genre radio returns a previously downvoted song (potentially Genre Radio is hardcoded list?)
* After quitting mid-stream, continuing to play song and then clicking through to Radio crashes stream and skips song currently playing
    - Steps followed: start R&B radio, quit on Usher - Yeah!, restart lets me continue it, however trying to click through to Radio eg to vote, stops stream and I am jumped to Chris Brown - Say Goodbye (after Jay-Z - 99 Problems), 2 songs past where I should be.
    - potentially because player.js sets this.currentStation to null, which I guess means the player is initialized as per the current song in localStorage. Something in there with onStationStarted is probably conflicting here. My guess is this is a scope problem.
    - might be PlayerState not saving/retrieving current station, meaning it's only fetched on the radio page?
* Can't modify a vote once cast
    - if we wanted to do it, would have to send new feedback, as well as enable button state.
    - Removing from Liked From Radio does nothing, somewhat obviously

## Code Comments

*Caveat: I'm not as familiar with Angular, so it's a little hard to tell if some things are idiomatic or just spat out as part of the build system.*

* radio: Is there a way to not package all of Angular (122K) and jQuery (82K) in? Even minified...
* Would you want to log specific genre when a genre-station is triggered, rather than just a seed title? Could be my misunderstanding here, perhaps the `spotify:genre` index is enough to retrieve
* radio and radio-hub: Some languages missing translations (maybe not available in those regions?), eg in radio-hub:
    "hi": "app.description",
    "ko": "app.description",
    "ro": "app.description",
    "ru": "app.description",
    "ta": "app.description",
    "th": "app.description",

## General Notes

* Spotify app allows you to zoom in/out (because it's just a Chromium wrapper)?
* MusixMatch app bar wording is ... awkward: "Download now MusixMatch on your mobile"
* Inconsistent titling of musixmatch/MusixMatch/Musixmatch
* [MusixMatch link for iOS](http://bit.ly/iPhonemXm) leads to [GB App Store](https://itunes.apple.com/gb/app/musixmatch-lyrics-player/id448278467?mt=8) not US.
    - MusixMatch App Store Links:
        - [iOS](http://bit.ly/iPhonemXm)
        - [Android](http://bit.ly/androidmXm)
        - [Windows](http://bit.ly/wp7mXm)
* About Spotify page copyright tag has not been updated for 2016.
* Inconsistent naming of the Spotify Support Community (referred to Help > Spotify Community) in app.
