// ==========================================
// Backend API
// ==========================================

const API = `${window.location.protocol}//${window.location.hostname}:5000`;


// ==========================================
// Load Application Status
// ==========================================

async function loadStatus() {

    try {

        const response = await fetch(`${API}/app-status`);

        if (!response.ok) {
            throw new Error("Unable to fetch application status");
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

        document.getElementById("status").innerHTML = `
            <p style="color:red;">
                Unable to connect to backend.
            </p>
        `;

    }

}


// ==========================================
// Load Products
// ==========================================

async function loadProducts() {

    try {

        const response = await fetch(`${API}/products`);

        if (!response.ok) {
            throw new Error("Unable to fetch products");
        }

        const data = await response.json();

        let html = "";

        if (data.status === "database_not_configured") {

            html = `
                <p style="color:orange;">
                    ${data.message}
                `;

            document.getElementById("products").innerHTML = html;

            return;

        }

        if (data.status !== "success") {

            html = `
                <p style="color:red;">
                    Unable to load products.
                </p>
            `;

            document.getElementById("products").innerHTML = html;

            return;

        }

        for (const product of data.products) {

            html += `
                <div class="product">

                    <h3>${product.name}</h3>

                    <p>${product.description}</p>

                    <p><b>Price:</b> ₹${product.price}</p>

                    <p><b>Stock:</b> ${product.stock}</p>

                </div>
            `;

        }

        document.getElementById("products").innerHTML = html;

    } catch (error) {

        console.error(error);

        document.getElementById("products").innerHTML = `
            <p style="color:red;">
                Unable to load products.
            </p>
        `;

    }

}


// ==========================================
// Page Load
// ==========================================

window.onload = function () {

    loadStatus();

    loadProducts();

};