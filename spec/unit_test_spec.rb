require './helpers/average_word_length_calculator'
require 'rspec'

describe AverageWordLengthCalculator do
  describe '.average_word_length' do
    it 'calculates the average word length for a normal sentence' do
      result = AverageWordLengthCalculator.average_word_length("The quick brown fox")
      expect(result).to eq(4.0)
    end

    it 'returns 0 for an empty string' do
      result = AverageWordLengthCalculator.average_word_length("")
      expect(result).to eq(0)
    end

    it 'handles sentences with special characters' do
      result = AverageWordLengthCalculator.average_word_length("Hello, world!")
      expect(result).to eq(5.0)
    end

    it 'handles sentences with numbers' do
        result = AverageWordLengthCalculator.average_word_length("The number is 123")
        expect(result).to eq(3.67)
        end

    it 'handles sentences with special characters and numbers' do
        result = AverageWordLengthCalculator.average_word_length("The number is 123!")
        expect(result).to eq(3.67)
        end
    end
end
