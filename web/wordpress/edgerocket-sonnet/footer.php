<?php
/**
 * The template for displaying the footer.
 *
 * Contains the closing of the #content div and all content after
 *
 * @package Sonnet
 */
global $sonnetwp;
?>
<div class="footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-3 col-sm-3 animated animate-from-left">
                <p>
                    <?php echo nl2br($sonnetwp['footer_text_left']);?>
                </p>
            </div>
            <div class="col-lg-6 col-sm-6 text-center animated animate-from-top">
                <a href="#home" class="f-logo">
                    <img src="<?php echo $sonnetwp['footer_logo']['url'] ;?>" alt="">
                    <div class="social">
                        <?php
                            if($sonnetwp['social_facebook']) echo "<a href='{$sonnetwp['social_facebook']}'><i class='fa fa-facebook'></i></a>";
                        ?>
                        <?php
                            if($sonnetwp['social_twitter']) echo "<a href='{$sonnetwp['social_twitter']}'><i class='fa fa-twitter'></i></a>";
                        ?>
			<?php
                            if($sonnetwp['social_googleplus']) echo "<a href='{$sonnetwp['social_googleplus']}'><i class='fa fa-google-plus'></i></a>";
                        ?>

                        <a href='https://www.linkedin.com/company/edgerocket'><i class='fa fa-linkedin'></i></a>


                    </div>
                </a>
            </div>
            <div class="col-lg-3 col-sm-3 animated animate-from-right">
                <p>
                    <?php echo nl2br($sonnetwp['footer_text_right']);?>
                </p>
            </div>
        </div>
    </div>
</div>
<!--footer end-->
    <?php wp_footer(); ?>

    <script>
        (function($) {
            // Hover effect
            $(window).load(function() {
                $('[data-zlname = reverse-effect]').mateHover({
                    position: 'y-reverse',
                    overlayStyle: 'rolling',
                    overlayBg: '#fff',
                    overlayOpacity: 0.7,
                    overlayEasing: 'easeOutCirc',
                    rollingPosition: 'top',
                    popupEasing: 'easeOutBack',
                    popup2Easing: 'easeOutBack'
                });
            });
        })(jQuery);
    </script>
</body>
</html>
