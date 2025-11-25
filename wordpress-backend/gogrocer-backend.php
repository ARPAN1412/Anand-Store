<?php
/**
 * Plugin Name: GoGrocer Backend API
 * Plugin URI: https://gogrocer.com
 * Description: WordPress Headless Backend with WPGraphQL for GoGrocer Flutter App
 * Version: 1.0.0
 * Author: Your Name
 * Author URI: https://gogrocer.com
 * License: GPL2
 * Text Domain: gogrocer-backend
 *
 * @package GoGrocer_Backend
 */

// Exit if accessed directly
if (!defined('ABSPATH')) {
    exit;
}

// Define plugin constants
define('GOGROCER_VERSION', '1.0.0');
define('GOGROCER_PLUGIN_DIR', plugin_dir_path(__FILE__));
define('GOGROCER_PLUGIN_URL', plugin_dir_url(__FILE__));

// Include required files
require_once GOGROCER_PLUGIN_DIR . 'includes/class-custom-post-types.php';
require_once GOGROCER_PLUGIN_DIR . 'includes/class-graphql-queries.php';
require_once GOGROCER_PLUGIN_DIR . 'includes/class-graphql-mutations.php';
require_once GOGROCER_PLUGIN_DIR . 'includes/class-custom-fields.php';

/**
 * Main Plugin Class
 */
class GoGrocer_Backend {
    
    /**
     * Instance of this class
     */
    private static $instance = null;

    /**
     * Get instance
     */
    public static function get_instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    /**
     * Constructor
     */
    private function __construct() {
        add_action('plugins_loaded', array($this, 'init'));
        add_action('init', array($this, 'load_textdomain'));
        register_activation_hook(__FILE__, array($this, 'activate'));
        register_deactivation_hook(__FILE__, array($this, 'deactivate'));
    }

    /**
     * Initialize plugin
     */
    public function init() {
        // Check if WPGraphQL is active
        if (!class_exists('WPGraphQL')) {
            add_action('admin_notices', array($this, 'wpgraphql_missing_notice'));
            return;
        }

        // Initialize classes
        GoGrocer_Custom_Post_Types::init();
        GoGrocer_GraphQL_Queries::init();
        GoGrocer_GraphQL_Mutations::init();
        GoGrocer_Custom_Fields::init();
    }

    /**
     * Load text domain
     */
    public function load_textdomain() {
        load_plugin_textdomain('gogrocer-backend', false, dirname(plugin_basename(__FILE__)) . '/languages');
    }

    /**
     * Activation hook
     */
    public function activate() {
        // Register custom post types
        GoGrocer_Custom_Post_Types::init();
        GoGrocer_Custom_Post_Types::register_post_types();
        
        // Flush rewrite rules
        flush_rewrite_rules();
    }

    /**
     * Deactivation hook
     */
    public function deactivate() {
        // Flush rewrite rules
        flush_rewrite_rules();
    }

    /**
     * WPGraphQL missing notice
     */
    public function wpgraphql_missing_notice() {
        ?>
        <div class="error">
            <p><?php _e('GoGrocer Backend requires WPGraphQL plugin to be installed and activated.', 'gogrocer-backend'); ?></p>
            <p><a href="https://www.wpgraphql.com/" target="_blank"><?php _e('Download WPGraphQL', 'gogrocer-backend'); ?></a></p>
        </div>
        <?php
    }
}

// Initialize plugin
GoGrocer_Backend::get_instance();
