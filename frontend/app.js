// ======================================
// Backend API
// ======================================

const API = "/api";

// ======================================
// Application Status
// ======================================

async function loadStatus() {
    try {
        const response = await fetch(`${API}/app-status`);

        if (!response.ok) {
            throw new Error("Failed to fetch application status");
        }

        const data = await response.json();

        document.getElementById("status").innerHTML = `
            <b>Application:</b> ${data.application}<br>
            <b>Backend:</b> ${data.backend}<br>
            <b>Status:</b> ${data.status}<br>
            <b>Python:</b> ${data.python_version}
        `;
    } catch (error) {
        document.getElementById("status").innerHTML =
            "<p style='color:red;'>Backend unavailable.</p>";
    }
}

// ======================================
// Products
// ======================================

async function loadProducts() {
    try {
        const response = await fetch(`${API}/products`);

        if (!response.ok) {
            throw new Error("Failed to fetch products");
        }

        const data = await response.json();

        if (data.status === "database_not_configured") {
            document.getElementById("products").innerHTML = `
                <p style="color:orange;">${data.message}</p>
            `;
            return;
        }

        let html = "";

        data.products.forEach(product => {
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
        document.getElementById("products").innerHTML =
            "<p style='color:red;'>Unable to load products.</p>";
    }
}

// ======================================
// Page Load
// ======================================

window.onload = function () {
    loadStatus();
    loadProducts();
};