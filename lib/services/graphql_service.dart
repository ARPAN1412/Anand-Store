import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_config.dart';

class GraphQLService {
  static GraphQLClient? _client;

  static GraphQLClient getClient() {
    if (_client != null) return _client!;

    final HttpLink httpLink = HttpLink(
      GraphQLConfig.graphqlEndpoint,
    );

    // Add authentication link if needed
    final AuthLink authLink = AuthLink(
      getToken: () async {
        // Get token from secure storage
        // final prefs = await SharedPreferences.getInstance();
        // final token = prefs.getString('auth_token');
        // return token != null ? 'Bearer $token' : null;
        return null;
      },
    );

    final Link link = authLink.concat(httpLink);

    _client = GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );

    return _client!;
  }

  // Fetch all products
  static Future<List<Map<String, dynamic>>> fetchAllProducts() async {
    final client = getClient();

    try {
      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(GraphQLConfig.getAllProducts),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        print('GraphQL Error: ${result.exception.toString()}');
        return [];
      }

      if (result.data != null && result.data!['products'] != null) {
        final products = result.data!['products']['nodes'] as List;
        return products.map((e) => e as Map<String, dynamic>).toList();
      }

      return [];
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // Fetch products by category
  static Future<List<Map<String, dynamic>>> fetchProductsByCategory(
      String category) async {
    final client = getClient();

    try {
      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(GraphQLConfig.getProductsByCategory),
          variables: {'category': category},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        print('GraphQL Error: ${result.exception.toString()}');
        return [];
      }

      if (result.data != null && result.data!['productsByCategory'] != null) {
        final products = result.data!['productsByCategory'] as List;
        return products.map((e) => e as Map<String, dynamic>).toList();
      }

      return [];
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  // Search products
  static Future<List<Map<String, dynamic>>> searchProducts(
      String searchTerm) async {
    final client = getClient();

    try {
      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(GraphQLConfig.searchProducts),
          variables: {'search': searchTerm},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        print('GraphQL Error: ${result.exception.toString()}');
        return [];
      }

      if (result.data != null && result.data!['searchProducts'] != null) {
        final products = result.data!['searchProducts'] as List;
        return products.map((e) => e as Map<String, dynamic>).toList();
      }

      return [];
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  // Fetch featured products
  static Future<List<Map<String, dynamic>>> fetchFeaturedProducts(
      {int limit = 10}) async {
    final client = getClient();

    try {
      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(GraphQLConfig.getFeaturedProducts),
          variables: {'limit': limit},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        print('GraphQL Error: ${result.exception.toString()}');
        return [];
      }

      if (result.data != null && result.data!['featuredProducts'] != null) {
        final products = result.data!['featuredProducts'] as List;
        return products.map((e) => e as Map<String, dynamic>).toList();
      }

      return [];
    } catch (e) {
      print('Error fetching featured products: $e');
      return [];
    }
  }

  // Create order
  static Future<Map<String, dynamic>?> createOrder({
    required String orderItems,
    required double totalAmount,
    String? deliveryAddress,
    String? customerPhone,
    String? customerName,
  }) async {
    final client = getClient();

    try {
      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(GraphQLConfig.createOrder),
          variables: {
            'input': {
              'orderItems': orderItems,
              'totalAmount': totalAmount,
              'deliveryAddress': deliveryAddress,
              'customerPhone': customerPhone,
              'customerName': customerName,
            }
          },
        ),
      );

      if (result.hasException) {
        print('GraphQL Error: ${result.exception.toString()}');
        return null;
      }

      if (result.data != null && result.data!['createOrder'] != null) {
        return result.data!['createOrder'] as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print('Error creating order: $e');
      return null;
    }
  }

  // Login user
  static Future<Map<String, dynamic>?> login({
    required String username,
    required String password,
  }) async {
    final client = getClient();

    try {
      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(GraphQLConfig.loginMutation),
          variables: {
            'username': username,
            'password': password,
          },
        ),
      );

      if (result.hasException) {
        print('GraphQL Error: ${result.exception.toString()}');
        return null;
      }

      if (result.data != null && result.data!['login'] != null) {
        return result.data!['login'] as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }
}
