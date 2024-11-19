# Just trying out ruby at the moment

def average_word_length(text)
    # Extract all words from the text
    words = text.scan(/\b\w+\b/)
  
    # Calculate the total length of all words
    total_length = words.map(&:length).sum
  
    # Calculate the average word length
    average_length = words.empty? ? 0 : (total_length.to_f / words.size)
  
    average_length
  end
  
  # Test the method with a sample text
  text = "The quick brown fox jumps over the lazy dog."
  average = average_word_length(text)
  puts "Average word length: #{average.round(2)}"
  