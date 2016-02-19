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
