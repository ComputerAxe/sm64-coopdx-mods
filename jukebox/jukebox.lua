-- name: Jukebox
-- description: Plays music from a file. \n Test.ogg by i don't know

local cmd_active = false
local currentaudio = nil
local curmusfilename = nil

--Blatantly stolen from nametags
local function split(s)
    local result = {}
    for match in (s):gmatch(string.format("[^%s]+", " ")) do
        table.insert(result, match)
    end
    return result
end

function cmd_jukeplay(msg)
    if cmd_active and currentaudio ~= nil then
        audio_stream_stop(currentaudio)
    end
    local args = split(msg)
    if (args[1] == "" or args[1] == nil) then
        djui_chat_message_create("\\#E40000\\No Audio File Given!")
    else
        curmusfilename = args[1]
        if (string.find(curmusfilename, ".mp3") or string.find(curmusfilename, ".ogg") or string.find(curmusfilename, ".aiff")) then
            currentaudio = audio_stream_load(curmusfilename)
        else
            currentaudio = audio_stream_load(curmusfilename .. ".mp3")
        end

        if currentaudio == nil then
            djui_chat_message_create("\\#E40000\\File not loaded- either did not exist, or was not an MP3!")
        else
            audio_stream_set_looping(currentaudio, true)
            audio_stream_play(currentaudio, true, 1)
        end
        cmd_active = true
    end
    return true
end

function on_warp()
    if cmd_active then
        if (string.find(curmusfilename, ".mp3") or string.find(curmusfilename, ".ogg") or string.find(curmusfilename, ".aiff")) then
            currentaudio = audio_stream_load(curmusfilename)
        else
            currentaudio = audio_stream_load(curmusfilename .. ".mp3")
        end
        audio_stream_set_looping(currentaudio, true)
        audio_stream_play(currentaudio, true, 1)
    end
end

hook_event(HOOK_ON_WARP, on_warp)
hook_chat_command("jukeplay", "[SONGNAME] Loops: [true|false]", cmd_jukeplay)
