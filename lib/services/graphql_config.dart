class GraphQLConfig {
  // Change this to your WordPress site URL
  static const String wordpressUrl = 'https://your-site.com';
  static const String graphqlEndpoint = '$wordpressUrl/graphql';
  
  // GraphQL Queries
  static const String getAllProducts = r'''
    query GetAllProducts {
      products(first: 100) {
        nodes {
          id
          databaseId
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
  ''';

  static const String getProductsByCategory = r'''
    query GetProductsByCategory($category: String!) {
      productsByCategory(category: $category) {
        id
        databaseId
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
  ''';

  static const String searchProducts = r'''
    query SearchProducts($search: String!) {
      searchProducts(search: $search) {
        id
        databaseId
        title
        content
        price
        unit
        rating
        inStock
        deliveryTime
        featuredImage
      }
    }
  ''';

  static const String getFeaturedProducts = r'''
    query GetFeaturedProducts($limit: Int!) {
      featuredProducts(limit: $limit) {
        id
        databaseId
        title
        price
        unit
        rating
        featuredImage
      }
    }
  ''';

  static const String getUserOrders = r'''
    query GetUserOrders($userId: Int!) {
      userOrders(userId: $userId) {
        id
        databaseId
        title
        orderStatus
        totalAmount
        orderItems
        deliveryAddress
        customerPhone
        date
      }
    }
  ''';

  // GraphQL Mutations
  static const String createOrder = r'''
    mutation CreateOrder($input: CreateOrderInput!) {
      createOrder(input: $input) {
        orderId
        success
        message
      }
    }
  ''';

  static const String updateOrderStatus = r'''
    mutation UpdateOrderStatus($input: UpdateOrderStatusInput!) {
      updateOrderStatus(input: $input) {
        success
        message
      }
    }
  ''';

  static const String addToWishlist = r'''
    mutation AddToWishlist($input: AddToWishlistInput!) {
      addToWishlist(input: $input) {
        success
        message
      }
    }
  ''';

  static const String loginMutation = r'''
    mutation Login($username: String!, $password: String!) {
      login(input: {
        username: $username
        password: $password
      }) {
        authToken
        refreshToken
        user {
          id
          databaseId
          name
          email
        }
      }
    }
  ''';
}
