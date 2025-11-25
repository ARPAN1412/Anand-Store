<?php
/**
 * Custom Post Types for GoGrocer
 *
 * @package GoGrocer_Backend
 */

class GoGrocer_Custom_Post_Types {

    /**
     * Initialize
     */
    public static function init() {
        add_action('init', array(__CLASS__, 'register_post_types'));
        add_action('init', array(__CLASS__, 'register_taxonomies'));
    }

    /**
     * Register Custom Post Types
     */
    public static function register_post_types() {
        
        // Register Product Post Type
        register_post_type('product', array(
            'labels' => array(
                'name' => __('Products', 'gogrocer-backend'),
                'singular_name' => __('Product', 'gogrocer-backend'),
                'add_new' => __('Add New Product', 'gogrocer-backend'),
                'add_new_item' => __('Add New Product', 'gogrocer-backend'),
                'edit_item' => __('Edit Product', 'gogrocer-backend'),
                'new_item' => __('New Product', 'gogrocer-backend'),
                'view_item' => __('View Product', 'gogrocer-backend'),
                'search_items' => __('Search Products', 'gogrocer-backend'),
                'not_found' => __('No products found', 'gogrocer-backend'),
            ),
            'public' => true,
            'has_archive' => true,
            'show_in_rest' => true,
            'show_in_graphql' => true,
            'graphql_single_name' => 'product',
            'graphql_plural_name' => 'products',
            'menu_icon' => 'dashicons-cart',
            'supports' => array('title', 'editor', 'thumbnail', 'custom-fields'),
            'rewrite' => array('slug' => 'products'),
        ));

        // Register Order Post Type
        register_post_type('order', array(
            'labels' => array(
                'name' => __('Orders', 'gogrocer-backend'),
                'singular_name' => __('Order', 'gogrocer-backend'),
            ),
            'public' => false,
            'show_ui' => true,
            'show_in_menu' => true,
            'show_in_rest' => true,
            'show_in_graphql' => true,
            'graphql_single_name' => 'order',
            'graphql_plural_name' => 'orders',
            'menu_icon' => 'dashicons-list-view',
            'supports' => array('title', 'custom-fields'),
            'capability_type' => 'post',
            'capabilities' => array(
                'create_posts' => 'edit_posts',
            ),
        ));
    }

    /**
     * Register Taxonomies
     */
    public static function register_taxonomies() {
        
        // Register Product Category Taxonomy
        register_taxonomy('product_category', 'product', array(
            'labels' => array(
                'name' => __('Product Categories', 'gogrocer-backend'),
                'singular_name' => __('Product Category', 'gogrocer-backend'),
            ),
            'hierarchical' => true,
            'show_in_rest' => true,
            'show_in_graphql' => true,
            'graphql_single_name' => 'productCategory',
            'graphql_plural_name' => 'productCategories',
            'rewrite' => array('slug' => 'product-category'),
        ));

        // Register Product Tag Taxonomy
        register_taxonomy('product_tag', 'product', array(
            'labels' => array(
                'name' => __('Product Tags', 'gogrocer-backend'),
                'singular_name' => __('Product Tag', 'gogrocer-backend'),
            ),
            'hierarchical' => false,
            'show_in_rest' => true,
            'show_in_graphql' => true,
            'graphql_single_name' => 'productTag',
            'graphql_plural_name' => 'productTags',
            'rewrite' => array('slug' => 'product-tag'),
        ));
    }
}
