#Requires AutoHotkey v2.0
CapsLock::Esc

defaultSpeed := 5
slowSpeed := 1
fastSpeed := 15
cursorSpeed := defaultSpeed
spaceHeld := false
mouseModeActive := false
mouseModeEnabled := true ; Toggle for space mouse mode

SetTimer(CheckKeys, 10)

; Toggle mouse mode with Right Shift + ?
>?:: {
    global mouseModeEnabled
    if GetKeyState("RShift", "P") {
        mouseModeEnabled := !mouseModeEnabled
        ToolTip("Mouse Mode: " (mouseModeEnabled ? "ON" : "OFF"))
        SetTimer(() => ToolTip(), -1000)
    } else {
        Send("/")
    }
}

*Space:: {
    global spaceHeld, mouseModeEnabled

    if KeyWait("Space", "T0.15") {
        Send(" ")
        return
    }

    if !mouseModeEnabled {
        return
    }

    spaceHeld := true
    KeyWait("Space")
    spaceHeld := false
}

CheckKeys() {
    global mouseModeActive, cursorSpeed, spaceHeld, mouseModeEnabled

    if !mouseModeEnabled {
        mouseModeActive := false
        return
    }

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

handleKey(keyName) {
    global mouseModeActive
    if mouseModeActive
        return
    Send("{Blind}" keyName)
}

*n:: {
    global mouseModeActive, cursorSpeed, slowSpeed
    if mouseModeActive {
        cursorSpeed := slowSpeed
    } else {
        handleKey("n")
    }
}

*n up:: {
    global mouseModeActive, cursorSpeed, defaultSpeed
    if mouseModeActive {
        cursorSpeed := defaultSpeed
    }
}

*l:: {
    global mouseModeActive, cursorSpeed, fastSpeed
    if mouseModeActive {
        cursorSpeed := fastSpeed
    } else {
        handleKey("l")
    }
}

*l up:: {
    global mouseModeActive, cursorSpeed, defaultSpeed
    if mouseModeActive {
        cursorSpeed := defaultSpeed
    }
}

*w:: {
    handleKey("w")
}

*a:: {
    handleKey("a")
}

*s:: {
    handleKey("s")
}

*d:: {
    handleKey("d")
}

*f:: {
    global mouseModeActive
    if mouseModeActive {
        Click("left")
    } else {
        handleKey("f")
    }
}

*i:: {
    global mouseModeActive
    if mouseModeActive {
        Click("right")
    } else {
        handleKey("i")
    }
}

*j:: {
    global mouseModeActive
    if mouseModeActive {
        Send("{WheelDown}")
    } else {
        handleKey("j")
    }
}

*k:: {
    global mouseModeActive
    if mouseModeActive {
        Send("{WheelUp}")
    } else {
        handleKey("k")
    }
}
