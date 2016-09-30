#include <_GuiCtrlSetOnEvent.au3>

; Regular GUI
Local $hGUI = GUICreate("Example 1", 200, 75)

; Regular button
Local $hBtn = GUICtrlCreateButton("Violate me", 25, 25, 150, 25)

; Bind control to another function named "MyCallBackFunction"
_GUICtrlSetOnEvent($hBtn, MyCallBackFunction, "Any sort of data, strings, arrays etc...", $hGUI)

If @error Then
	Switch @error
		Case 1
			MsgBox(0,0, "No valid callback function was given")
		Case 2
			MsgBox(0,0, "No valid hWnd passed")
	EndSwitch
EndIf

GUISetState()

While GUIGetMsg() <> -3

WEnd

Func MyCallBackFunction(Const $wParam, ByRef $iCtrlId, ByRef $uData, ByRef $hWnd)

	Switch $wParam
		Case $WM_HOVERIN
			ConsoleWrite("Entering control; attached data = " & $uData & @CRLF)
		Case $WM_HOVEROUT
			ConsoleWrite("Leaving control" & @CRLF)
		Case $WM_LBUTTONDOWN
			ConsoleWrite("Left mousebutton DOWN" & @CRLF)
		Case $WM_LBUTTONUP
			ConsoleWrite("Left mousebutton UP" & @CRLF)
		Case $WM_MBUTTONDOWN
			ConsoleWrite("Middle mousebutton DOWN" & @CRLF)
		Case $WM_MBUTTONUP
			ConsoleWrite("Middle mousebutton UP" & @CRLF)
		Case $WM_RBUTTONDOWN
			ConsoleWrite("Right mousebutton DOWN" & @CRLF)
		Case $WM_RBUTTONUP
			ConsoleWrite("Right mousebutton UP" & @CRLF)
	EndSwitch

EndFunc