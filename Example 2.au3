#include <_GuiCtrlSetOnEvent.au3>

; Regular GUI
Local $aForm[4]; In here we store our inputs
Local $hGUI = GUICreate("Posting form", 168, 267, 479, 379)


; Add some labels
GUICtrlCreateLabel("Surname", 16, 0, 46, 17)
GUICtrlCreateLabel("Lastname", 16, 56, 50, 17)
GUICtrlCreateLabel("Radius", 16, 168, 37, 17)
GUICtrlCreateLabel("E-mail", 16, 112, 32, 17)

; Create some inputs
$aForm[0] = GUICtrlCreateInput("", 16, 24, 121, 21)
$aForm[1] = GUICtrlCreateInput("", 16, 80, 121, 21)
$aForm[2] = GUICtrlCreateInput("", 16, 136, 121, 21)
$aForm[3] = GUICtrlCreateSlider(8, 192, 150, 45)

;Show the gui
GUISetState(@SW_SHOW, $hGUI)

; Create some button
Local $hBtn = GUICtrlCreateButton("Post", 16, 230, 121, 25)

; Bind control to another function named "MyCallbackForm" and pass our Inputs to that function.
_GUICtrlSetOnEvent($hBtn, MyCallbackForm, $aForm, $hGUI)

; Possible failures on _GUICtrlSetOnEvent
If @error Then
	Switch @error
		Case 1
			MsgBox(0,0, "No valid callback function was given")
		Case 2
			MsgBox(0,0, "No valid hWnd passed")
	EndSwitch
EndIf

While GUIGetMsg() <> -3
WEnd

Func MyCallbackForm(Const $wParam, ByRef $iCtrlId, ByRef $uData, ByRef $hWnd)

	Switch $wParam
		Case $WM_LBUTTONUP
			Local $error = ""

			; Our controls and data read from each input
			Local Const $Surname_Ctrl = $uData[0], $Surname = GUICtrlRead($Surname_Ctrl)
			Local Const $Lastname_Ctrl = $uData[1], $Lastname = GUICtrlRead($Lastname_Ctrl)
			Local Const $Email_Ctrl = $uData[2], $Email = GUICtrlRead($Email_Ctrl)
			Local Const $Radius_Ctrl = $uData[3], $Radius = GUICtrlRead($Radius_Ctrl)

			If StringLen($Surname) < 5 Then
				GUICtrlSetBkColor($Surname_Ctrl, 0xFFF333)
				$error &= "The surname cannot be less than 5 chars" & @CRLF
			Else
				GUICtrlSetBkColor($Surname_Ctrl, 0xFFFFFF)
			EndIf

			If StringLen($Lastname) < 5 Then
				GUICtrlSetBkColor($Lastname_Ctrl, 0xFFF333)
				$error &= "The lastname cannot be less than 5 chars" & @CRLF
			Else
				GUICtrlSetBkColor($Lastname_Ctrl, 0xFFFFFF)
			EndIf

			If Not StringRegExp($Email, "(?i)[a-z .0-9\-_]+\@[a-z .0-9\-_]+\.[a-z0-9.]+") Then
				GUICtrlSetBkColor($Email_Ctrl, 0xFFF333)
				$error &= $Email & " is not a valid E-mail adress" & @CRLF
			Else
				GUICtrlSetBkColor($Email_Ctrl, 0xFFFFFF)
			EndIf

			; If no errors, then we show the GUI
			If Not $error Then
				MsgBox(0,0, "Surname: " & $Surname & @CRLF & _
				"Lastname: " & $Lastname & @CRLF & _
				"E-mail: " & $Email & @CRLF & _
				"Radius: " & $Radius)
			Else
				MsgBox(0,"Something went wrong", $error)
			EndIf
	EndSwitch

EndFunc