# Change the screen scaling

```
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^r::
Run control desk.cpl
Sleep, 1500
Send {tab}
Send {Space}
Send {Down 2}
Send {Enter}
Sleep, 500
Send !{F4}
return

^e::
Run control desk.cpl
Sleep, 1500
Send {tab}
Send {Space}
Send {Up 2}
Send {Enter}
Sleep, 500
Send !{F4}
return

```
