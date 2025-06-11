#Requires AutoHotkey v2.0
SetCapsLockState("AlwaysOff")

mouseModeGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "Mouse Mode Indicator")
mouseModeGui.BackColor := "Red"
mouseModeGui.SetFont("s10 bold", "Segoe UI")
mouseModeText := mouseModeGui.Add("Text", "Center vIndicatorText cWhite w100 h30", "MOUSE MODE")
mouseModeGui.Hide()

; -- Remap CapsLock to Esc normally, but double-tap CapsLock to toggle mouse mode --
;capsLastPress := 0
;doubleTapThreshold := 400 ; ms

;Escape::
;{
;    global capsLastPress, mouseModeActive, doubleTapThreshold
;
;    now := A_TickCount
;    if (now - capsLastPress < doubleTapThreshold) {
;        mouseModeActive := !mouseModeActive
;        ToolTip("Mouse Mode: " (mouseModeActive ? "ON" : "OFF"))
;        SetTimer(() => ToolTip(), -1000)
;        capsLastPress := 0  ; Reset to avoid triple-toggle
;    } else {
;        capsLastPress := now
;        Send("{Esc}")
;    }
;    return
;}

; --- Toggle Mouse Mode with Escape + Q ---
Escape & f::
Escape & j::
Escape & k::
Escape & l::
Escape & q::
Escape & a::
{

    global mouseModeActive, mouseModeGui, mouseModeText

    mouseModeActive := !mouseModeActive

    if mouseModeActive {
        mouseModeText.Text := "MOUSE MODE"
        mouseModeGui.Show("x0 y0") ; Top-left corner
	SoundBeep(750, 150)  ; Higher pitch = ON
    } else {
	SoundBeep(500, 150)  ; Lower pitch = OFF
        mouseModeGui.Hide()
    }

    ToolTip("Mouse Mode: " (mouseModeActive ? "ON" : "OFF"))
    SetTimer(() => ToolTip(), -1000)
    return
}

Escape::
{
    Send("{Esc}")
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

$n::
{
    global mouseModeActive
    if !mouseModeActive
        Send("{Blind}n")
    ; else do nothing — suppress in mouse mode
    return
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

dx := dy := 0
if GetKeyState("W", "P")
    dy -= cursorSpeed
if GetKeyState("S", "P")
    dy += cursorSpeed
if GetKeyState("A", "P")
    dx -= cursorSpeed
if GetKeyState("D", "P")
    dx += cursorSpeed
if (dx != 0 || dy != 0)
    MouseMove(dx, dy, 0, "R")


; --- Mouse click and scroll in mode ---
$f::
{
    global mouseModeActive
    if mouseModeActive {
        MouseClick("left",,,,1, "D") ; Press and hold left button
        return
    }
    Send("{Blind}f")
}

$f up::
{
    global mouseModeActive
    if mouseModeActive {
        MouseClick("left",,,,1, "U") ; Release left button
        return
    }
}


$h::
{
    global mouseModeActive
    if mouseModeActive
        Click("right")
    else
        Send("{Blind}h")
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
IsInList(arr, key) {
    for _, val in arr {
        if (val = key)
            return true
    }
    return false
}

mouseModeKeys := ["w","a","s","d","l","f","i","j","k","h", "Space","Escape"]

~*a::
~*b::
~*c::
~*e::
~*g::
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
  global mouseModeActive, mouseModeKeys, mouseModeGui
    if !mouseModeActive
        return

    thisKey := SubStr(A_ThisHotkey, 3) ; Remove ~* prefix
    thisKey := RegExReplace(thisKey, "( up| down)$")

    if !IsInList(mouseModeKeys, thisKey)
    {
        mouseModeActive := false
        mouseModeGui.Hide()
	SoundBeep(500, 150)  ; Lower pitch = OFF
        ToolTip("Exited Mouse Mode (pressed " thisKey ")")
        SetTimer(() => ToolTip(), -1000)
    }
    return
}