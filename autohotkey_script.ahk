 Capslock::Esc

#Requires AutoHotkey v2.0

defaultSpeed := 5
slowSpeed := 1
fastSpeed := 15
cursorSpeed := defaultSpeed
spaceHeld := false
mouseModeActive := false

SetTimer(CheckKeys, 10)

; SPACEBAR - tap vs hold
*Space::
{
    global spaceHeld
    spaceHeld := true

    ; Wait to see if it's a tap
    KeyWait("Space")
    if !GetKeyState("W", "P") && !GetKeyState("A", "P") && !GetKeyState("S", "P") && !GetKeyState("D", "P") &&
       !GetKeyState("J", "P") && !GetKeyState("K", "P") && !GetKeyState("F", "P") && !GetKeyState("I", "P") &&
       !GetKeyState("N", "P") && !GetKeyState("L", "P")
    {
        ; If no control keys pressed, it's a tap, send space
        Send(" ")
    }

    spaceHeld := false
    return
}

CheckKeys() {
    global mouseModeActive, cursorSpeed, spaceHeld

    if spaceHeld {
        mouseModeActive := true

        if GetKeyState("W", "P")
            MouseMove(0, -cursorSpeed, 0, "R")
        if GetKeyState("S", "P")
            MouseMove(0, cursorSpeed, 0, "R")
        if GetKeyState("A", "P")
            MouseMove(-cursorSpeed, 0, 0, "R")
        if GetKeyState("D", "P")
            MouseMove(cursorSpeed, 0, 0, "R")
    } else {
        mouseModeActive := false
    }
}

*n:: {
    global mouseModeActive, cursorSpeed, slowSpeed
    if mouseModeActive {
        cursorSpeed := slowSpeed
        return
    }
    Send("{Blind}n")
}

*n up:: {
    global mouseModeActive, cursorSpeed, defaultSpeed
    if mouseModeActive {
        cursorSpeed := defaultSpeed
        return
    }
}

*l:: {
    global mouseModeActive, cursorSpeed, fastSpeed
    if mouseModeActive {
        cursorSpeed := fastSpeed
        return
    }
    Send("{Blind}l")
}

*l up:: {
    global mouseModeActive, cursorSpeed, defaultSpeed
    if mouseModeActive {
        cursorSpeed := defaultSpeed
        return
    }
}

*w:: {
    global mouseModeActive
    if mouseModeActive
        return
    Send("{Blind}w")
}

*a:: {
    global mouseModeActive
    if mouseModeActive
        return
    Send("{Blind}a")
}

*s:: {
    global mouseModeActive
    if mouseModeActive
        return
    Send("{Blind}s")
}

*d:: {
    global mouseModeActive
    if mouseModeActive
        return
    Send("{Blind}d")
}

*f:: {
    global mouseModeActive
    if mouseModeActive {
        Click("left")
        return
    }
    Send("{Blind}f")
}

*i:: {
    global mouseModeActive
    if mouseModeActive {
        Click("right")
        return
    }
    Send("{Blind}i")
}

*j:: {
    global mouseModeActive
    if mouseModeActive {
        Send("{WheelDown}")
        return
    }
    Send("{Blind}j")
}

*k:: {
    global mouseModeActive
    if mouseModeActive {
        Send("{WheelUp}")
        return
    }
    Send("{Blind}k")
}
   
