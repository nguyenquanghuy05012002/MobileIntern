class Product {
  constructor(name, price, quantity) {
    this.name = name;
    this.price = price;
    this.quantity = quantity;
  }
}

const products = [
  new Product("Laptop", 999.99, 5),
  new Product("Smartphone", 499.99, 10),
  new Product("Tablet", 299.99, 0),
  new Product("Smartwatch", 199.99, 6),
];

function calculateTotalInventoryValue(products) {
  return products.reduce(
    (total, product) => total + product.price * product.quantity,
    0
  );
}

function findMostExpensiveProduct(products) {
  const mostExpensive = products.reduce((max, product) =>
    product.price > max.price ? product : max
  );
  return mostExpensive.name;
}

function isProductInStock(products, productName) {
  const product = products.find(
    (product) => product.name.toLowerCase() === productName.toLowerCase()
  );
  return product ? product.quantity > 0 : false;
}

function sortProducts(products, key, order = "asc") {
  return products.sort((a, b) => {
    if (key === "price") {
      return order === "asc" ? a.price - b.price : b.price - a.price;
    } else if (key === "quantity") {
      return order === "asc"
        ? a.quantity - b.quantity
        : b.quantity - a.quantity;
    }
  });
}

const totalInventoryValue = calculateTotalInventoryValue(products);
console.log(`Total Inventory Value: ${totalInventoryValue.toFixed(2)}`);

const mostExpensiveProduct = findMostExpensiveProduct(products);
console.log(`Most Expensive Product: "${mostExpensiveProduct}"`);

const headphonesInStock = isProductInStock(products, "Headphones");
console.log(`Is 'Headphones' in stock? ${headphonesInStock}`);

const sortedByPriceAsc = sortProducts([...products], "price", "asc");
const sortedByQuantityDesc = sortProducts([...products], "quantity", "desc");

console.log("Sorted by Price (Ascending):", sortedByPriceAsc);
console.log("Sorted by Quantity (Descending):", sortedByQuantityDesc);
