Function Get-ThoughtFortheDay{
		<#
		.SYNOPSIS
			Describe the function here

		.DESCRIPTION
			Describe the function in more detail

		.EXAMPLE
			Give an example of how to use it

	#>


	$TFTDArray = Get-Content "$PSScriptRoot\Thought.For.The.Day.txt"
	$TFTD = Get-Random $TFTDArray
	Write-Output "Thought for the day:
	$TFTD
	"
}
