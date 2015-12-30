#a perfectly cromulent script.
function embiggen {
	$pshost = get-host
	$pswindow = $pshost.ui.rawui

	$newsize = $pswindow.buffersize
	$newsize.height = 3000
	$newsize.width = $pswindow.maxphysicalwindowsize.width
	$pswindow.buffersize = $newsize

	$newsize = $pswindow.windowsize
	$newsize.height = $pswindow.maxphysicalwindowsize.height
	$newsize.width = $pswindow.maxphysicalwindowsize.width
	$pswindow.windowsize = $newsize
}