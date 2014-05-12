<?php
/**
 * The Header for our theme.
 *
 * Displays all of the <head> section and everything up till <div id="content">
 *
 * @package Sonnet
 */
?><!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
	<meta charset="<?php bloginfo( 'charset' ); ?>">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title><?php wp_title( '|', true, 'right' ); ?></title>
	<link rel="profile" href="http://gmpg.org/xfn/11">
	<link rel="pingback" href="<?php bloginfo( 'pingback_url' ); ?>">
	<meta name="keywords" content="One page, Parallux, Bootstrap, Portfolio, Template, Theme, Responsive">

	<?php wp_head(); ?>

    <?php
    global $sonnetwp;
    if($sonnetwp['custom_css']){
        echo $sonnetwp['custom_css'];
    }
    if($sonnetwp['google_analytics_code']){
        echo $sonnetwp['google_analytics_code'];

    }

    ?>
    <style type="text/css">
        <?php
        if($sonnetwp['sidebar_off']){
            echo "#timeline { opacity:0 }";
        }
        ?>

    </style>
</head>
<?php
global $blogmenu;
$blogprefix = "";
$logourl = "/";
$menus1 = $menus2 = array();
$sections = get_custom_posts("section",40,"_sonnet_section_order");
$i=0;

if($blogmenu) $blogprefix = "/";
if(!$blogmenu) $logourl = "#";
foreach($sections as $section){

    $section_meta = get_post_meta($section->ID);
    $section_title = @$section_meta['_sonnet_section_menu']['0'];
    if(!$section_title) $section_title = $section->post_title;
    if(!@$section_meta['_sonnet_section_menu_hide'][0]){
        $i++;
        $menus1[] = '<li class=""><a href="'.$blogprefix.'#'. $section->post_name .'" title="'.$section_title.'">'.$section_title.'</a></li>';
        $menus2[] = '<div class="link link-dot-position-'. $i .'">
                <span class="dot">&nbsp;</span><a href="'.$blogprefix.'#'.$section->post_name.'" class="innerlink">'.$section_title.'</a>
            </div>';
    }
}
$blog_page_url = get_permalink(get_option("page_for_posts"));
$menus1[] = '<li class=""><a href="'.$blog_page_url.'" title="Blog">Blog</a></li>';
$menus1[] = '<li class=""><a href="https://edgerocket.herokuapp.com" title="Log in">Log in</a></li>';
//$menus2[] = '<div class="link link-dot-position-'. ($i+1) .'">
//                <span class="dot">&nbsp;</span><a href="/blog" class="innerlink">Blog</a>
//            </div>';
wp_reset_postdata();
wp_reset_query();
?>
<body <?php body_class(); ?>>
<?php if(!$blogprefix){?>
        <div class="page-mask">
           <div class="page-loader">
               <div class="spinner"></div>
               Loading...
           </div>
       </div>
<?php }?>
	<!--timeline menu start
	<div id="timeline">
		<div class="line">
		</div>
		<?php echo join("",$menus2);?>
	</div>
	timeline menu end-->
	<!--header start-->
	<nav id="top-bar" class="fix-top">
		<div class="container">
			<div class="navbar-header responsive-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a href="<?php echo $logourl;?>" class="navbar-brand logo">
                    <?php
                        $logo = $sonnetwp['theme_logo']['url'];
                        if($logo){
                    ?>
					<img src="<?php echo $logo;?>" alt="sonnet">
                    <?php } else { ?>
                        <h2 class="logo"><?php bloginfo( 'name' ); ?></h2>
                    <?php } ?>
				</a>
			</div>
			<div class="collapse navbar-collapse navbar-ex1-collapse">
                <?php if(!$blogmenu){?>
				<ul class="nav navbar-nav pull-right topmenu">
                    <?php
                        echo join('<li class="seperator">/</li>',$menus1);
                    ?>
				</ul>
                <?php } else {
                    wp_nav_menu( array('container'=>'false', 'menu_class'=>'nav navbar-nav pull-right topmenu sf-menu inner-nav menu-primary-navigation','container_class' => 'menu-header', 'theme_location' => 'primary' ) );
                }
                ?>
			</div>
		</div>
	</nav>
	<!--header end-->
