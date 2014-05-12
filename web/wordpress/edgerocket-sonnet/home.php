<?php
/**
 * Template Name: Blog
 */
global $blogmenu;
$blogmenu = true;
get_template_part("header");
?>
    <!--blog header start-->
    <section class="blog-head" >
        <div class="container">
            <div class="row ">
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
<?php
$i = 0;
while (have_posts()) {
    $i++;
    the_post();
    get_template_part("post-templates/post", get_post_format());
    //get_template_part("post-templates/post".get_post_format());
}
?>
    <section class="pagination-row">
        <div class="container">
            <div class="row">
                <div class="text-center">
                    <ul class="pagination">
                        <?php
                        global $wp_query;

                        $big = 999999999; // need an unlikely integer

                        $links = paginate_links(array(
                            'base' => str_replace($big, '%#%', esc_url(get_pagenum_link($big))),
                            'format' => '?paged=%#%',
                            'current' => max(1, get_query_var('paged')),
                            'total' => $wp_query->max_num_pages,
                            'type' => 'array',
                            'prev_next' => true,
                            'prev_text' => '<i class="fa fa-angle-left"></i>',
                            "next_text" => '<i class="fa fa-angle-right"></i>',
                            'mid_size' => 3
                        ));
                        //print_r($links);
                        if ($links) {
                            foreach ($links as $link) {
                                if (strpos($link, "current") !== false)
                                    echo '<li class="active"><a>' . $link . "</a></li>\n";
                                else
                                    echo '<li>' . $link . "</li>\n";

                            }
                        }
                        ?>
                    </ul>
                </div>
            </div>
        </div>
    </section>
<?php
get_template_part("footer");
?>