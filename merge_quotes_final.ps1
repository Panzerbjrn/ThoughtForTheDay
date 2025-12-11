# Script to merge quote files - FINAL VERSION
# Leaves Money/Debt and Religion sections untouched
$originalFile = "ThoughtForTheDay\Functions\Thought.For.The.Day.txt"
$newThoughtsFile = "ThoughtForTheDay\Functions\New.Thoughts.For.The.Day.txt"
$newQuotesFile = "WIP\New_Quotes_.txt"
$outputFile = "ThoughtForTheDay\Functions\Thought.For.The.Day.txt.new"

# Read all files
$originalLines = Get-Content -Path $originalFile -Encoding UTF8 | Where-Object { $_.Trim() -ne "" }
$newThoughtsLines = Get-Content -Path $newThoughtsFile -Encoding UTF8 | Where-Object { $_.Trim() -ne "" }
$newQuotesLines = Get-Content -Path $newQuotesFile -Encoding UTF8 | Where-Object { $_.Trim() -ne "" }

# Function to parse quote and attribution
function Parse-Quote {
    param([string]$line)
    
    if ($line -match '^(.+?)\s+-\s+(.+)$') {
        return @{
            FullLine = $line
            Quote = $Matches[1].Trim()
            Attribution = $Matches[2].Trim()
            Length = $line.Length
        }
    }
    else {
        return @{
            FullLine = $line
            Quote = $line.Trim()
            Attribution = ""
            Length = $line.Length
        }
    }
}

# Function to categorize NEW quotes (excluding religion and money/debt)
function Get-QuoteCategory {
    param([hashtable]$parsedQuote)
    
    $lineLower = $parsedQuote.FullLine.ToLower()
    
    # Skip religion quotes - they won't be added
    $religionKeywords = @('religion', 'religious', 'god', 'church', 'faith', 'bible', 'priest', 'christian', 'atheist', 'prayer', 'belief', 'worship', 'allah', 'islam', 'muslim', 'koran')
    foreach ($kw in $religionKeywords) {
        if ($lineLower.Contains($kw)) {
            return 'skip'
        }
    }
    
    # Skip money/debt quotes - they won't be added
    $moneyKeywords = @('debt', 'borrow', 'loan', 'creditor', 'debtor', 'surety')
    foreach ($kw in $moneyKeywords) {
        if ($lineLower.Contains($kw)) {
            return 'skip'
        }
    }
    
    # Check if it's Viking-related
    if ($parsedQuote.Attribution -match '[Vv]iking') {
        if ($parsedQuote.Attribution -match 'Ancient Viking Proverb') {
            return 'ancient_viking_proverb'
        }
        return 'viking'
    }
    
    return 'general'
}

# Parse original quotes to track what we already have
$originalQuotesSet = @{}
foreach ($line in $originalLines) {
    $parsed = Parse-Quote -line $line
    $key = "$($parsed.Quote.ToLower())|$($parsed.Attribution.ToLower())"
    $originalQuotesSet[$key] = $true
}

# Collect new unique quotes (excluding religion and money/debt)
$newAll = $newThoughtsLines + $newQuotesLines
$newQuotes = @{
    'viking' = @()
    'ancient_viking_proverb' = @()
    'general' = @()
}

foreach ($line in $newAll) {
    $parsed = Parse-Quote -line $line
    $key = "$($parsed.Quote.ToLower())|$($parsed.Attribution.ToLower())"
    
    if (-not $originalQuotesSet.ContainsKey($key)) {
        $category = Get-QuoteCategory -parsedQuote $parsed
        if ($category -ne 'skip') {
            $newQuotes[$category] += $parsed
            $originalQuotesSet[$key] = $true
        }
    }
}

# Parse original file into sections BY LINE NUMBER
# Lines 1-42: Viking sayings
# Lines 43-257: Ancient Viking Proverbs
# Lines 258-262: Other cultural proverbs
# Lines 263-877: General quotes
# Lines 878-908: Money & Debt section (KEEP AS-IS)
# Lines 909-964: Religion section (KEEP AS-IS)
# Lines 965-977: Warhammer 40k quotes

$vikingSayings = @()
$ancientVikingProverbs = @()
$culturalProverbs = @()
$generalQuotes = @()
$moneyDebtQuotes = @()
$religionQuotes = @()
$warhammer40kQuotes = @()

for ($i = 0; $i -lt $originalLines.Count; $i++) {
    $lineNum = $i + 1
    $line = $originalLines[$i]
    $parsed = Parse-Quote -line $line
    
    if ($lineNum -le 42) {
        $vikingSayings += $parsed
    }
    elseif ($lineNum -le 257) {
        $ancientVikingProverbs += $parsed
    }
    elseif ($lineNum -le 262) {
        $culturalProverbs += $parsed
    }
    elseif ($lineNum -le 877) {
        $generalQuotes += $parsed
    }
    elseif ($lineNum -le 908) {
        $moneyDebtQuotes += $parsed
    }
    elseif ($lineNum -le 964) {
        $religionQuotes += $parsed
    }
    else {
        $warhammer40kQuotes += $parsed
    }
}

# Add new quotes ONLY to Viking, Ancient Viking Proverbs, and General sections
$vikingSayings += $newQuotes['viking']
$ancientVikingProverbs += $newQuotes['ancient_viking_proverb']
$generalQuotes += $newQuotes['general']

# Sort sections
# Viking sayings - sort by length
$vikingSayings = $vikingSayings | Sort-Object -Property Length

# Ancient Viking Proverbs - sort by length
$ancientVikingProverbs = $ancientVikingProverbs | Sort-Object -Property Length

# General quotes - sort by attribution, then by length
$generalQuotes = $generalQuotes | Sort-Object -Property @{Expression={$_.Attribution}; Ascending=$true}, @{Expression={$_.Length}; Ascending=$true}

# Build output file
$outputLines = @()

# Add Viking sayings
foreach ($q in $vikingSayings) { $outputLines += $q.FullLine }

# Add Ancient Viking Proverbs
foreach ($q in $ancientVikingProverbs) { $outputLines += $q.FullLine }

# Add cultural proverbs (as-is, no sorting)
foreach ($q in $culturalProverbs) { $outputLines += $q.FullLine }

# Add general quotes
foreach ($q in $generalQuotes) { $outputLines += $q.FullLine }

# Add Money & Debt section (UNCHANGED)
foreach ($q in $moneyDebtQuotes) { $outputLines += $q.FullLine }

# Add Religion section (UNCHANGED)
foreach ($q in $religionQuotes) { $outputLines += $q.FullLine }

# Add Warhammer 40k quotes (as-is)
foreach ($q in $warhammer40kQuotes) { $outputLines += $q.FullLine }

# Write output
$outputLines | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "SUCCESS! Merged file created: $outputFile"
Write-Host ""
Write-Host "Summary:"
Write-Host "  Original file had: $($originalLines.Count) quotes"
Write-Host "  New file has: $($outputLines.Count) quotes"
Write-Host "  Total new quotes added: $(($newQuotes.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum)"
Write-Host ""
Write-Host "Breakdown by section:"
Write-Host "  Viking sayings: $($vikingSayings.Count) (added: $($newQuotes['viking'].Count))"
Write-Host "  Ancient Viking Proverbs: $($ancientVikingProverbs.Count) (added: $($newQuotes['ancient_viking_proverb'].Count))"
Write-Host "  Cultural proverbs: $($culturalProverbs.Count) (unchanged)"
Write-Host "  General quotes: $($generalQuotes.Count) (added: $($newQuotes['general'].Count))"
Write-Host "  Money/Debt section: $($moneyDebtQuotes.Count) (unchanged)"
Write-Host "  Religion section: $($religionQuotes.Count) (unchanged)"
Write-Host "  Warhammer 40k: $($warhammer40kQuotes.Count) (unchanged)"
Write-Host ""
Write-Host "To replace the original file, run:"
Write-Host "  Move-Item -Path '$outputFile' -Destination '$originalFile' -Force"

