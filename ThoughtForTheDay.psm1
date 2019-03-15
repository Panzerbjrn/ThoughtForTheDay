Function Get-ThoughtFortheDay
{
	IF (Test-Path "C:\TEMP\Powershell.Modules\ThoughtForTheDay\Thought.For.The.Day.txt")
		{
			$TFTDArray = Get-Content "C:\TEMP\Powershell.Modules\ThoughtForTheDay\Thought.For.The.Day.txt"
		}
	ELSEIF (Test-Path "$ENV:USERPROFILE\Documents\WindowsPowerShell\Modules\ThoughtForTheDay\Thought.For.The.Day.txt")
		{
			$TFTDArray = Get-Content $ENV:USERPROFILE\Documents\WindowsPowerShell\Modules\ThoughtForTheDay\Thought.For.The.Day.txt
		}
	ELSE {}

	$TFTD = Get-Random $TFTDArray
	Write-Host "Thought for the day:
	$TFTD
	"
}
