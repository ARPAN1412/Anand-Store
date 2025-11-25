import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Use Neon database with local server for now
  // TODO: Fix Vercel serverless deployment
  static const String baseUrl = 'http://10.195.192.14:5001/api';
  
  late Dio _dio;
  String? _token;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Add interceptor for auth token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        print('API Error: ${e.message}');
        return handler.next(e);
      },
    ));

    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _token = token;
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
  }

  // Auth APIs
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      });
      
      if (response.data['token'] != null) {
        await _saveToken(response.data['token']);
      }
      
      return response.data;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      if (response.data['token'] != null) {
        await _saveToken(response.data['token']);
      }
      
      return response.data;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Menu/Products APIs
  Future<List<dynamic>> getMenuItems() async {
    try {
      final response = await _dio.get('/menu');
      return response.data['data'] ?? [];
    } catch (e) {
      throw Exception('Failed to load menu items: $e');
    }
  }

  Future<List<dynamic>> getAllProducts() async {
    try {
      final response = await _dio.get('/menu');
      return response.data['data'] ?? [];
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Map<String, dynamic>> getProductById(int id) async {
    try {
      final response = await _dio.get('/menu/$id');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<List<dynamic>> searchProducts(String query) async {
    try {
      final response = await _dio.get('/menu', queryParameters: {
        'search': query,
      });
      return response.data['data'] ?? [];
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  Future<List<dynamic>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _dio.get('/menu', queryParameters: {
        'category': categoryId,
      });
      return response.data['data'] ?? [];
    } catch (e) {
      throw Exception('Failed to load category products: $e');
    }
  }

  // Categories APIs
  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      return response.data['data'] ?? [];
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  // Orders APIs
  Future<Map<String, dynamic>> createOrder({
    required List<Map<String, dynamic>> items,
    required String deliveryAddress,
    required String phone,
    String? notes,
  }) async {
    try {
      final response = await _dio.post('/orders', data: {
        'items': items,
        'deliveryAddress': deliveryAddress,
        'phone': phone,
        'notes': notes,
        'paymentMethod': 'cod', // Cash on delivery
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<List<dynamic>> getMyOrders() async {
    try {
      final response = await _dio.get('/orders/my-orders');
      return response.data['data'] ?? [];
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<Map<String, dynamic>> getOrderById(int id) async {
    try {
      final response = await _dio.get('/orders/$id');
      return response.data['data'];
    } catch (e) {
      throw Exception('Failed to load order: $e');
    }
  }

  // Reservations APIs
  Future<Map<String, dynamic>> createReservation({
    required DateTime date,
    required String time,
    required int guests,
    String? notes,
  }) async {
    try {
      final response = await _dio.post('/reservations', data: {
        'date': date.toIso8601String().split('T')[0],
        'time': time,
        'guests': guests,
        'notes': notes,
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to create reservation: $e');
    }
  }

  Future<List<dynamic>> getMyReservations() async {
    try {
      final response = await _dio.get('/reservations/my-reservations');
      return response.data['data'] ?? [];
    } catch (e) {
      throw Exception('Failed to load reservations: $e');
    }
  }

  // Health check
  Future<bool> checkHealth() async {
    try {
      final response = await _dio.get('/health');
      return response.data['success'] == true;
    } catch (e) {
      return false;
    }
  }
}
