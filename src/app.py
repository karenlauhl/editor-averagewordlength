import re
from flask import Flask, jsonify, request
from averagewordlength import calculate_average_word_length

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
    if request.method == 'OPTIONS':
        # Handle preflight requests
        response = jsonify({})
        response.headers["Access-Control-Allow-Origin"] = "*"
        response.headers["Access-Control-Allow-Methods"] = "GET, OPTIONS"
        response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
        return response

    response = {"error": False}

    # Validate if 'text' parameter exists
    text = request.args.get('text', '')
    if not text:
        response["error"] = True
        response["answer"] = "No text provided. Please include a 'text' parameter."
    
    if not re.match("^[a-zA-Z0-9 .,!?']+$", text):
        response["error"] = True
        response["answer"] = "Input contains unsupported characters. Only alphanumeric text and punctuation are allowed."
        return jsonify(response)


    try:
        # Calculate average word length
        avg_length = calculate_average_word_length(text)
        response["answer"] = avg_length
    except Exception as e:
        response["error"] = True
        response["answer"] = f"An error occurred: {str(e)}"

    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5006)
