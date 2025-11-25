# WordPress Headless Backend Setup Guide

## Overview
This WordPress plugin provides a complete headless backend for the GoGrocer Flutter app using WPGraphQL.

## Prerequisites

1. **WordPress Installation** (5.9 or higher)
2. **PHP** 7.4 or higher
3. **MySQL** 5.7 or higher

## Installation Steps

### Step 1: Install Required WordPress Plugins

1. **Install WPGraphQL**
   ```
   - Go to WordPress Admin → Plugins → Add New
   - Search for "WPGraphQL"
   - Install and Activate
   ```

2. **Install WPGraphQL JWT Authentication** (Optional but recommended)
   ```
   - Download from: https://github.com/wp-graphql/wp-graphql-jwt-authentication
   - Upload to wp-content/plugins/
   - Activate in WordPress Admin
   ```

### Step 2: Install GoGrocer Backend Plugin

1. Copy the `wordpress-backend` folder to your WordPress plugins directory:
   ```
   wp-content/plugins/gogrocer-backend/
   ```

2. Activate the plugin from WordPress Admin → Plugins

### Step 3: Configure JWT Authentication (for user login)

Add this to your `wp-config.php`:

```php
define('GRAPHQL_JWT_AUTH_SECRET_KEY', 'your-secret-key-here');

// Enable CORS if Flutter app is on different domain
define('JWT_AUTH_CORS_ENABLE', true);
```

Generate a secret key at: https://api.wordpress.org/secret-key/1.1/salt/

### Step 4: Enable CORS

Add to your `.htaccess` or server configuration:

```apache
<IfModule mod_headers.c>
    Header set Access-Control-Allow-Origin "*"
    Header set Access-Control-Allow-Methods "GET, POST, OPTIONS, PUT, DELETE"
    Header set Access-Control-Allow-Headers "Content-Type, Authorization"
</IfModule>
```

### Step 5: Add Sample Data

1. Go to WordPress Admin → Products → Add New
2. Create products with these fields:
   - Title: Product name
   - Content: Product description
   - Featured Image: Product image
   - Custom Fields:
     - `price`: 2.99
     - `unit`: kg
     - `rating`: 4.5
     - `in_stock`: 1
     - `sku`: PROD001
     - `stock_quantity`: 100
     - `delivery_time`: 14 mins

3. Create Product Categories:
   - Vegetables, Fruits, Dairy, Bakery, Meat, Snacks

## GraphQL Endpoint

Your GraphQL endpoint will be:
```
https://your-domain.com/graphql
```

## Available Queries

### Get All Products
```graphql
query GetProducts {
  products {
    nodes {
      id
      title
      content
      price
      unit
      rating
      inStock
      deliveryTime
      featuredImage
      productCategories {
        nodes {
          name
          slug
        }
      }
    }
  }
}
```

### Get Products by Category
```graphql
query GetProductsByCategory {
  productsByCategory(category: "vegetables") {
    id
    title
    price
    unit
    rating
    featuredImage
  }
}
```

### Search Products
```graphql
query SearchProducts {
  searchProducts(search: "milk") {
    id
    title
    price
    unit
  }
}
```

### Get Featured Products
```graphql
query GetFeaturedProducts {
  featuredProducts(limit: 10) {
    id
    title
    price
    rating
    featuredImage
  }
}
```

## Available Mutations

### Create Order
```graphql
mutation CreateOrder {
  createOrder(
    input: {
      orderItems: "[{\"productId\":1,\"quantity\":2,\"price\":5.98}]"
      totalAmount: 5.98
      deliveryAddress: "123 Main St"
      customerPhone: "1234567890"
      customerName: "John Doe"
    }
  ) {
    orderId
    success
    message
  }
}
```

### Update Order Status
```graphql
mutation UpdateOrderStatus {
  updateOrderStatus(
    input: {
      orderId: 123
      status: "completed"
    }
  ) {
    success
    message
  }
}
```

### Add to Wishlist
```graphql
mutation AddToWishlist {
  addToWishlist(
    input: {
      productId: 123
    }
  ) {
    success
    message
  }
}
```

## Testing the API

### Using GraphiQL

1. Install GraphiQL plugin or access:
   ```
   https://your-domain.com/graphql?graphiql=true
   ```

2. Test queries in the GraphiQL interface

### Using Postman

1. Create a POST request to: `https://your-domain.com/graphql`
2. Add header: `Content-Type: application/json`
3. In body (raw JSON):
```json
{
  "query": "query GetProducts { products { nodes { id title price } } }"
}
```

## Security

### Enable Authentication

For protected queries/mutations, add JWT token to headers:

```
Authorization: Bearer YOUR_JWT_TOKEN
```

To get a JWT token:

```graphql
mutation Login {
  login(
    input: {
      username: "your-username"
      password: "your-password"
    }
  ) {
    authToken
    user {
      id
      name
      email
    }
  }
}
```

## Troubleshooting

### Issue: GraphQL endpoint returns 404
**Solution**: Go to Settings → Permalinks → Save Changes (to flush rewrite rules)

### Issue: CORS errors
**Solution**: Check `.htaccess` CORS headers or use a CORS plugin

### Issue: Custom fields not showing
**Solution**: Make sure WPGraphQL is activated and custom fields are registered

## Production Checklist

- [ ] Change JWT secret key
- [ ] Enable SSL (HTTPS)
- [ ] Configure proper CORS policies
- [ ] Set up rate limiting
- [ ] Enable caching (WP Rocket, W3 Total Cache)
- [ ] Regular backups
- [ ] Update WordPress and plugins regularly

## Support

For issues or questions:
- WPGraphQL Docs: https://www.wpgraphql.com/docs/
- WordPress Codex: https://codex.wordpress.org/

## Next Steps

1. Connect Flutter app to WordPress backend (see `FLUTTER_GRAPHQL_SETUP.md`)
2. Add more custom fields as needed
3. Configure payment gateway
4. Set up email notifications for orders
