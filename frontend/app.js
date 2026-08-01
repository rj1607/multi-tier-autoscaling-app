// Automatically use the current server IP/domain
const API = `${window.location.protocol}//${window.location.hostname}:5000`;

async function loadStatus() {
    try {
        const response = await fetch(`${API}/status`);

        if (!response.ok) {
            throw new Error("Unable to fetch status");
        }

        const data = await response.json();

        document.getElementById("status").innerHTML = `
            <b>Application:</b> ${data.application}<br>
            <b>Backend:</b> ${data.backend}<br>
            <b>Status:</b> ${data.status}<br>
            <b>Python:</b> ${data.python_version}
        `;
    } catch (error) {
        console.error(error);
        document.getElementById("status").innerHTML =
            "<p style='color:red'>Unable to connect to backend.</p>";
    }
}

async function loadProducts() {
    try {
        const response = await fetch(`${API}/products`);

        if (!response.ok) {
            throw new Error("Unable to fetch products");
        }

        const products = await response.json();

        let html = "";

        products.forEach(product => {
            html += `
                <div class="product">
                    <h3>${product.name}</h3>
                    <p>${product.description}</p>
                    <p><b>Price:</b> ₹${product.price}</p>
                    <p><b>Stock:</b> ${product.stock}</p>
                </div>
            `;
        });

        document.getElementById("products").innerHTML = html;
    } catch (error) {
        console.error(error);
        document.getElementById("products").innerHTML =
            "<p style='color:red'>Unable to load products.</p>";
    }
}

loadStatus();
loadProducts();