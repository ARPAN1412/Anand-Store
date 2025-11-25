# Restaurant App Backend

Node.js + Express + PostgreSQL backend API

## 📋 Prerequisites

Before running the backend, you need to install PostgreSQL:

### Install PostgreSQL on Windows

1. Download PostgreSQL from: https://www.postgresql.org/download/windows/
2. Run the installer and follow the setup wizard
3. Set a password for the postgres user (remember this password!)
4. Default port is 5432 (keep it as is)
5. Complete the installation

### Create the Database

After installing PostgreSQL:

1. Open **pgAdmin 4** (comes with PostgreSQL)
2. Login with your postgres password
3. Right-click on "Databases" → "Create" → "Database"
4. Name it: `restaurant_db`
5. Click "Save"

OR use command line:
```bash
psql -U postgres
CREATE DATABASE restaurant_db;
\q
```

## 🔧 Setup Instructions

1. **Update .env file** with your PostgreSQL password:
```env
DB_PASSWORD=your_postgres_password_here
```

2. **Install dependencies** (already done):
```bash
npm install
```

3. **Start the server**:
```bash
npm run dev
```

The server will:
- ✅ Connect to PostgreSQL
- ✅ Create all tables automatically
- ✅ Seed the database with sample data
- ✅ Start on port 5000

## 📝 Default Credentials

After seeding:
- **Admin**: admin@restaurant.com / admin123
- **Customer**: john@example.com / password123

## 🔗 API Endpoints

Base URL: `http://localhost:5000/api`

### Authentication
- POST `/auth/register` - Register new user
- POST `/auth/login` - Login
- GET `/auth/me` - Get current user (Protected)

### Menu
- GET `/menu` - Get all menu items
- GET `/menu/:id` - Get single menu item
- POST `/menu` - Create menu item (Admin)
- PUT `/menu/:id` - Update menu item (Admin)
- DELETE `/menu/:id` - Delete menu item (Admin)

### Categories
- GET `/categories` - Get all categories
- POST `/categories` - Create category (Admin)
- PUT `/categories/:id` - Update category (Admin)

### Orders
- POST `/orders` - Create new order (Protected)
- GET `/orders` - Get all orders (Admin)
- GET `/orders/my-orders` - Get user orders (Protected)
- GET `/orders/stats` - Get order statistics (Admin)
- PUT `/orders/:id/status` - Update order status (Admin)

### Reservations
- POST `/reservations` - Create reservation (Protected)
- GET `/reservations` - Get all reservations (Admin)
- GET `/reservations/my-reservations` - Get user reservations (Protected)
- PUT `/reservations/:id` - Update reservation (Admin)

## 🔐 Authentication

Include JWT token in headers:
```
Authorization: Bearer your_jwt_token_here
```

## 📊 Database Schema

- **users** - User accounts
- **categories** - Food categories
- **menu_items** - Restaurant menu
- **orders** - Customer orders
- **order_items** - Order details
- **reservations** - Table reservations

## ⚠️ Troubleshooting

**Error: "password authentication failed"**
- Update `.env` file with correct PostgreSQL password

**Error: "database does not exist"**
- Create database in pgAdmin: `restaurant_db`

**Error: "connect ECONNREFUSED"**
- Make sure PostgreSQL service is running
- Check port 5432 is not blocked

## 🚀 Quick Start (Without PostgreSQL)

If you don't want to install PostgreSQL locally, you can use a free cloud database:

1. Go to https://www.elephantsql.com/
2. Create a free account
3. Create a new database instance
4. Copy the connection URL
5. Update `.env`:
```env
DATABASE_URL=postgres://username:password@host:port/database
```

## 📱 Connect Frontend & Admin

Both frontend (port 3002) and admin panel (port 3003) are already configured to connect to this backend (port 5000).

Update axios base URL in frontend if needed:
```javascript
axios.defaults.baseURL = 'http://localhost:5000/api'
```
