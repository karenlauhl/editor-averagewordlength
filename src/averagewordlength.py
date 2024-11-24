import re  # Ensure re is imported at the top of the file

def calculate_average_word_length(text):
    """
    Calculates the average word length of a given text.

    :param text: The input string
    :return: The average word length
    """
    words = re.findall(r'\b\w+\b', text)  # Extract words
    if not words:  # Avoid division by zero for empty text
        return 0
    total_length = sum(len(word) for word in words)
    return total_length / len(words)
