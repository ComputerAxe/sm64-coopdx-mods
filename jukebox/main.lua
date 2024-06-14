-- name: Jukebox
-- description: Plays music from a file. \n Test.ogg by i don't know

local curMusPlaying = false
local curMusAudio = nil
local curMusFile = nil
local curMusLoops = true

--Blatantly stolen from nametags
local function split(s)
    local result = {}
    for match in (s):gmatch(string.format("[^%s]+", " ")) do
        table.insert(result, match)
    end
    return result
end

function cmdJukePlay(msg)
    if curMusPlaying and curMusAudio ~= nil then
        audio_stream_stop(curMusAudio)
    end
    local args = split(msg)
    if (args[1] == "" or args[1] == nil) then
        djui_chat_message_create("\\#E40000\\No Audio File Given!")
    else
        curMusFile = args[1]
        if (string.find(curMusFile, ".mp3") or string.find(curMusFile, ".ogg") or string.find(curMusFile, ".aiff")) then
            curMusAudio = audio_stream_load(curMusFile)
        else
            curMusAudio = audio_stream_load(curMusFile .. ".mp3")
        end

        if curMusAudio == nil then
            djui_chat_message_create("\\#E40000\\File not loaded- either did not exist, or was not an MP3!")
        else
            if args[2] ~= nil then
                local repeatString = string.lower(args[2])
                if repeatString == "true" then
                    curMusLoops = true
                elseif repeatString == "false" then
                    curMusLoops = false
                end
            end
            audio_stream_set_looping(curMusAudio, curMusLoops)
            audio_stream_play(curMusAudio, true, 1)
            djui_popup_create("Music File \"" .. curMusFile .. "\" Now Playing!", 1)
            curMusPlaying = true
        end
    end
    return true
end

function cmdJukePause()
    if curMusAudio == nil then
        djui_chat_message_create("\\#E40000\\Nothing To Pause!")
    elseif curMusPlaying then
        audio_stream_pause(curMusAudio)
        djui_popup_create("Music File \"" .. curMusFile .. "\" Now Paused!", 1)
    else
        audio_stream_play(curMusAudio, true, 1)
        djui_popup_create("Music File \"" .. curMusFile .. "\" Now Resumed!", 1)
    end
    return true
end

function cmdJukeStop()
    if curMusAudio ~= nil and curMusPlaying then
        audio_stream_stop(curMusAudio)
        audio_stream_destroy(curMusAudio)
        curMusAudio = nil
        curMusPlaying = false
        djui_popup_create("Music File \"" .. curMusFile .. "\" Stopped and unloaded!", 1)
    else
        djui_chat_message_create("\\#E40000\\Nothing To Stop!")
    end
    return true
end

function on_warp()
    if curMusPlaying and curMusLoops then
        if curMusFile ~= nil and (string.find(curMusFile, ".mp3") or string.find(curMusFile, ".ogg") or string.find(curMusFile, ".aiff")) then
            curMusAudio = audio_stream_load(curMusFile)
        else
            curMusAudio = audio_stream_load(curMusFile .. ".mp3")
        end
        audio_stream_set_looping(curMusAudio, true)
        audio_stream_play(curMusAudio, true, 1)
    end
end

hook_event(HOOK_ON_WARP, on_warp)
hook_chat_command("jukeplay", "[SONGNAME] Loops: [true|false]", cmdJukePlay)
hook_chat_command("jukepause", "Pauses/resumes current loaded music file.", cmdJukePause)
hook_chat_command("jukestop", "Stops the current loaded music file.", cmdJukeStop)
