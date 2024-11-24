import unittest
from averagewordlength import calculate_average_word_length

class TestAverageWordLength(unittest.TestCase):
    def test_average_word_length(self):
        self.assertEqual(calculate_average_word_length("Hello world"), 5.0)
        self.assertEqual(calculate_average_word_length("A quick brown fox"), 3.5)
        self.assertEqual(calculate_average_word_length(""), 0)
        self.assertEqual(calculate_average_word_length("Supercalifragilisticexpialidocious"), 34.0)
