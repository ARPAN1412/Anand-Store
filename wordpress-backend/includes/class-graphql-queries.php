<?php
/**
 * GraphQL Custom Queries
 *
 * @package GoGrocer_Backend
 */

class GoGrocer_GraphQL_Queries {

    /**
     * Initialize
     */
    public static function init() {
        add_action('graphql_register_types', array(__CLASS__, 'register_queries'));
    }

    /**
     * Register Custom Queries
     */
    public static function register_queries() {
        
        // Register Products By Category Query
        register_graphql_field('RootQuery', 'productsByCategory', array(
            'type' => array('list_of' => 'Product'),
            'description' => __('Get products by category', 'gogrocer-backend'),
            'args' => array(
                'category' => array(
                    'type' => 'String',
                    'description' => __('Category slug', 'gogrocer-backend'),
                ),
            ),
            'resolve' => function($source, $args, $context, $info) {
                $category = isset($args['category']) ? $args['category'] : '';
                
                $query_args = array(
                    'post_type' => 'product',
                    'post_status' => 'publish',
                    'posts_per_page' => -1,
                );

                if (!empty($category) && $category !== 'all') {
                    $query_args['tax_query'] = array(
                        array(
                            'taxonomy' => 'product_category',
                            'field' => 'slug',
                            'terms' => $category,
                        ),
                    );
                }

                $products = get_posts($query_args);
                return !empty($products) ? $products : array();
            }
        ));

        // Register Search Products Query
        register_graphql_field('RootQuery', 'searchProducts', array(
            'type' => array('list_of' => 'Product'),
            'description' => __('Search products', 'gogrocer-backend'),
            'args' => array(
                'search' => array(
                    'type' => 'String',
                    'description' => __('Search term', 'gogrocer-backend'),
                ),
            ),
            'resolve' => function($source, $args, $context, $info) {
                $search = isset($args['search']) ? $args['search'] : '';
                
                $query_args = array(
                    'post_type' => 'product',
                    'post_status' => 'publish',
                    'posts_per_page' => 20,
                    's' => $search,
                );

                $products = get_posts($query_args);
                return !empty($products) ? $products : array();
            }
        ));

        // Register Featured Products Query
        register_graphql_field('RootQuery', 'featuredProducts', array(
            'type' => array('list_of' => 'Product'),
            'description' => __('Get featured products', 'gogrocer-backend'),
            'args' => array(
                'limit' => array(
                    'type' => 'Int',
                    'description' => __('Number of products to return', 'gogrocer-backend'),
                    'defaultValue' => 10,
                ),
            ),
            'resolve' => function($source, $args, $context, $info) {
                $limit = isset($args['limit']) ? $args['limit'] : 10;
                
                $query_args = array(
                    'post_type' => 'product',
                    'post_status' => 'publish',
                    'posts_per_page' => $limit,
                    'meta_query' => array(
                        array(
                            'key' => 'featured',
                            'value' => '1',
                            'compare' => '=',
                        ),
                    ),
                );

                $products = get_posts($query_args);
                return !empty($products) ? $products : array();
            }
        ));

        // Register User Orders Query
        register_graphql_field('RootQuery', 'userOrders', array(
            'type' => array('list_of' => 'Order'),
            'description' => __('Get user orders', 'gogrocer-backend'),
            'args' => array(
                'userId' => array(
                    'type' => 'Int',
                    'description' => __('User ID', 'gogrocer-backend'),
                ),
            ),
            'resolve' => function($source, $args, $context, $info) {
                $user_id = isset($args['userId']) ? $args['userId'] : get_current_user_id();
                
                $query_args = array(
                    'post_type' => 'order',
                    'post_status' => 'publish',
                    'author' => $user_id,
                    'posts_per_page' => -1,
                    'orderby' => 'date',
                    'order' => 'DESC',
                );

                $orders = get_posts($query_args);
                return !empty($orders) ? $orders : array();
            }
        ));
    }
}
