#include-once
#include <WindowsConstants.au3>
#include <WinAPI.au3>

; #INDEX# =======================================================================================================================
; Title .........: _GuiCtrlSetOnevent
; AutoIt Version : 3.3.14.2
; Language ......: English
; Description ...: Set events on Gui-controls
; Author(s) .....: TarreTarreTarre
; ===============================================================================================================================


; #CONSTANTS# ===================================================================================================================
Global Enum $WM_HOVERIN, $WM_HOVEROUT; yeah these dosent really exist
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__g__guiSetOnEvent_hControl_visited[1] = [0]
Global $__g__guiSetOnEvent_hControl_xCallback[1] = [0]
Global $__g__guiSetOnEvent_hControl_xCallbackData[1] = [0]
Global $__g__guiSetOnEvent_hControl_hWnd[1] = [0]
Global Const $__g__guiSetOnEvent_hMouseKeyProc = DllCallbackRegister("____GUICTRLSetOnEvent_mHook", "long", "int;wparam;lparam")
Global Const $__g__guiSetOnEvent_hMouseHook = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, DllCallbackGetPtr($__g__guiSetOnEvent_hMouseKeyProc), _WinAPI_GetModuleHandle(Null))
OnAutoItExitRegister("____GUISetOnEvent_UnRegisterMouseHookOnExit")

; #FUNCTION# ====================================================================================================================
; Name ..........: _GUICtrlSetOnEvent
; Description ...:
; Syntax ........: _GUICtrlSetOnEvent($iControlId, $xCallback, $xCallbackData, $hWnd)
; Parameters ....: $iControlId          - an integer value.
;                  $xCallback           - an unknown value.
;                  $xCallbackData       - an unknown value.
;                  $hWnd                - a handle value.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GUICtrlSetOnEvent($iControlId, $xCallback, $xCallbackData, $hWnd)
	If Not FuncName($xCallback) Then Return SetError(1, 0, 0)
	If Not IsHWnd($hWnd) Then Return SetError(2, 0, 0)
	$__g__guiSetOnEvent_hControl_visited[0] = $iControlId
	ReDim $__g__guiSetOnEvent_hControl_visited[$iControlId + 1]
	ReDim $__g__guiSetOnEvent_hControl_xCallback[$iControlId + 1]
	ReDim $__g__guiSetOnEvent_hControl_xCallbackData[$iControlId + 1]
	ReDim $__g__guiSetOnEvent_hControl_hWnd[$iControlId + 1]
	$__g__guiSetOnEvent_hControl_visited[$iControlId] = False
	$__g__guiSetOnEvent_hControl_xCallback[$iControlId] = $xCallback
	$__g__guiSetOnEvent_hControl_xCallbackData[$iControlId] = $xCallbackData
	$__g__guiSetOnEvent_hControl_hWnd[$iControlId] = $hWnd
EndFunc   ;==>_GUICtrlSetOnEvent

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: ____GUICTRLSetOnEvent_mHook
; Description ...:
; Syntax ........: ____GUICTRLSetOnEvent_mHook($nCode, $wParam, $lParam)
; Parameters ....: $nCode               - a general number value.
;                  $wParam              - an unknown value.
;                  $lParam              - an unknown value.
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func ____GUICTRLSetOnEvent_mHook($nCode, $wParam, $lParam)
	If $nCode < 0 Then Return _WinAPI_CallNextHookEx($__g__guiSetOnEvent_hMouseHook, $nCode, $wParam, $lParam)
	Local $GUIGetCursorInfo = GUIGetCursorInfo(WinGetHandle("[ACTIVE]"))
	If @error Then Return _WinAPI_CallNextHookEx($__g__guiSetOnEvent_hMouseHook, $nCode, $wParam, $lParam)
	Local Static $prev_CtrlId = Null
	Local $cur_CtrlId = $GUIGetCursorInfo[4]
	If $cur_CtrlId > $__g__guiSetOnEvent_hControl_visited[0] Then Return _WinAPI_CallNextHookEx($__g__guiSetOnEvent_hMouseHook, $nCode, $wParam, $lParam)
	If FuncName($__g__guiSetOnEvent_hControl_xCallback[$cur_CtrlId]) Then
		If $prev_CtrlId > 0 AND $__g__guiSetOnEvent_hControl_visited[$prev_CtrlId] and $prev_CtrlId <> $cur_CtrlId Then
			$__g__guiSetOnEvent_hControl_xCallback[$prev_CtrlId]($WM_HOVEROUT, $prev_CtrlId, $__g__guiSetOnEvent_hControl_xCallbackData[$prev_CtrlId], $__g__guiSetOnEvent_hControl_hWnd[$cur_CtrlId])
			$__g__guiSetOnEvent_hControl_visited[$prev_CtrlId] = False
		ElseIf Not $__g__guiSetOnEvent_hControl_visited[$cur_CtrlId] Then
			$__g__guiSetOnEvent_hControl_xCallback[$cur_CtrlId]($WM_HOVERIN, $cur_CtrlId, $__g__guiSetOnEvent_hControl_xCallbackData[$cur_CtrlId], $__g__guiSetOnEvent_hControl_hWnd[$cur_CtrlId])
			$prev_CtrlId = $cur_CtrlId
			$__g__guiSetOnEvent_hControl_visited[$cur_CtrlId] = True
		EndIf
		Switch $wParam
			Case $WM_LBUTTONDOWN, $WM_LBUTTONUP, $WM_MBUTTONDOWN, $WM_MBUTTONUP, $WM_RBUTTONDOWN, $WM_RBUTTONUP
				$__g__guiSetOnEvent_hControl_xCallback[$cur_CtrlId]($wParam, $cur_CtrlId, $__g__guiSetOnEvent_hControl_xCallbackData[$cur_CtrlId], $__g__guiSetOnEvent_hControl_hWnd[$cur_CtrlId])
		EndSwitch
	ElseIf $prev_CtrlId Then
		$__g__guiSetOnEvent_hControl_xCallback[$prev_CtrlId]($WM_HOVEROUT, $prev_CtrlId, $__g__guiSetOnEvent_hControl_xCallbackData[$prev_CtrlId], $__g__guiSetOnEvent_hControl_hWnd[$cur_CtrlId])
		$__g__guiSetOnEvent_hControl_visited[$prev_CtrlId] = False
		$prev_CtrlId = Null
	EndIf
	Return _WinAPI_CallNextHookEx($__g__guiSetOnEvent_hMouseHook, $nCode, $wParam, $lParam)
EndFunc   ;==>_GUICTRLSetOnEvent_mHook

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: ____GUISetOnEvent_UnRegisterMouseHookOnExit
; Description ...:
; Syntax ........: ____GUISetOnEvent_UnRegisterMouseHookOnExit()
; Parameters ....:
; Return values .: None
; Author ........: TarreTarreTarre
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func ____GUISetOnEvent_UnRegisterMouseHookOnExit()
	_WinAPI_UnhookWindowsHookEx($__g__guiSetOnEvent_hMouseHook)
	DllCallbackFree($__g__guiSetOnEvent_hMouseKeyProc)
EndFunc   ;==>_GUISetOnEvent_UnRegisterMouseHook
