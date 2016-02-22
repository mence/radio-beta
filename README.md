# Radio Beta Release

This was tested on:

* OSX `10.10.5` and `10.9.5`
* App release: `1.0.23.90.g42187855`
* Radio commit tag: `cb2a761`

## Primary functional tests

*These should be the primary regression tests, either checked manually or preferably through an automated test.*

* I can create a radio station for an artist
* I can create a radio station for a song
* I can create a radio station for a genre
* I can search for a new radio station to create
* Starting a radio station creates the radio queue
* I can thumbs up the currently playing song
* I can thumbs down the currently playing song
* Creating a station saves it to my stations

## Exploratory Tests

*If automating these tests, these would become unit tests or integration tests.*

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
* Integrations should still work
  * Lyrics / MusicMatch
* Currently playing Radio station should be indicated in Your Stations
* Upvote a song
    - Should lead to regenerated radio queue?
    - Should create + add to Liked from Radio
* Downvote a song
    - Song should never appear in the list again
* Clicking current song should take me to the Radio
* After quitting mid-stream, I should be able to return to the song


## Bugs

*These were bugs indentified during the session. Where possible, I've tried to hunt down a root-cause for the bug which I hope helps.*

* Genre Radio Station buttons do not render as links on mouseover
    - My guess is this is somewhere in GLUE to work it out. Potentially the button-info class is being overridden. Guess this one really depends on what the style guide calls for in this case.
* After quitting mid-stream, returning to genre radio returns a previously downvoted song.
    - Potentially this is an effect of Genre Radio stations pulling from a limited set of songs (see [Notes](#notes-for-discussion))
* After quitting mid-stream, continuing to play song and then clicking through to Radio crashes stream and skips song currently playing
    - Steps followed: start R&B radio, quit on *Usher - Yeah!*, restart let's me continue it, however trying to click through to Radio eg to vote, stops stream and I am jumped to *Chris Brown - Say Goodbye* (after *Jay-Z - 99 Problems*), 2 songs past where I should be.
    - potentially because `player.js` sets `this.currentStation` to null, which I guess means the player is initialized as per the current song in localStorage. Something in there with onStationStarted is probably conflicting here. My guess is this is a scope problem.
    - might be PlayerState not saving/retrieving current station, meaning it's only fetched on the radio page?

## Notes for Discussion

*These are the sort of things we should talk about these to see if they're to be considered bugs, or just areas for improvement in the future. Some of these might be deliberate choices, however I like to capture these as things that I experienced during exploratory testing.*

* Can't modify a vote once cast.
    - If we wanted to modify an existing vote, this would have to send new feedback for storage. This means that the thumbs button state will always be enabled.
* The radio stations list becomes unwieldy at large numbers (eg >20).
* List of radio stations does not wrap around when clicking the next button. Especially problematic for large lists of stations.
* It's not possible to rate past (previously played) songs (as Pandora does).
* Clicking play on album cover after pausing in Radio restarts the song.
* The only way to upvote/downvote a Radio song is on Radio page (secondary clickthrough to Radio page required from currently playing).
* The recommended Radio stations do not regenerate after Radio interaction.
* You cannot search for a Radio station through the normal search bar. The only way to search for potential stations is the New Station button.
* In general, it can feel hard to differentiate between a playlist and Radio at time. For instance, Discover playlists can feel a bit like Radio, particularly if your play history is heavily skewed.
* Liking (upvoting) a song takes a small amount of time to appear in Liked From Radio playlist.
* There is no way to train Radio before a song plays (eg through Next Songs).
* When generating a genre station, it seems as though there is a limited potential set of songs (around 50-100 songs). Pandora treats each genre station as a starting point for exploration, rather than a shuffle feel.
* You can't create a user radio (eg. I like what my friend listens to, I want to explore their songs).
* Manually created (collaborative?) radio station does not always queue tracks. This was hard to recreate consistently.
* We're not indicating to the friends feed that I'm listening to a radio station.
* Radio stations are unique to a device, meaning that handoff drops some of the features such as voting.
* When visiting Radio as a brand new user, I was suggested one radio station for Drake. This felt a little weird, as you really don't know what kind of user I am yet. An empty state encouraging me to create stations with some songs/artists would be better than a artist you have no idea if I like.

## Code Comments

*Caveat: I'm not as familiar with Angular, so it's a little hard to tell if some things are idiomatic or just spat out as part of the build system.*

* `/radio`: Is there a way to not package all of Angular (122K) and jQuery (82K) in?
* Would you want to log specific genre when a genre-station is triggered, rather than just a seed title? Could be my misunderstanding here, perhaps the `spotify:genre` index is enough to retrieve the seed
* radio and radio-hub: Some languages missing translations (maybe not available in those regions?), eg in radio-hub: `hi`, `ko`, `ro`, `ru`, `ta`, `th` all seem to be missing translations.

## Next Steps

In my opinion, Radio is ready for release. The things identified don't break any of the major functions and integration as a whole seems stable.

### Progressing from Manual Testing to Automated Testing

**1. Release and Immediate Future**

The team will probably have to stick with manual testing efforts. I would create a checklist of features to check (the primary functional tests I identified could be a starting point) prior to release. If there is a large burden of manual regression testing here, it might be worth considering something like [BrowserStack](https://www.browserstack.com/) [Rainforest QA](https://www.rainforestqa.com/) to offload some of this testing, particularly across platforms.

**2. Safety**

If it looks like we're going to continue with Radio, I would look to build a smoke automated test suite of the primary functional tests. We can probably just write this in Jasmine. This provides safety to ensure we haven't broken anything major.

**3. Functional Tests / Test Per Feature**

Once future development begins, we can build out this suite with a series of functional tests. Each new feature worked on should come with test(s) covering the happy path as well as any edge cases or requirements.

It might be worth making a very minimal API test suite to check the behaviour and structure of the various services we're integrating with to ensure the test contracts are maintained.

We might want to consider rewriting the smoke tests into more of a user journey test suite, following the path across a number of application components and actions (these should be very minimal, 10 max.)

**4. Integrations, TDD**

Now that we are in the flow of writing tests per feature, we should investigate:

* Following TDD style of preparing tests and developing.
* Refactoring the existing suite wherever possible to move higher-level tests into unit tests for speeds sake. However be careful here if we end up mocking too much away, we might not be capturing the actual behaviour. Consider retaining some of the functional tests.
* Larger testing concerns such as:
    - Performance testing: How does our application behave when the backend servers are under load? Are there rendering limits in the UI?
    - Cross-platform testing: investigate if it's possible to send tests to a cross platform test suite such as [SauceLabs](https://saucelabs.com/).

## Overall Application Notes for Discussion

*I'll raise them with the other teams but I've kept them in these test notes as part of the session.*

* The Chromium Embedded view still allows zoom in/out on text. It can look ... strange at very zoomed in.
* The MusixMatch app bar wording is poor grammar: "Download now MusixMatch on your mobile"
* There is inconsistent titling of musixmatch/MusixMatch/Musixmatch throughout the application
* [MusixMatch link for iOS](http://bit.ly/iPhonemXm) leads to [GB App Store](https://itunes.apple.com/gb/app/musixmatch-lyrics-player/id448278467?mt=8) not US.
    - MusixMatch App Store Links:
        - [iOS](http://bit.ly/iPhonemXm)
        - [Android](http://bit.ly/androidmXm)
        - [Windows](http://bit.ly/wp7mXm)
* The About Spotify page copyright tag has not been updated for 2016.
* There is inconsistent naming of the Spotify Support Community (referred to Help > Spotify Community) in app.
