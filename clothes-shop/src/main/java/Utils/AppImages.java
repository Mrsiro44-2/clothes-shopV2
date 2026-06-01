package Utils;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Banner trang chủ và tiện ích ảnh.
 */
public class AppImages {

  /** Ảnh bìa blog khi bài viết không có coverImg. */
  public static final String BLOG_DEFAULT_COVER =
      "https://images.unsplash.com/photo-1515488042361-ee00e945a1be?w=800&q=80";

  public static final String[] HOME_BANNER_URLS = {
    "user/img/home-banner-1.png",
    "user/img/home-banner-2.png",
    "user/img/home-banner-3.png"
  };

  public AppImages() {
  }

  public List<String> getHomeBannerList() {
    return Collections.unmodifiableList(Arrays.asList(HOME_BANNER_URLS));
  }
}
