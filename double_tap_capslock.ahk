#Requires AutoHotkey v2.0

; -- Remap CapsLock to Esc normally, but double-tap CapsLock to toggle mouse mode --
capsLastPress := 0
doubleTapThreshold := 400 ; ms

CapsLock::
{
    global capsLastPress, mouseModeActive, doubleTapThreshold

    now := A_TickCount
    if (now - capsLastPress < doubleTapThreshold) {
        mouseModeActive := !mouseModeActive
        ToolTip("Mouse Mode: " (mouseModeActive ? "ON" : "OFF"))
        SetTimer(() => ToolTip(), -1000)
        capsLastPress := 0  ; Reset to avoid triple-toggle
    } else {
        capsLastPress := now
        Send("{Esc}")
    }
    return
}

; -- Settings --
defaultSpeed := 5
slowSpeed := 1
fastSpeed := 15
cursorSpeed := defaultSpeed

; -- State --
mouseModeActive := false

; -- Timers --
SetTimer(CheckKeys, 10)

; --- Kill switches ---
RShift & /::Reload
RShift & .::Pause
RShift & ,::ExitApp
RShift & m::
{
    Suspend
    ToolTip("AHK " (A_IsSuspended ? "SUSPENDED" : "RESUMED"))
    SetTimer(() => ToolTip(), -1000)
}

; --- Mouse movement logic ---
CheckKeys() {
    global mouseModeActive, cursorSpeed, defaultSpeed, fastSpeed

    if !mouseModeActive
        return

    if GetKeyState("n", "P")
        cursorSpeed := slowSpeed
    else if GetKeyState("l", "P")
        cursorSpeed := fastSpeed
    else
        cursorSpeed := defaultSpeed

    if GetKeyState("W", "P")
        MouseMove(0, -cursorSpeed, 0, "R")
    if GetKeyState("S", "P")
        MouseMove(0, cursorSpeed, 0, "R")
    if GetKeyState("A", "P")
        MouseMove(-cursorSpeed, 0, 0, "R")
    if GetKeyState("D", "P")
        MouseMove(cursorSpeed, 0, 0, "R")
}

; --- Key behavior based on mode ---
$w::
{
    global mouseModeActive
    if !mouseModeActive
        Send("{Blind}w")
}
$a::
{
    global mouseModeActive
    if !mouseModeActive
        Send("{Blind}a")
}
$s::
{
    global mouseModeActive
    if !mouseModeActive
        Send("{Blind}s")
}
$d::
{
    global mouseModeActive
    if !mouseModeActive
        Send("{Blind}d")
}

; --- Speed key ---
$l::
{
    global mouseModeActive, cursorSpeed, fastSpeed
    if mouseModeActive
        cursorSpeed := fastSpeed
    else
        Send("{Blind}l")
}
l up::
{
    global mouseModeActive, cursorSpeed, defaultSpeed
    if mouseModeActive
        cursorSpeed := defaultSpeed
}

; --- Mouse click and scroll in mode ---
$f::
{
    global mouseModeActive
    if mouseModeActive {
        Click("left")
        return
    }
    Send("{Blind}f")
} n

$i::
{
    global mouseModeActive
    if mouseModeActive
        Click("right")
    else
        Send("{Blind}i")
}
$j::
{
    global mouseModeActive
    if mouseModeActive
        Send("{WheelDown}")
    else
        Send("{Blind}j")
}
$k::
{
    global mouseModeActive
    if mouseModeActive
        Send("{WheelUp}")
    else
        Send("{Blind}k")
}
