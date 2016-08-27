#include <GuiConstants.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>

Opt("GuiOnEventMode", 1)

Global $degToRad = 3.14159265358979 / 180
Global $pos45Degrees = Sqrt(2) / 2
Global $nbPoints = 20
Global $nbShades = 20
Global $pointRadius = 2
Global $pointDiameter = $pointRadius * 2
Global $circleRadius = 200
Global $circleDiameter = $circleRadius * 2
Global $circleMargin = 50
Global $windowSize = $circleDiameter + $circleMargin * 2
Global $windowCenter = $windowSize / 2

Global $RadarAngle = 0
Global $shadeAngles[$nbShades], $hBrushes[$nbShades], $RadarPositions[$nbPoints][3]

$NextAngle = 0
For $i = 0 To $nbShades - 1
	$NextAngle += Ceiling(($i ^ Sqrt(3)) / 10)
	$shadeAngles[$nbShades - 1 - $i] = $NextAngle
Next

For $i = 0 To $nbPoints - 1
	$RadarPositions[$i][0] = Random(10, $circleRadius - 10, 1)
	$RadarPositions[$i][1] = Random(0, 359, 1)
	$RadarPositions[$i][2] = -1
Next

$ScrWindow = GUICreate("", $windowSize, $windowSize, 0, 0) ; Create window
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseScreenSaver") ; Listen close event
GUISetState(@SW_SHOW) ; Show window

_GDIPlus_Startup()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($ScrWindow) ; Create graphic from window
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($windowSize, $windowSize, $hGraphic) ; Create buffered bitmap
$hBackBuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap) ; And get its handle

$hPenBorder = _GDIPlus_PenCreate(0xFF00F000) ; Border color
$hBrushBackground = _GDIPlus_BrushCreateSolid(0xFF005000) ; Background color
For $i = 0 To $nbShades - 1
	$hBrushes[$nbShades - 1 - $i] = _GDIPlus_BrushCreateSolid(0xFF00A000 - ($i * (20480 / 20))) ; Shades color
Next
$hPenGrid = _GDIPlus_PenCreate(0xFF00A000) ; Grid color

While 1
	_GDIPlus_GraphicsFillEllipse($hBackBuffer, $circleMargin, $circleMargin, $circleDiameter, $circleDiameter, $hBrushBackground) ; Draw background

	For $i = 0 To $nbShades - 1 ; For each shades
		_GDIPlus_GraphicsFillPie($hBackBuffer, $circleMargin, $circleMargin, $circleDiameter, $circleDiameter, $RadarAngle - $shadeAngles[$i], $shadeAngles[$i], $hBrushes[$i]) ; Draw it
	Next

	For $i = 0 To $nbPoints - 1 ; For each point
		$theta = $RadarAngle + 360
		$point = $RadarPositions[$i][1]
		If $point <= $RadarAngle Then
			$point += 360
		EndIf

		If $point > $RadarAngle + 120 Then
			If $point > $RadarAngle + 240 Then
				$RadarPositions[$i][2] = 1
			Else
				$RadarPositions[$i][2] = 0
			EndIf
		Else
			$RadarPositions[$i][2] = -1
		EndIf

		If $RadarPositions[$i][2] == 0 Then
			_GDIPlus_GraphicsFillEllipse($hBackBuffer, $windowCenter + ($RadarPositions[$i][0] * Cos($RadarPositions[$i][1] * $degToRad)) - $pointRadius, $windowCenter + ($RadarPositions[$i][0] * Sin($RadarPositions[$i][1] * $degToRad)) - $pointRadius, $pointDiameter, $pointDiameter, $hBrushes[9])
		EndIf
		If $RadarPositions[$i][2] == 1 Then
			_GDIPlus_GraphicsFillEllipse($hBackBuffer, $windowCenter + ($RadarPositions[$i][0] * Cos($RadarPositions[$i][1] * $degToRad)) - $pointRadius, $windowCenter + ($RadarPositions[$i][0] * Sin($RadarPositions[$i][1] * $degToRad)) - $pointRadius, $pointDiameter, $pointDiameter, $hBrushes[19])
		EndIf
	Next

	_GDIPlus_GraphicsDrawEllipse($hBackBuffer, $circleMargin + ($circleRadius / 3), $circleMargin + ($circleRadius / 3), $circleDiameter - 2 * ($circleRadius / 3), $circleDiameter - 2 * ($circleRadius / 3), $hPenGrid) ; Draw grid's circles
	_GDIPlus_GraphicsDrawEllipse($hBackBuffer, $circleMargin + 2 * ($circleRadius / 3), $circleMargin + 2 * ($circleRadius / 3), $circleDiameter - 4 * ($circleRadius / 3), $circleDiameter - 4 * ($circleRadius / 3), $hPenGrid)
	_GDIPlus_GraphicsDrawLine($hBackBuffer, $windowCenter - ($pos45Degrees * $circleRadius), $windowCenter - ($pos45Degrees * $circleRadius), $windowCenter + ($pos45Degrees * $circleRadius), $windowCenter + ($pos45Degrees * $circleRadius), $hPenGrid) ; Draw grid's diagonal lines
	_GDIPlus_GraphicsDrawLine($hBackBuffer, $windowCenter + ($pos45Degrees * $circleRadius), $windowCenter - ($pos45Degrees * $circleRadius), $windowCenter - ($pos45Degrees * $circleRadius), $windowCenter + ($pos45Degrees * $circleRadius), $hPenGrid)
	_GDIPlus_GraphicsDrawLine($hBackBuffer, $circleMargin, $windowCenter, $circleMargin + $circleDiameter, $windowCenter, $hPenGrid) ; Draw grid's vertical & horizontal lines
	_GDIPlus_GraphicsDrawLine($hBackBuffer, $windowCenter, $circleMargin, $windowCenter, $circleMargin + $circleDiameter, $hPenGrid)
	_GDIPlus_GraphicsDrawEllipse($hBackBuffer, $circleMargin, $circleMargin, $circleDiameter, $circleDiameter, $hPenBorder) ; Draw border

	_GDIPlus_GraphicsDrawImage($hGraphic, $hBitmap, 0, 0) ; Draw buffered bitmap
	_GDIPlus_GraphicsClear($hBackBuffer) ; Clear buffer

	$RadarAngle += 1
	$RadarAngle = Mod($RadarAngle, 360)
WEnd

_GDIPlus_PenDispose($hPenBorder)
_GDIPlus_BrushDispose($hBrushBackground)
_GDIPlus_PenDispose($hPenGrid)
_GDIPlus_GraphicsDispose($hBackBuffer)
_GDIPlus_BitmapDispose($hBitmap)
_GDIPlus_GraphicsDispose($hGraphic)

Func CloseScreenSaver()
	_GDIPlus_Shutdown()
	Exit
EndFunc
