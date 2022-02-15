Function Get-ThoughtFortheDayVoice {
    param(
        [string]$open = "It is now time for a thought for the day....",
        [int]$rate = 1
    )

    $TFTDArray = Get-Content "$PSScriptRoot\Thought.For.The.Day.txt"
    [string]$fact = Get-Random $TFTDArray
    $speak ="$open $fact"
    $v=New-Object -com SAPI.SpVoice
    $voice =$v.getvoices()|where {$_.id -like "*ZIRA*"}
    $v.voice= $voice
    $v.rate=$rate
    [void]$v.speak($speak)
  }
  #catfact