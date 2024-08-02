import re

def parse_pattern_1(message):
    pattern = r"Rs (\d+\.\d+) (\w+) from .* -(\w+)"
    match = re.search(pattern, message)
    if match:
        amount = match.group(1)
        transaction_type = match.group(2)
        bank = match.group(3)
        return transaction_type, amount, bank
    return None, None, None

def parse_pattern_2(message):
    pattern = r"Rs\.(\d+) transferred from .* - (.+)"
    match = re.search(pattern, message)
    if match:
        amount = match.group(1)
        transaction_type = "debit"
        bank = match.group(2)
        return transaction_type, amount, bank
    return None, None, None

def parse_pattern_3(message):
    pattern = r"Rs\.(\d+) Credited to .* - (.+)"
    match = re.search(pattern, message)
    if match:
        amount = match.group(1)
        transaction_type = "credited"
        bank = match.group(2)
        return transaction_type, amount, bank
    return None, None, None

def parse_pattern_4(message):
    pattern = r"account is credited INR (\d+\.\d+) on Date .* - (\w+)"
    match = re.search(pattern, message)
    if match:
        amount = match.group(1)
        transaction_type = "credited"
        bank = match.group(2)
        return transaction_type, amount, bank
    return None, None, None

def parse_pattern_5(message):
    pattern = r"Rs\.(\d+) transferred from .* - (.+)"
    match = re.search(pattern, message)
    if match:
        amount = match.group(1)
        transaction_type = "debit"
        bank = match.group(2)
        return transaction_type, amount, bank
    return None, None, None


def parse_pattern_6(message):
    pattern = r"Rs\.(\d+\.\d+) credited to your A/c .* via IMPS on .* -(.+)"
    match = re.search(pattern, message)
    if match:
        amount = match.group(1)
        transaction_type = "credited"
        bank = match.group(2)
        return transaction_type, amount, bank
    return None, None, None

def parse_pattern_7(message):
    pattern = r"credited INR (\d+\.\d+) on Date .* - (\w+)"
    match = re.search(pattern, message)
    if match:
        amount = match.group(1)
        transaction_type = "credited"
        bank = match.group(2)
        return transaction_type, amount, bank
    return None, None, None

def parse_pattern_8(message):
     # Define the pattern to match different parts of the message
    pattern = r'Rs\.(?P<amount>\d+(?:,\d+)*(?:\.\d+)?)\s+(?P<type>credited|debited) to your A/c .*?BAL-Rs\.(?P<balance>\d+\.\d+) -(?P<bank>[\w\s]+)'
    
    # Use regex to search for matches
    match = re.search(pattern, message)
    
    if match:
        amount_str = match.group('amount')     # Rs.1000 format
        amount = float(re.sub(r'[^\d.]', '', amount_str))  # Convert amount to float
        transaction_type = match.group('type')  # credited or debited
        bank = match.group('bank')             # Bank name
        
        return transaction_type, amount, bank
    else:
        return None, None, None
    

def parse_transaction_message(message):
    # List of parsing functions
    parsers = [
        parse_pattern_1,
        parse_pattern_2,
        parse_pattern_3,
        parse_pattern_4,
        parse_pattern_5,
        parse_pattern_6,
        parse_pattern_7,
        parse_pattern_8
    ]
    
    for parser in parsers:
        transaction_type, amount, bank = parser(message)
        if transaction_type and amount and bank:
            return transaction_type, amount, bank
    
    return None, None, None


message="Rs.1000 credited to your A/c XX2515 via IMPS on 26JUN2024 23:08:23. (IMPS Ref no-417823695438) BAL-Rs.2188.74 -Federal Bank"

transaction_type, amount, bank = parse_transaction_message(message)
if transaction_type and amount and bank:
        print(f"type: {transaction_type}")
        print(f"amount: {amount}")
        print(f"bank: {bank}")
else:
        print("No match found for the message.")
