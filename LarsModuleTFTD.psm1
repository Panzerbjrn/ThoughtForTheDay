Function Get-ThoughtFortheDay
{
	$TFTDArray = Get-Content "$PSScriptRoot\Thought.For.The.Day.txt"
	$TFTD = Get-Random $TFTDArray
	Write-Output "Thought for the day:
	$TFTD
	"
}
