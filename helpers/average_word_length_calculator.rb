# This module calculates the average word length of a given text. It excludes numbers and special characters from the calculation.
module AverageWordLengthCalculator
    def self.average_word_length(text)
        # Exclude numbers by adjusting the regex to match only alphabetic words
        words = text.scan(/\b[a-zA-Z]+\b/)
        return 0 if words.empty?
    
        total_length = words.map(&:length).sum
        (total_length.to_f / words.size).round(2)
      end
    end