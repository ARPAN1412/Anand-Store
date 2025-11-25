# 🚀 Backend Setup Guide - Node.js + PostgreSQL

Your Flutter app now uses a **Node.js + Express + PostgreSQL** backend instead of WordPress!

## ✅ What Changed

### Before:
- ❌ WordPress + WPGraphQL
- ❌ GraphQL queries
- ❌ Complex setup

### Now:
- ✅ Node.js + Express REST API
- ✅ PostgreSQL database
- ✅ Simple HTTP requests with Dio
- ✅ Better performance

---

## 📦 Backend Structure

```
backend/
├── .env                      # Environment variables
├── package.json              # Node.js dependencies
├── setup.bat                 # Windows setup script
├── README.md                 # Backend instructions
├── src/
│   ├── server.js            # Main server file
│   ├── config/
│   │   ├── database.js      # PostgreSQL connection
│   │   └── seed.js          # Sample data seeder
│   ├── controllers/         # Business logic
│   ├── models/              # Database models
│   ├── routes/              # API endpoints
│   ├── middleware/          # Auth & validation
│   └── data/                # Dataset files
```

---

## 🔧 Setup Instructions

### Step 1: Install PostgreSQL

**Windows:**
1. Download: https://www.postgresql.org/download/windows/
2. Run installer
3. Set password for `postgres` user (remember this!)
4. Default port: 5432
5. Complete installation

### Step 2: Create Database

Open **pgAdmin 4** or command line:

```sql
CREATE DATABASE restaurant_db;
```

### Step 3: Configure Backend

1. Open `backend/.env` file
2. Update with your PostgreSQL password:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=restaurant_db
DB_USER=postgres
DB_PASSWORD=YOUR_PASSWORD_HERE

# JWT Secret
JWT_SECRET=your-super-secret-jwt-key-change-this

# Server
PORT=5000
NODE_ENV=development

# URLs
CLIENT_URL=http://localhost:3002
ADMIN_URL=http://localhost:3003
MOBILE_URL=http://localhost:8080
```

### Step 4: Install Backend Dependencies

```bash
cd backend
npm install
```

### Step 5: Start Backend Server

```bash
npm run dev
```

**Expected Output:**
```
🚀 Server running on port 5000
📱 Environment: development
✅ Database connected successfully
📊 Seeding database with sample data...
✅ Database seeded successfully
```

### Step 6: Test Backend

Open browser: http://localhost:5000/

You should see:
```json
{
  "message": "Restaurant API",
  "version": "1.0.0",
  "endpoints": {
    "auth": "/api/auth",
    "menu": "/api/menu",
    "orders": "/api/orders",
    "reservations": "/api/reservations",
    "categories": "/api/categories"
  }
}
```

---

## 🔌 Flutter App Changes

### Updated Files:

#### 1. `pubspec.yaml`
- ❌ Removed: `graphql_flutter`
- ✅ Added: `dio` (HTTP client)

#### 2. `lib/services/api_service.dart`
- Complete REST API integration
- JWT authentication
- All CRUD operations

#### 3. `lib/models/product.dart`
- Updated to match backend response
- Added `fromJson` method

---

## 📡 API Endpoints

### Base URL: `http://localhost:5000/api`

### Authentication
```http
POST /auth/register
POST /auth/login
GET  /auth/me  (Protected)
```

### Menu/Products
```http
GET    /menu           # Get all products
GET    /menu/:id       # Get single product
POST   /menu           # Create (Admin)
PUT    /menu/:id       # Update (Admin)
DELETE /menu/:id       # Delete (Admin)
```

### Orders
```http
POST /orders                 # Create order
GET  /orders                 # All orders (Admin)
GET  /orders/my-orders       # User orders
GET  /orders/stats           # Statistics (Admin)
PUT  /orders/:id/status      # Update status (Admin)
```

### Categories
```http
GET  /categories
POST /categories    (Admin)
PUT  /categories/:id (Admin)
```

---

## 🧪 Testing the Integration

### 1. Start Backend
```bash
cd backend
npm run dev
```

### 2. Start Flutter App
```bash
flutter run -d chrome
```

### 3. Test API Connection

The app will:
- ✅ Connect to `http://localhost:5000`
- ✅ Load products from PostgreSQL
- ✅ Handle authentication
- ✅ Create orders

---

## 📱 Sample Data

After running the backend, you'll have:

### Users:
- **Admin**: admin@restaurant.com / admin123
- **Customer**: john@example.com / password123

### Products:
- 50+ sample products
- Multiple categories
- Real pricing and images

### Categories:
- Vegetables & Fruits
- Dairy & Bakery
- Snacks & Drinks
- And more...

---

## 🔐 Authentication Flow

### Register New User
```dart
final api = ApiService();
final result = await api.register(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'password123',
  phone: '+1234567890',
);
```

### Login
```dart
final result = await api.login(
  email: 'john@example.com',
  password: 'password123',
);
// Token saved automatically
```

### Get Current User
```dart
final user = await api.getCurrentUser();
```

---

## 📦 Create Order Example

```dart
final api = ApiService();
final order = await api.createOrder(
  items: [
    {'menu_item_id': 1, 'quantity': 2},
    {'menu_item_id': 5, 'quantity': 1},
  ],
  deliveryAddress: 'HOME - Aniket Chakraborty, 238/2/2',
  phone: '+91 9876543210',
  notes: 'Please ring the bell',
);
```

---

## 🐛 Troubleshooting

### Error: "Database connection failed"
**Solution:**
- Check PostgreSQL is running
- Verify password in `.env`
- Ensure database `restaurant_db` exists

### Error: "Port 5000 already in use"
**Solution:**
```bash
# Find and kill the process
netstat -ano | findstr :5000
taskkill /PID <process_id> /F
```

### Error: "Cannot connect to backend"
**Solution:**
- Ensure backend is running on port 5000
- Check `lib/services/api_service.dart` has correct URL
- Update `baseUrl` if needed:
  ```dart
  static const String baseUrl = 'http://localhost:5000/api';
  ```

### Error: "CORS policy"
**Solution:**
Backend already configured for CORS. If issues persist, add your Flutter app URL to `src/server.js`:
```javascript
cors({
  origin: [
    'http://localhost:8080',  // Add your Flutter web URL
    'http://localhost:3000',
  ],
})
```

---

## 🚀 Production Deployment

### Backend Deployment Options:

1. **Heroku** (Easiest)
   - Free tier available
   - PostgreSQL included
   - Auto deployment from Git

2. **Railway**
   - Modern platform
   - Free PostgreSQL
   - Easy setup

3. **DigitalOcean App Platform**
   - $5/month
   - Managed PostgreSQL
   - Professional solution

4. **VPS (DigitalOcean, Linode, AWS)**
   - Full control
   - Install Node.js + PostgreSQL
   - Use PM2 for process management

### Update Flutter App for Production:

In `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://your-backend-url.com/api';
```

---

## 📊 Database Schema

### Tables:
- **users** - User accounts (id, name, email, password, role)
- **categories** - Product categories
- **menu_items** - Products/Menu items
- **orders** - Customer orders
- **order_items** - Order line items
- **reservations** - Table reservations

---

## ✅ Next Steps

1. **Start Backend:**
   ```bash
   cd backend
   npm run dev
   ```

2. **Test APIs:**
   - Use Postman or Thunder Client
   - Test all endpoints
   - Verify data

3. **Run Flutter App:**
   ```bash
   flutter run -d chrome
   ```

4. **Check Integration:**
   - Products load from backend
   - Authentication works
   - Orders create successfully

---

## 💡 Benefits of New Backend

### vs WordPress:
✅ **Faster** - Direct PostgreSQL queries
✅ **Simpler** - No GraphQL complexity  
✅ **Flexible** - Easy to customize
✅ **Modern** - Latest tech stack
✅ **Scalable** - Better performance

### Features:
- ✅ JWT Authentication
- ✅ Role-based access (Admin/Customer)
- ✅ Real-time updates (Socket.IO)
- ✅ Rate limiting
- ✅ Security (Helmet)
- ✅ Compression
- ✅ Logging (Morgan)

---

## 📞 Need Help?

### Resources:
- Backend README: `backend/README.md`
- API Docs: http://localhost:5000/api
- Node.js Docs: https://nodejs.org/docs
- PostgreSQL Docs: https://www.postgresql.org/docs/

### Common Commands:
```bash
# Backend
npm run dev          # Start development server
npm start            # Start production server
npm run migrate      # Run database migrations

# Flutter
flutter run          # Run app
flutter clean        # Clean build
flutter pub get      # Install dependencies
```

---

**✨ Your app is now powered by a professional Node.js + PostgreSQL backend!**

Ready to start? Run the backend and enjoy! 🚀
