<?php
/**
 * GraphQL Custom Mutations
 *
 * @package GoGrocer_Backend
 */

class GoGrocer_GraphQL_Mutations {

    /**
     * Initialize
     */
    public static function init() {
        add_action('graphql_register_types', array(__CLASS__, 'register_mutations'));
    }

    /**
     * Register Custom Mutations
     */
    public static function register_mutations() {
        
        // Register Create Order Mutation
        register_graphql_mutation('createOrder', array(
            'inputFields' => array(
                'orderItems' => array(
                    'type' => array('non_null' => 'String'),
                    'description' => __('Order items JSON string', 'gogrocer-backend'),
                ),
                'totalAmount' => array(
                    'type' => array('non_null' => 'Float'),
                    'description' => __('Total order amount', 'gogrocer-backend'),
                ),
                'deliveryAddress' => array(
                    'type' => 'String',
                    'description' => __('Delivery address', 'gogrocer-backend'),
                ),
                'customerPhone' => array(
                    'type' => 'String',
                    'description' => __('Customer phone number', 'gogrocer-backend'),
                ),
                'customerName' => array(
                    'type' => 'String',
                    'description' => __('Customer name', 'gogrocer-backend'),
                ),
            ),
            'outputFields' => array(
                'orderId' => array(
                    'type' => 'Int',
                    'description' => __('Created order ID', 'gogrocer-backend'),
                    'resolve' => function($payload) {
                        return isset($payload['orderId']) ? $payload['orderId'] : null;
                    }
                ),
                'success' => array(
                    'type' => 'Boolean',
                    'description' => __('Success status', 'gogrocer-backend'),
                    'resolve' => function($payload) {
                        return isset($payload['success']) ? $payload['success'] : false;
                    }
                ),
                'message' => array(
                    'type' => 'String',
                    'description' => __('Response message', 'gogrocer-backend'),
                    'resolve' => function($payload) {
                        return isset($payload['message']) ? $payload['message'] : '';
                    }
                ),
            ),
            'mutateAndGetPayload' => function($input) {
                $user_id = get_current_user_id();
                
                if (!$user_id) {
                    return array(
                        'success' => false,
                        'message' => __('User must be logged in to create an order', 'gogrocer-backend'),
                    );
                }

                $order_data = array(
                    'post_type' => 'order',
                    'post_title' => sprintf(__('Order #%s', 'gogrocer-backend'), time()),
                    'post_status' => 'publish',
                    'post_author' => $user_id,
                );

                $order_id = wp_insert_post($order_data);

                if (is_wp_error($order_id)) {
                    return array(
                        'success' => false,
                        'message' => $order_id->get_error_message(),
                    );
                }

                // Save order meta
                update_post_meta($order_id, 'order_items', $input['orderItems']);
                update_post_meta($order_id, 'total_amount', $input['totalAmount']);
                update_post_meta($order_id, 'delivery_address', isset($input['deliveryAddress']) ? $input['deliveryAddress'] : '');
                update_post_meta($order_id, 'customer_phone', isset($input['customerPhone']) ? $input['customerPhone'] : '');
                update_post_meta($order_id, 'customer_name', isset($input['customerName']) ? $input['customerName'] : '');
                update_post_meta($order_id, 'order_status', 'pending');
                update_post_meta($order_id, 'order_date', current_time('mysql'));

                return array(
                    'success' => true,
                    'orderId' => $order_id,
                    'message' => __('Order created successfully', 'gogrocer-backend'),
                );
            }
        ));

        // Register Update Order Status Mutation
        register_graphql_mutation('updateOrderStatus', array(
            'inputFields' => array(
                'orderId' => array(
                    'type' => array('non_null' => 'Int'),
                    'description' => __('Order ID', 'gogrocer-backend'),
                ),
                'status' => array(
                    'type' => array('non_null' => 'String'),
                    'description' => __('New order status', 'gogrocer-backend'),
                ),
            ),
            'outputFields' => array(
                'success' => array(
                    'type' => 'Boolean',
                    'resolve' => function($payload) {
                        return isset($payload['success']) ? $payload['success'] : false;
                    }
                ),
                'message' => array(
                    'type' => 'String',
                    'resolve' => function($payload) {
                        return isset($payload['message']) ? $payload['message'] : '';
                    }
                ),
            ),
            'mutateAndGetPayload' => function($input) {
                $order_id = $input['orderId'];
                $status = $input['status'];

                $updated = update_post_meta($order_id, 'order_status', $status);

                if ($updated) {
                    return array(
                        'success' => true,
                        'message' => __('Order status updated successfully', 'gogrocer-backend'),
                    );
                }

                return array(
                    'success' => false,
                    'message' => __('Failed to update order status', 'gogrocer-backend'),
                );
            }
        ));

        // Register Add To Wishlist Mutation
        register_graphql_mutation('addToWishlist', array(
            'inputFields' => array(
                'productId' => array(
                    'type' => array('non_null' => 'Int'),
                    'description' => __('Product ID', 'gogrocer-backend'),
                ),
            ),
            'outputFields' => array(
                'success' => array(
                    'type' => 'Boolean',
                    'resolve' => function($payload) {
                        return isset($payload['success']) ? $payload['success'] : false;
                    }
                ),
                'message' => array(
                    'type' => 'String',
                    'resolve' => function($payload) {
                        return isset($payload['message']) ? $payload['message'] : '';
                    }
                ),
            ),
            'mutateAndGetPayload' => function($input) {
                $user_id = get_current_user_id();
                
                if (!$user_id) {
                    return array(
                        'success' => false,
                        'message' => __('User must be logged in', 'gogrocer-backend'),
                    );
                }

                $product_id = $input['productId'];
                $wishlist = get_user_meta($user_id, 'wishlist', true);
                
                if (!is_array($wishlist)) {
                    $wishlist = array();
                }

                if (!in_array($product_id, $wishlist)) {
                    $wishlist[] = $product_id;
                    update_user_meta($user_id, 'wishlist', $wishlist);
                    
                    return array(
                        'success' => true,
                        'message' => __('Product added to wishlist', 'gogrocer-backend'),
                    );
                }

                return array(
                    'success' => false,
                    'message' => __('Product already in wishlist', 'gogrocer-backend'),
                );
            }
        ));
    }
}
