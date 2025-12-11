# Script to merge and sort quote files - CORRECTED VERSION
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

# Function to categorize NEW quotes only
function Get-QuoteCategory {
    param([hashtable]$parsedQuote)
    
    $lineLower = $parsedQuote.FullLine.ToLower()
    
    # Check if it's a religion quote
    $religionKeywords = @('religion', 'religious', 'god', 'church', 'faith', 'bible', 'priest', 'christian', 'atheist', 'prayer', 'belief', 'worship', 'allah', 'islam', 'muslim', 'koran')
    foreach ($kw in $religionKeywords) {
        if ($lineLower.Contains($kw)) {
            return 'religion'
        }
    }
    
    # Check if it's a money/debt quote
    $moneyKeywords = @('debt', 'borrow', 'loan', 'creditor', 'debtor', 'surety')
    foreach ($kw in $moneyKeywords) {
        if ($lineLower.Contains($kw)) {
            return 'money_debt'
        }
    }
    
    # Check if it's Viking-related (Viking saying or Ancient Viking Proverb)
    if ($parsedQuote.Attribution -match '[Vv]iking') {
        if ($parsedQuote.Attribution -match 'Ancient Viking Proverb') {
            return 'ancient_viking_proverb'
        }
        return 'viking'
    }
    
    # Check if it's Warhammer 40k related
    $wh40kKeywords = @('magnus the red', 'primarch', 'vulkan', 'rogal dorn', 'puretide', 'ciaphais cain', 'taghmata dominata', 'dark angels', "o'shovah", 'imperial fists', 'shadrak meduson', 'kolo,')
    foreach ($kw in $wh40kKeywords) {
        if ($lineLower.Contains($kw)) {
            return 'warhammer40k'
        }
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

# Collect new unique quotes
$newAll = $newThoughtsLines + $newQuotesLines
$newQuotes = @{
    'viking' = @()
    'ancient_viking_proverb' = @()
    'money_debt' = @()
    'religion' = @()
    'warhammer40k' = @()
    'general' = @()
}

foreach ($line in $newAll) {
    $parsed = Parse-Quote -line $line
    $key = "$($parsed.Quote.ToLower())|$($parsed.Attribution.ToLower())"
    
    if (-not $originalQuotesSet.ContainsKey($key)) {
        $category = Get-QuoteCategory -parsedQuote $parsed
        $newQuotes[$category] += $parsed
        $originalQuotesSet[$key] = $true
    }
}

# Parse original file into sections BY LINE NUMBER (not by content detection)
# Structure from the original file:
# Lines 1-42: Viking sayings
# Lines 43-257: Ancient Viking Proverbs
# Lines 258-262: Other cultural proverbs
# Lines 263-877: Various attributed quotes (general section)
# Lines 878-908: Money & Debt section (SPECIAL - keep separate)
# Lines 909-964: Religion section (SPECIAL - keep separate)
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
    
    # Assign to sections based on line number
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

# Add new quotes to appropriate sections
$vikingSayings += $newQuotes['viking']
$ancientVikingProverbs += $newQuotes['ancient_viking_proverb']
$moneyDebtQuotes += $newQuotes['money_debt']
$religionQuotes += $newQuotes['religion']
$warhammer40kQuotes += $newQuotes['warhammer40k']
$generalQuotes += $newQuotes['general']

# Sort each section appropriately
# Viking sayings - sort by length
$vikingSayings = $vikingSayings | Sort-Object -Property Length

# Ancient Viking Proverbs - sort by length
$ancientVikingProverbs = $ancientVikingProverbs | Sort-Object -Property Length

# Cultural proverbs - keep as is (no sort, maintain original order)

# Money/Debt - sort by length
$moneyDebtQuotes = $moneyDebtQuotes | Sort-Object -Property Length

# Religion - sort by length
$religionQuotes = $religionQuotes | Sort-Object -Property Length

# Warhammer 40k - sort by length
$warhammer40kQuotes = $warhammer40kQuotes | Sort-Object -Property Length

# General quotes - sort by attribution, then by length within each attribution
$generalQuotes = $generalQuotes | Sort-Object -Property @{Expression={$_.Attribution}; Ascending=$true}, @{Expression={$_.Length}; Ascending=$true}

# Build output file
$outputLines = @()

# Add Viking sayings
foreach ($q in $vikingSayings) { $outputLines += $q.FullLine }

# Add Ancient Viking Proverbs
foreach ($q in $ancientVikingProverbs) { $outputLines += $q.FullLine }

# Add cultural proverbs
foreach ($q in $culturalProverbs) { $outputLines += $q.FullLine }

# Add general quotes
foreach ($q in $generalQuotes) { $outputLines += $q.FullLine }

# Add Money & Debt section
foreach ($q in $moneyDebtQuotes) { $outputLines += $q.FullLine }

# Add Religion section
foreach ($q in $religionQuotes) { $outputLines += $q.FullLine }

# Add Warhammer 40k quotes
foreach ($q in $warhammer40kQuotes) { $outputLines += $q.FullLine }

# Write output
$outputLines | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Merged file created: $outputFile"
Write-Host "Original quotes: $($originalLines.Count)"
Write-Host "Total quotes in new file: $($outputLines.Count)"
Write-Host ""
Write-Host "Section breakdown:"
Write-Host "  Viking sayings: $($vikingSayings.Count) (added: $($newQuotes['viking'].Count))"
Write-Host "  Ancient Viking Proverbs: $($ancientVikingProverbs.Count) (added: $($newQuotes['ancient_viking_proverb'].Count))"
Write-Host "  Cultural proverbs: $($culturalProverbs.Count)"
Write-Host "  General quotes: $($generalQuotes.Count) (added: $($newQuotes['general'].Count))"
Write-Host "  Money/Debt quotes: $($moneyDebtQuotes.Count) (added: $($newQuotes['money_debt'].Count))"
Write-Host "  Religion quotes: $($religionQuotes.Count) (added: $($newQuotes['religion'].Count))"
Write-Host "  Warhammer 40k quotes: $($warhammer40kQuotes.Count) (added: $($newQuotes['warhammer40k'].Count))"
Write-Host ""
Write-Host "Please review the new file and if satisfied, replace the original:"
Write-Host "  Move-Item -Path '$outputFile' -Destination '$originalFile' -Force"

