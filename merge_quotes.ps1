# Read all three files
$originalFile = "ThoughtForTheDay\Functions\Thought.For.The.Day.txt"
$newThoughtsFile = "ThoughtForTheDay\Functions\New.Thoughts.For.The.Day.txt"
$newQuotesFile = "WIP\New_Quotes_.txt"

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

# Function to categorize quotes
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
    
    # Check if it's Viking-related
    if ($parsedQuote.Attribution -match '[Vv]iking') {
        return 'viking'
    }
    
    return 'general'
}

# Parse original quotes
$originalQuotesSet = @{}
foreach ($line in $originalLines) {
    $parsed = Parse-Quote -line $line
    $key = "$($parsed.Quote.ToLower())|$($parsed.Attribution.ToLower())"
    $originalQuotesSet[$key] = $true
}

# Find new unique quotes
$newAll = $newThoughtsLines + $newQuotesLines
$newByCategory = @{
    'viking' = @()
    'money_debt' = @()
    'religion' = @()
    'general' = @()
}

foreach ($line in $newAll) {
    $parsed = Parse-Quote -line $line
    $key = "$($parsed.Quote.ToLower())|$($parsed.Attribution.ToLower())"
    
    if (-not $originalQuotesSet.ContainsKey($key)) {
        $category = Get-QuoteCategory -parsedQuote $parsed
        $newByCategory[$category] += $parsed
        $originalQuotesSet[$key] = $true
    }
}

Write-Host "Original quotes: $($originalLines.Count)"
Write-Host "Total new unique quotes to add: $(($newByCategory.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum)"
Write-Host ""
Write-Host "New quotes by category:"
foreach ($cat in @('viking', 'money_debt', 'religion', 'general')) {
    $count = $newByCategory[$cat].Count
    if ($count -gt 0) {
        Write-Host "  ${cat}: $count quotes"
    }
}

# Group general quotes by attribution
$generalByAttr = @{}
foreach ($quote in $newByCategory['general']) {
    $attr = $quote.Attribution
    if ($attr -ne "") {
        if (-not $generalByAttr.ContainsKey($attr)) {
            $generalByAttr[$attr] = @()
        }
        $generalByAttr[$attr] += $quote
    }
}

if ($generalByAttr.Count -gt 0) {
    Write-Host ""
    Write-Host "General quotes by attribution:"
    $generalByAttr.GetEnumerator() | Sort-Object Name | ForEach-Object {
        Write-Host "  $($_.Name): $($_.Value.Count) quotes"
    }
}

