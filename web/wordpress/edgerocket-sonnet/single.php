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
                        <h1>Blog</h1>
                        <h4><?php bloginfo( 'description' ); ?></h4>
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
                <h1><?php echo strtoupper(get_the_date("j M"));?></h1>
                <div class="col-lg-12">
                    <h2 class="dark-txt"><?php the_title();?></h2>
                    <div class="ath-date-row text-left-pos">
                        <div class="author">
                            <a href="/wp-admin/post.php?post=<?php echo $post->ID;?>&action=edit"><i class="fa fa-edit"></i></a>
                            <?php the_author();?>
                        </div>
                        <div class="date">
                            <i class="fa fa-clock-o"></i>
                            <?php the_date();?>
                        </div>
                        <div class="comments">
                            <i class="fa fa-comments-o"></i>
                            <?php comments_number();?>
                        </div>
                    </div>
                </div>
                <div class="col-lg-12 blog-details">
                    <?php the_post_thumbnail();?>
                    <?php the_content();?>

                    <div class="blog-tag" style="margin-top: 50px;">
                        <?php
                            $categories = wp_get_post_terms($post->ID,"category");
                            if($categories) echo '<span> Posted In : </span>';
                        ?>

                        <?php

                            //print_r($categories);
                            if($categories){
                                foreach($categories as $c){
                                    echo " <span class='red'><a href='/category/{$c->name}'>{$c->name}</a></span>";
                                }
                            }
                        ?>
                    </div>
                    <div class="blog-tag">
                            <span>
                                Tag : </span>
                        <?php
                        echo get_the_tag_list("",", ","");
                        ?>
                    </div>
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
    <section class="comments-row">
        <div class="container">
            <div class="row">
                <?php
                // If comments are open or we have at least one comment, load up the comment template
                if ( comments_open() || '0' != get_comments_number() )
                    comments_template();
                ?>
            </div>
        </div>
    </section>
    <!--blog section end-->
<?php get_footer(); ?>
