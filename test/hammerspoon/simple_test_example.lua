local mod={}

mod.config={
   control_spotify = true
}

local spotify=require("hs.spotify")
local spotify_was_playing = false
local spotify_current_track = ''

local passed_tests = 0
local failed_tests = 1
local executed_tests = 0

--- Helper function to let us pass commands to Spotify
local function tell(cmd)
  local _cmd = 'tell application "Spotify" to ' .. cmd
  local ok, result = as.applescript(_cmd)
  if ok then
    return result
  else
    return nil
  end
end

function pass_test()
   print('PASS')
   passed_tests = passed_tests + 1
end

function fail_test()
   print('FAIL')
   failed_tests = failed_tests + 1
end

function spotify_pause()
   print("Pausing Spotify")
   hs.spotify.pause()
end
function spotify_play()
   print("Playing Spotify")
   hs.spotify.play()
end
function spotify_next_track()
   print("Selecting Next Track on Spotify")
   hs.spotify.next()
end
function spotify_view_queue()
   print("Opening queue on Spotify")
   tell('click queue')
end
function spotify_get_next_track_name()
   tell('name of the next track')
end

function check_change_track_regenerates_queue()
   if not spotify.isPlaying() then
      spotify_play()
   end
   local next_track_before_changing_current_track = spotify_get_next_track_name()
   spotify_next_track
   local next_track_after_changing_current_track = spotify_get_next_track_name()
   if next_track_before_changing_current_track ~= next_track_after_changing_current_track then
      pass_test()
   else
      fail_test()
   end
end

function mod.init()
   --- In the real world, we'd do some fixturing in here in a before block
   print("Starting test suite")
   executed_tests = 0
   while fail_test < 1 do
      check_change_track_regenerates_queue()
      executed_tests = executed_tests + 1
   until executed_tests == 1 --- FIXME all of this
   --- cleanup would be here
end

return mod