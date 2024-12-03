import re
import logging
import time
from flask import Flask, jsonify, request
from averagewordlength import calculate_average_word_length

# Configure logging
logging.basicConfig(filename="errors.log", level=logging.ERROR)

app = Flask(__name__)

# Add CORS headers
@app.after_request
def add_cors_headers(response):
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "GET, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
    return response

# Main endpoint for average word length
@app.route('/', methods=['GET', 'OPTIONS'])
def average_word_length():
    start_time = time.time()  # Start timer to measure performance
    if request.method == 'OPTIONS':
        # Handle preflight requests
        response = jsonify({})
        response.headers["Access-Control-Allow-Origin"] = "*"
        response.headers["Access-Control-Allow-Methods"] = "GET, OPTIONS"
        response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
        return response

    response = {
        "error": False,
        "description": "This service calculates the average word length in a given text.",
        "message": "",
        "answer": 0
    }

    # Validate if 'text' parameter exists
    text = request.args.get('text', '')
    if not text:
        response["error"] = True
        response["message"] = "No text provided. Please include a 'text' parameter."
        return jsonify(response), 400
    
    if not re.match("^[a-zA-Z0-9 .,!?']+$", text):
        response["error"] = True
        response["message"] = "Input contains unsupported characters. Only alphanumeric text and punctuation are allowed."
        return jsonify(response), 400


    try:
        # Calculate average word length
        avg_length = calculate_average_word_length(text)
        response["answer"] = avg_length
    except Exception as e:
        response["error"] = True
        response["message"] = f"An error occurred: {str(e)}"
        logging.error(f"Error calculating average word length: {str(e)}")
        return jsonify(response), 500
    
    # Measure response time
    response_time = time.time() - start_time
    print(f"Response time: {response_time:.2f} seconds")
    
    return jsonify(response)

# Run the app
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5006)
