#Requires AutoHotkey v2.0

Capslock::Esc

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


;Some kill switches to reload pause or suspend autohotkey - just in case. Press Rshift ? to reload or start the script after 
;pausing, Rshift and > to pause and Rshift and < to suspend.

RShift & /::
{
    ToolTip("Script Reloaded")
    Reload
    SetTimer(() => ToolTip(), -1000)
}

; pause
RShift & .::
{
    ToolTip("AHK " (A_IsPaused ? "RESUMED" : "PAUSED"))
    Pause 
    SetTimer(() => ToolTip(), -1000)
}
return

RShift & ,::ExitApp ;  

RShift & m::
{
    Suspend
    ToolTip("AHK " (A_IsSuspended ? "SUSPENDED" : "RESUMED"))
    SetTimer(() => ToolTip(), -1000)
}

; --- Activate mouse mode on Space keys ---
~Space & n::EnableMouseMode()
~Space & v::EnableMouseMode()
~Space & w::EnableMouseMode(false)
~Space & a::EnableMouseMode(false)
~Space & s::EnableMouseMode(false)
~Space & d::EnableMouseMode(false)



EnableMouseMode(showTip := true) {
    global mouseModeActive
    mouseModeActive := true
    if showTip {
      ToolTip("Mouse Mode: ON")
      SetTimer(() => ToolTip(), -1000)
    }
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

    ; Slow speed if n is held
    if GetKeyState("n", "P") {
        cursorSpeed := slowSpeed
    } 
    ; Fast speed if l is held
    else if GetKeyState("l", "P") {
        cursorSpeed := fastSpeed
    } 
    else {
        cursorSpeed := defaultSpeed
    }

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

; --- Adjust cursor speed with n and l keys when mouse mode active (n for is hanleded in the CheckKeys function) ---

$l::
{
    global mouseModeActive, cursorSpeed, fastSpeed
    if mouseModeActive {
        cursorSpeed := fastSpeed
        return
    }
    Send("{Blind}l")
}

l up::
{
    global mouseModeActive, cursorSpeed, defaultSpeed
    if mouseModeActive {
        cursorSpeed := defaultSpeed
        return
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

; --- Mouse buttons and wheel: act only if mouse mode active ---
$f::
{
    global spaceHeld
    
    if spaceHeld {
        MouseClick("left", , , 1, , "D")  ; Press and hold left mouse button
        return
    }
    Send("{Blind}f")
}

$f up::
{
    if spaceHeld {
        MouseClick("left", , , 1, , "U")  ; Release left mouse button
        return
    }
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

$j::
{
    global mouseModeActive
    if mouseModeActive {
        Send("{WheelDown}")
        return
    }
    Send("{Blind}j")
}

$k::
{
    global mouseModeActive
    if mouseModeActive {
        Send("{WheelUp}")
        return    
    }
    Send("{Blind}k")
}
 
