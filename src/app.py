import re
from flask import Flask, jsonify, request
from averagewordlength import calculate_average_word_length  

app = Flask(__name__)

@app.after_request
def add_cors_headers(response):
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
    return response


@app.route('/', methods=['GET', 'OPTIONS'])
def average_word_length():
    if request.method == 'OPTIONS':
        response = jsonify({})
        response.headers["Access-Control-Allow-Origin"] = "*"
        response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
        response.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization"
        return response
    
    response = {
            "error": False,
            "description": "This service calculates the average word length.",
            "string": "",
            "answer": 0
        }
    
    
    text = request.args.get('text')
    if not text:
        response["error"] = True
        response["answer"] = "No text provided. Please include a 'text' parameter."
    else:
        try:
            # Calculate average word length
            avg_length = calculate_average_word_length(text)
            response["answer"] = f"The average word length is {avg_length:.2f}."
        except Exception as e:
            response["error"] = True
            response["answer"] = f"An error occurred: {str(e)}"

    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5200)
