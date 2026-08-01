const API="http://127.0.0.1:5000";

async function loadStatus(){

const response=await fetch(`${API}/status`);

const data=await response.json();

document.getElementById("status").innerHTML=`

<b>Application:</b> ${data.application}<br>

<b>Backend:</b> ${data.backend}<br>

<b>Status:</b> ${data.status}<br>

<b>Python:</b> ${data.python_version}

`;

}

async function loadProducts(){

const response=await fetch(`${API}/products`);

const products=await response.json();

let html="";

products.forEach(product=>{

html+=`

<div class="product">

<h3>${product.name}</h3>

<p>${product.description}</p>

<p><b>Price:</b> ₹${product.price}</p>

<p><b>Stock:</b> ${product.stock}</p>

</div>

`;

});

document.getElementById("products").innerHTML=html;

}

loadStatus();

loadProducts();