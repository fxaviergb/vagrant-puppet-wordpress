<?php
/*
Plugin Name: Redirect to Latest Post
Description: Redirects to the latest post on the first visit to the homepage, while allowing navigation back to the homepage.
Version: 1.2
Author: Fernando Garnica
*/

function redirect_to_latest_post_once() {
    // Check if it's the homepage, not in admin, and no cookie exists
    if (is_front_page() && !is_admin() && !isset($_COOKIE['redirect_to_post'])) {
        $latest_post = get_posts(array(
            'numberposts' => 1,
        ));
        if (!empty($latest_post)) {
            // Set a cookie to prevent further redirections
            setcookie('redirect_to_post', '1', time() + 3600, '/'); // 1-hour duration
            wp_redirect(get_permalink($latest_post[0]->ID));
            exit;
        }
    }
}
add_action('template_redirect', 'redirect_to_latest_post_once');
?>
