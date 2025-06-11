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
defaultSpeed := 10
slowSpeed := 3
fastSpeed := 20
cursorSpeed := defaultSpeed

; -- State --
mouseModeActive := false
spaceHeld := false
lHeld := false

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
    global mouseModeActive, cursorSpeed, defaultSpeed, fastSpeed, slowSpeed
    global spaceHeld, lHeld

    if !mouseModeActive
        return

    if GetKeyState("n", "P")
        cursorSpeed := slowSpeed
    else if spaceHeld || lHeld
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

; --- Track space and l keys ---
; Helper function to check if a value is in an array
IsInArray(arr, val) {
    for k, v in arr
        if (v = val)
            return true
    return false
}

$Space::
{
    global mouseModeActive, spaceHeld
    if (mouseModeActive) {
        spaceHeld := true
        KeyWait("Space")
        spaceHeld := false
    } else {
        Send("{Blind} ")
    }
    return
}

$l::
{
    global mouseModeActive, cursorSpeed, fastSpeed, lHeld
    if mouseModeActive {
        cursorSpeed := fastSpeed
        lHeld := true
        return
    }
    Send("{Blind}l")
}
l up::
{
    global mouseModeActive, cursorSpeed, defaultSpeed, lHeld
    if mouseModeActive {
        cursorSpeed := defaultSpeed
        lHeld := false
        return
    }
}

; --- Movement keys ---
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

; --- Mouse click and scroll in mode ---
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

; Alert for any other key pressed in mouse mode

; List of keys used in mouse mode (including space and capslock) so they don't trigger alert
mouseModeKeys := ["w","a","s","d","l","f","i","j","k","Space","CapsLock"]

~*a::
~*b::
~*c::
~*e::
~*g::
~*h::
~*m::
~*n::
~*o::
~*p::
~*q::
~*r::
~*t::
~*u::
~*v::
~*x::
~*y::
~*z::
{
    global mouseModeActive, mouseModeKeys
    if !mouseModeActive
        return

    thisKey := SubStr(A_ThisHotkey, 3) ; Remove ~* prefix

    ; Some keys might have " up" or " down" suffix - strip those
    thisKey := RegExReplace(thisKey, "( up| down)$")

    if !IsInArray(mouseModeKeys, thisKey)
    {
        ToolTip("Mouse Mode is ON - press CapsLock twice to toggle OFF")
        SetTimer(() => ToolTip(), -1000)
    }
    return
}
