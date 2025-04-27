CUE_OFFSET = 100     -- 100 if your exec start at 101, 160 if 161 so on
MIDI_MODEL = "APCMINI" -- LPMK2 or APCMINI

---comment
---@param row integer
---@param column integer
---@param state string
local function setMidiPad(row, column, state)
    if MIDI_MODEL == "LPMK2" then
        local noteNo = (90 - (row * 10)) + column
        local color = 32
        if state == "on" then
            local result = gma.cmd("midinote " .. noteNo .. " " .. color)
            -- gma.echo("note "..noteNo.."/"..color)
        elseif state == "off" then
            local result = gma.cmd("midinote " .. noteNo .. " " .. " Off")
            -- gma.echo("note "..noteNo.."/ Off")
        end
    elseif MIDI_MODEL == "APCMINI" then
        local noteNo = (8 - row) * 8 + column
        local color = 119
        if state == "on" then
            local result = gma.cmd("midinote " .. noteNo .. " " .. color)
            -- gma.echo("note "..noteNo.."/"..color)
        elseif state == "off" then
            local result = gma.cmd("midinote " .. noteNo .. " " .. " Off")
            -- gma.echo("note "..noteNo.."/ Off")
        end
    end
end

local function getExistExecs()
    local cueTable = {}
    for row = 0, 7, 1 do
        for col = 1, 8, 1 do
            local execNo = CUE_OFFSET + col + (row * 10)
            local handle = gma.show.getobj.handle("Executor 1." .. execNo)
            if handle ~= nil then
                --gma.echo("1."..ex.." is on")
                cueTable[execNo] = "on"
            else
                -- gma.echo("1."..ex.." is off")
                cueTable[execNo] = "off"
            end
        end
    end
    return cueTable
end

---comment
---@param cueTable table
local function syncMidi(cueTable)
    for row = 0, 7, 1 do
        for col = 1, 8, 1 do
            local execNo = CUE_OFFSET + col + (row * 10)
            local state = cueTable[execNo]
            setMidiPad(row + 1, col, state)
        end
    end
end

local function sleep(s)
    local ntime = os.clock() + s
    repeat until os.clock() > ntime
end

local function run()
    while true do
        sleep(0.5)
        local definedExecs = getExistExecs()
        syncMidi(definedExecs)
    end

    -- gma.echo("hi")
    -- os.execute("sleep 3")
    -- gma.echo("mum")
end

return run
