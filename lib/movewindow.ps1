function move-window {
param(
 [int]$newX,
 [int]$newY
) 
BEGIN {
$signature = @'

[DllImport("user32.dll")]
public static extern bool MoveWindow(
    IntPtr hWnd,
    int X,
    int Y,
    int nWidth,
    int nHeight,
    bool bRepaint);

[DllImport("user32.dll")]
public static extern IntPtr GetForegroundWindow();

[DllImport("user32.dll")]
public static extern bool GetWindowRect(
    HandleRef hWnd,
    out RECT lpRect);

public struct RECT
{
    public int Left;        // x position of upper-left corner
    public int Top;         // y position of upper-left corner
    public int Right;       // x position of lower-right corner
    public int Bottom;      // y position of lower-right corner
}

'@

Add-Type -MemberDefinition $signature -Name Wutils -Namespace WindowsUtils

}
PROCESS{
 $phandle = [WindowsUtils.Wutils]::GetForegroundWindow()

 $o = New-Object -TypeName System.Object
 $href = New-Object -TypeName System.RunTime.InteropServices.HandleRef -ArgumentList $o, $phandle

 $rct = New-Object WindowsUtils.Wutils+RECT

 [WindowsUtils.Wutils]::GetWindowRect($href, [ref]$rct)
 
 $width = $rct.Right - $rct.Left
 $height = 700
<#
 $height = $rct.Bottom = $rct.Top
 
 $rct.Right
 $rct.Left
 $rct.Bottom
 $rct.Top
 
 $width
 $height
#> 
 [WindowsUtils.Wutils]::MoveWindow($phandle, $newX, $newY, $width, $height, $true)

} 
}