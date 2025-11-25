<?php
/**
 * Custom Fields for Products
 *
 * @package GoGrocer_Backend
 */

class GoGrocer_Custom_Fields {

    /**
     * Initialize
     */
    public static function init() {
        add_action('graphql_register_types', array(__CLASS__, 'register_product_fields'));
        add_action('graphql_register_types', array(__CLASS__, 'register_order_fields'));
    }

    /**
     * Register Product Custom Fields in GraphQL
     */
    public static function register_product_fields() {
        
        register_graphql_field('Product', 'price', array(
            'type' => 'Float',
            'description' => __('Product price', 'gogrocer-backend'),
            'resolve' => function($post) {
                $price = get_post_meta($post->ID, 'price', true);
                return $price ? floatval($price) : 0.0;
            }
        ));

        register_graphql_field('Product', 'unit', array(
            'type' => 'String',
            'description' => __('Product unit (kg, ltr, pc, etc.)', 'gogrocer-backend'),
            'resolve' => function($post) {
                return get_post_meta($post->ID, 'unit', true) ?: 'kg';
            }
        ));

        register_graphql_field('Product', 'rating', array(
            'type' => 'Float',
            'description' => __('Product rating', 'gogrocer-backend'),
            'resolve' => function($post) {
                $rating = get_post_meta($post->ID, 'rating', true);
                return $rating ? floatval($rating) : 4.5;
            }
        ));

        register_graphql_field('Product', 'inStock', array(
            'type' => 'Boolean',
            'description' => __('Product stock status', 'gogrocer-backend'),
            'resolve' => function($post) {
                $in_stock = get_post_meta($post->ID, 'in_stock', true);
                return $in_stock !== '0';
            }
        ));

        register_graphql_field('Product', 'sku', array(
            'type' => 'String',
            'description' => __('Product SKU', 'gogrocer-backend'),
            'resolve' => function($post) {
                return get_post_meta($post->ID, 'sku', true);
            }
        ));

        register_graphql_field('Product', 'stockQuantity', array(
            'type' => 'Int',
            'description' => __('Stock quantity', 'gogrocer-backend'),
            'resolve' => function($post) {
                $qty = get_post_meta($post->ID, 'stock_quantity', true);
                return $qty ? intval($qty) : 0;
            }
        ));

        register_graphql_field('Product', 'deliveryTime', array(
            'type' => 'String',
            'description' => __('Delivery time estimate', 'gogrocer-backend'),
            'resolve' => function($post) {
                return get_post_meta($post->ID, 'delivery_time', true) ?: '14 mins';
            }
        ));

        register_graphql_field('Product', 'featuredImage', array(
            'type' => 'String',
            'description' => __('Product featured image URL', 'gogrocer-backend'),
            'resolve' => function($post) {
                return get_the_post_thumbnail_url($post->ID, 'large') ?: '';
            }
        ));
    }

    /**
     * Register Order Custom Fields in GraphQL
     */
    public static function register_order_fields() {
        
        register_graphql_field('Order', 'orderStatus', array(
            'type' => 'String',
            'description' => __('Order status', 'gogrocer-backend'),
            'resolve' => function($post) {
                return get_post_meta($post->ID, 'order_status', true) ?: 'pending';
            }
        ));

        register_graphql_field('Order', 'totalAmount', array(
            'type' => 'Float',
            'description' => __('Total order amount', 'gogrocer-backend'),
            'resolve' => function($post) {
                $total = get_post_meta($post->ID, 'total_amount', true);
                return $total ? floatval($total) : 0.0;
            }
        ));

        register_graphql_field('Order', 'orderItems', array(
            'type' => 'String',
            'description' => __('Order items JSON', 'gogrocer-backend'),
            'resolve' => function($post) {
                return get_post_meta($post->ID, 'order_items', true) ?: '[]';
            }
        ));

        register_graphql_field('Order', 'deliveryAddress', array(
            'type' => 'String',
            'description' => __('Delivery address', 'gogrocer-backend'),
            'resolve' => function($post) {
                return get_post_meta($post->ID, 'delivery_address', true);
            }
        ));

        register_graphql_field('Order', 'customerPhone', array(
            'type' => 'String',
            'description' => __('Customer phone', 'gogrocer-backend'),
            'resolve' => function($post) {
                return get_post_meta($post->ID, 'customer_phone', true);
            }
        ));
    }
}
