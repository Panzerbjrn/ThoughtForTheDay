Function Get-ThoughtFortheDayVoice {
    <#
		.SYNOPSIS
			Describe the function here

		.DESCRIPTION
			Describe the function in more detail

		.EXAMPLE
			Give an example of how to use it

	#>
	[CmdletBinding()]

    param(
        [string]$open = "It is now time for a thought for the day....",
        [int]$rate = 1
    )

    $TFTDArray = Get-Content "$PSScriptRoot\Thought.For.The.Day.txt"
    [string]$Fact = Get-Random $TFTDArray
    $speak ="$open $Fact"
    $v=New-Object -com SAPI.SpVoice
    $voice =$v.getvoices()|where {$_.id -like "*ZIRA*"}
    $v.voice= $voice
    $v.rate=$rate
    [void]$v.speak($speak)
  }
  #catfact