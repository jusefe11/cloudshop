from flask import Flask, jsonify, request

app = Flask(__name__)

orders = []

@app.route("/orders", methods=["POST"])
def create_order():
    data = request.get_json()

    order = {
        "id": len(orders) + 1,
        "product_id": data["product_id"],
        "quantity": data["quantity"]
    }

    orders.append(order)

    return jsonify(order), 201


@app.route("/orders", methods=["GET"])
def get_orders():
    return jsonify(orders)


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
