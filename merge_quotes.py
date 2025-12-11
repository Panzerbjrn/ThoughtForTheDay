import re
from collections import defaultdict

# Read all three files
with open('ThoughtForTheDay\\Functions\\Thought.For.The.Day.txt', 'r', encoding='utf-8') as f:
    original_lines = [line.strip() for line in f.readlines() if line.strip()]

with open('ThoughtForTheDay\\Functions\\New.Thoughts.For.The.Day.txt', 'r', encoding='utf-8') as f:
    new_thoughts_lines = [line.strip() for line in f.readlines() if line.strip()]

with open('WIP\\New_Quotes_.txt', 'r', encoding='utf-8') as f:
    new_quotes_lines = [line.strip() for line in f.readlines() if line.strip()]

# Function to extract quote and attribution
def parse_quote(line):
    if ' - ' in line:
        parts = line.rsplit(' - ', 1)
        return parts[0].strip(), parts[1].strip()
    return line.strip(), ''

# Function to categorize quotes
def categorize_quote(line, quote, attr):
    line_lower = line.lower()
    
    # Check if it's a religion quote
    religion_keywords = ['religion', 'religious', 'god', 'church', 'faith', 'bible', 'priest', 'christian', 'atheist', 'prayer', 'belief', 'worship']
    if any(kw in line_lower for kw in religion_keywords):
        return 'religion'
    
    # Check if it's a money/debt quote
    money_keywords = ['debt', 'money', 'borrow', 'loan', 'creditor']
    if any(kw in line_lower for kw in money_keywords):
        return 'money_debt'
    
    # Check if it's Viking-related
    if 'Viking' in attr or 'viking' in attr.lower():
        return 'viking'
    
    return 'general'

# Parse all quotes
original_quotes = set()
original_by_category = defaultdict(list)

for line in original_lines:
    quote, attr = parse_quote(line)
    original_quotes.add((quote.lower(), attr.lower()))
    category = categorize_quote(line, quote, attr)
    original_by_category[category].append((line, quote, attr, len(line)))

# Find new quotes
new_all = new_thoughts_lines + new_quotes_lines
new_by_category = defaultdict(list)

for line in new_all:
    quote, attr = parse_quote(line)
    if (quote.lower(), attr.lower()) not in original_quotes:
        category = categorize_quote(line, quote, attr)
        new_by_category[category].append((line, quote, attr, len(line)))
        original_quotes.add((quote.lower(), attr.lower()))

print(f'Original quotes: {len(original_lines)}')
print(f'Total new unique quotes to add: {sum(len(v) for v in new_by_category.values())}')
print(f'\nNew quotes by category:')
for category in ['viking', 'money_debt', 'religion', 'general']:
    count = len(new_by_category[category])
    if count > 0:
        print(f'  {category}: {count} quotes')

# Group general quotes by attribution
general_by_attr = defaultdict(list)
for item in new_by_category['general']:
    general_by_attr[item[2]].append(item)

if general_by_attr:
    print(f'\nGeneral quotes by attribution:')
    for attr in sorted(general_by_attr.keys()):
        if attr:
            print(f'  {attr}: {len(general_by_attr[attr])} quotes')

