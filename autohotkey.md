# OneForAll script

```
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; run Ubuntu app

^u::
Run Ubuntu
return

; change screen resolution from 100% to 150% and back

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

; Steven's code
; - Google search the text that is currently selected: Win+g.
;   If a URL-like string is selected, opens this URL instead.
;   If nothing is selected, opens a new Google tab.
; - Google search with automatic I'm Feeling Lucky forwarding: Win+Alt+g.
; - Open with Duckduckgo instead: Win+Ctrl+g.
#g::
#!g::
#^g::
  ctrlPressed := GetKeyState("Ctrl") ? 1 : 0
  altPressed  := GetKeyState("Alt")  ? 1 : 0
  text := GetSelectedText()
  openUrl := 0
  If SubStr(text, 1, 7) = "http://" or  SubStr(text, 1, 8) = "https://"
    openUrl := 1
  If openUrl=1
    Run % """C:\Program Files (x86)\Mozilla Firefox\firefox.exe"" """ . text . """"
  Else If ctrlPressed=1
    Run % "https://www.duckduckgo.com/?q=" . UriEncode(text)
  Else If altPressed=1
    Run % "https://www.google.com/search?ncr&complete=0&q=" . UriEncode(text) . "&btnI"
  Else
    Run % "https://www.google.com/search?ncr&complete=0&q=" . UriEncode(text)
  Sleep, 1000
  WinActivate ahk_exe firefox.exe
  Return


GetSelectedText() {
  tmp = %Clipboard%  ; Backup old clipboard contents.
  Clipboard =           ; Clear clipboard.
  Send, ^c              ; Simulate Ctrl+C (=copy selection into clipboard).
  ClipWait, 0.05         ; Wait until clipboard contains data.
  selection = %Clipboard%  ; Get the new clipboard content.
  Clipboard = %tmp%        ; Restore old clipboard content.
  Return selection
}


UriEncode(Uri, Enc = "UTF-8") {  ; See https://autohotkey.com/board/topic/75390-ahk-l-unicode-uri-encode-url-encode-function/
	Len := StrPut(Uri, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
	VarSetCapacity(Var, Len, 0)
	StrPut(Uri, &Var, Enc)
	f := A_FormatInteger
	SetFormat, IntegerFast, H
	Loop {
		Code := NumGet(Var, A_Index - 1, "UChar")
		If (!Code)
			Break
		If (Code >= 0x30 && Code <= 0x39 ; 0-9
			|| Code >= 0x41 && Code <= 0x5A ; A-Z
			|| Code >= 0x61 && Code <= 0x7A) ; a-z
			Res .= Chr(Code)
		Else
			Res .= "%" . SubStr(Code + 0x100, -1)
	}
	SetFormat, IntegerFast, %f%
	Return, Res
}

```
