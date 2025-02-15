<?php if (isset($_SERVER["HTTP_X_FORWARDED_FOR"])) {
    $list = explode(",", $_SERVER["HTTP_X_FORWARDED_FOR"]);
    $_SERVER["REMOTE_ADDR"] = $list[0];
}
$_SERVER["HTTP_HOST"] = "w-ivanhumara.duckdns.org";
$_SERVER["REMOTE_ADDR"] = "w-ivanhumara.duckdns.org";
$_SERVER["SERVER_ADDR"] = "w-ivanhumara.duckdns.org";

/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress_db' );

/** Database username */
define( 'DB_USER', 'admin' );

/** Database password */
define( 'DB_PASSWORD', 'Admin123' );

/** Database hostname */
define( 'DB_HOST', 'cms-database.c7aaohdxnqio.us-east-1.rds.amazonaws.com' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          'Iy:Zi?G9GUdAOnfyjt)iLWUKqt7U3FP8ApX*awK1c({}EJ|Rzmu|^eQaX5]N3>!9' );
define( 'SECURE_AUTH_KEY',   'cL!v::{8!^Gw_P8@[#QRW;,1n4~x1Y&CYc:Aui;K$!Ceba>)CM=@7)AFf.9TX2#e' );
define( 'LOGGED_IN_KEY',     'tFin#jO7Q*-y9e2lwkmzA-& uc6_%H0qjU*[QZ6anbzyiA/gQU#j`kd,j^dPGX1Q' );
define( 'NONCE_KEY',         '?{O`RT}/T1JKKx15uxxc3x,]ExIR@|.mg35 .pJYeie/;4Wje*:XiEWM,]AZ8hbP' );
define( 'AUTH_SALT',         '_SuoYn_, 1Ka(%tz?MnlD%!eVg++hhw(.z.U@8Q}?.p2O}0P=JZT<|]Qw^r6Z{&=' );
define( 'SECURE_AUTH_SALT',  'Gf5H#-UL!f;X5Y)KecItsn2MP+ A=Ke^oFm2siPdh4{{&j[lOF{sWei=D*mcGp$j' );
define( 'LOGGED_IN_SALT',    '~;D89dfKK2~c0gI>|xa<o.8o[o9RZf>28Kc)n5.~mS=5$=?dT5M*t9XWeab_.^P<' );
define( 'NONCE_SALT',        'PBm=Zaq|;ErNRY:O8n5>WPK&2.&SU!.{LPD|xb@EOQ*}C?}lT2|=[>Z!{)yHC5Os' );
define( 'WP_CACHE_KEY_SALT', '8z,j_4}YwaYX:S{JV|eU|/q0<B]%;Ak=@W NfBL_hp@x|@]Dfw,3vR#6Pl]FZQ=:' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if ( ! defined( 'WP_DEBUG' ) ) {
        define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';