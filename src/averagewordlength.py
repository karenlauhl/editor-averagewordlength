import re  

def calculate_average_word_length(text):
    words = re.findall(r'\b\w+\b', text)  # Extract words
    if not words:  # Avoid division by zero for empty text
        return 0
    total_length = sum(len(word) for word in words)
    length = len(words)
    average = total_length / length
    return average
