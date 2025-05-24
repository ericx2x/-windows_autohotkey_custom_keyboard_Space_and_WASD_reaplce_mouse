 Capslock::Esc

#Requires AutoHotkey v2.0


CapsLock::Esc

defaultSpeed := 5
slowSpeed := 1
fastSpeed := 15
cursorSpeed := defaultSpeed
spaceHeld := false
mouseModeActive := false

SetTimer(CheckKeys, 10)

*Space::
{
    global spaceHeld

    ; Wait briefly to distinguish tap vs hold
    if KeyWait("Space", "T0.15") {
        ; Key released quickly — treat as tap
        Send(" ")
        return
    }

    ; Otherwise, it's a hold — activate mouse mode
    spaceHeld := true

    ; Wait until key is released
    KeyWait("Space")
    spaceHeld := false
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
