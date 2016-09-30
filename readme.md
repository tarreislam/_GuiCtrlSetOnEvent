[Official Thread](https://www.autoitscript.com/forum/topic/184678-an-improved-guictrlsetonevent/)

#### GOOD 2 KNOW
* `GuiDelete($hWnd)` used together with **$WM_LBUTTONUP** will cause the AutoIt script to crash
* **$WM_HOVERIN** and **$WM_HOVEROUT** ARE NOT real [Windows Message Codes](https://www.autoitscript.com/autoit3/docs/appendix/WinMsgCodes.htm) and will only work with with this UDF
* Your callback functions MUST have 4 parameters assigned to it, like this:
```
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
```
