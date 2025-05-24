#Requires AutoHotkey v2.0

; -- Settings --
defaultSpeed := 5
slowSpeed := 1
fastSpeed := 15
cursorSpeed := defaultSpeed

; -- State vars --
mouseModeActive := false
spaceHeld := false
lastSpaceRelease := 0

; -- Timers --
SetTimer(CheckKeys, 10)
SetTimer(CheckMouseModeTimeout, 100)

; --- Activate mouse mode on Space + j ---
~Space & j::
{
    global mouseModeActive
    mouseModeActive := true
    ToolTip("Mouse Mode: ON")
    SetTimer(() => ToolTip(), -1000)
    return
}

; --- Track space key hold/release ---
~Space::
{
    global spaceHeld
    spaceHeld := true
    KeyWait("Space")
    spaceHeld := false
    global lastSpaceRelease := A_TickCount
    return
}

; --- Move mouse only if in mouse mode AND space held ---
CheckKeys() {
    global mouseModeActive, cursorSpeed, spaceHeld, slowSpeed, defaultSpeed, fastSpeed

    if !mouseModeActive || !spaceHeld
        return

    ; Speed adjustments
    if GetKeyState("j", "P") {
        cursorSpeed := slowSpeed
    } else if GetKeyState("k", "P") {
        cursorSpeed := fastSpeed
    } else {
        cursorSpeed := defaultSpeed
    }

    ; Movement
    if GetKeyState("W", "P")
        MouseMove(0, -cursorSpeed, 0, "R")
    if GetKeyState("S", "P")
        MouseMove(0, cursorSpeed, 0, "R")
    if GetKeyState("A", "P")
        MouseMove(-cursorSpeed, 0, 0, "R")
    if GetKeyState("D", "P")
        MouseMove(cursorSpeed, 0, 0, "R")
}

; --- Disable mouse mode if space not held for 500ms ---
CheckMouseModeTimeout() {
    global mouseModeActive, spaceHeld, lastSpaceRelease

    if mouseModeActive && !spaceHeld && (A_TickCount - lastSpaceRelease > 500) {
        mouseModeActive := false
        ToolTip("Mouse Mode: OFF")
        SetTimer(() => ToolTip(), -1000)
    }
}

; --- Movement keys: only send if mouse mode inactive ---
$w::
{
    global mouseModeActive
    if !mouseModeActive {
        Send("{Blind}w")
    }
    return
}

$a::
{
    global mouseModeActive
    if !mouseModeActive {
        Send("{Blind}a")
    }
    return
}

$s::
{
    global mouseModeActive
    if !mouseModeActive {
        Send("{Blind}s")
    }
    return
}

$d::
{
    global mouseModeActive
    if !mouseModeActive {
        Send("{Blind}d")
    }
    return
}

; --- Mouse buttons ---
$f::
{
    global mouseModeActive
    if mouseModeActive {
        Click("left")
        return
    }
    Send("{Blind}f")
}

$i::
{
    global mouseModeActive
    if mouseModeActive {
        Click("right")
        return
    }
    Send("{Blind}i")
}

; --- Scroll down: now on 'n' ---
$n::
{
    global mouseModeActive
    if mouseModeActive {
        Send("{WheelDown}")
        return
    }
    Send("{Blind}n")
}

; --- Scroll up: now on 'l' ---
$l::
{
    global mouseModeActive
    if mouseModeActive {
        Send("{WheelUp}")
        return    
    }
    Send("{Blind}l")
}
