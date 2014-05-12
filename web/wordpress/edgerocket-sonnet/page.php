<?php
/**
 * The Template for displaying all single posts.
 *
 * @package Sonnet
 */
global $post;
global $blogmenu;
$blogmenu = true;
setup_postdata($post);
get_template_part("header");
?>

    <!--blog header start-->
    <section class="blog-head">
        <div class="container">
            <div class="row">
                <div class="common-heading light-color text-center ban-head-pos">
                    <div class="border-top-bot blog-title">
                    </div>
                </div>
            </div>
        </div>
    </section>
    <!--blog header end-->
    <!--blog section start-->
    <section class="blog">
        <div class="container">
            <div class="row">
                <div class="col-lg-12">
                    <h2 class="dark-txt"><?php the_title();?></h2>
                </div>
                <div class="col-lg-12 blog-details">
                    <?php the_post_thumbnail();?>
                    <?php the_content();?>

                </div>
            </div>
        </div>
    </section>
    <section class="share-row">
        <div class="container">
            <div class="row">
                <div class="col-lg-2 col-sm-2 col-xs-2">
                    Share
                </div>
                <div class="col-lg-10 col-sm-10 col-xs-10">
                    <ul class="social-links pull-right">
                        <li><a href="#"><i class="fa fa-facebook"></i></a></li>
                        <li><a href="#"><i class="fa fa-twitter"></i></a></li>
                        <li><a href="#"><i class="fa fa-google-plus"></i></a></li>
                    </ul>
                </div>
            </div>
        </div>
    </section>
    <!--blog section end-->
<?php get_footer(); ?>
