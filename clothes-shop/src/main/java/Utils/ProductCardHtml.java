package Utils;

import DAO.ColorOptionDAO;
import DAO.ProductVariantDAO;
import Model.ColorOption;
import Model.Product;
import Model.ProductVariant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * HTML product card for AJAX filter (matches user/components/product-card.jsp).
 */
public class ProductCardHtml {

    private final CurrencyConverter currency = new CurrencyConverter();
    private final Sale sale = new Sale();
    private final ImageUrl imageUrl = new ImageUrl();
    private final ProductVariantDAO variantDao = new ProductVariantDAO();
    private final ColorOptionDAO colorDao = new ColorOptionDAO();

    public String renderGrid(List<Product> products, String contextPath, String pathUrl) {
        return renderGrid(products, contextPath, pathUrl, Collections.<Integer, int[]>emptyMap());
    }

    public String renderGrid(List<Product> products, String contextPath, String pathUrl,
            Map<Integer, int[]> wishlistByProduct) {
        if (products == null || products.isEmpty()) {
            return "<div class=\"box-no-found\">\n"
                    + "  <img src=\"./user/img/no-product-found.png\" alt=\"Không tìm thấy\">\n"
                    + "  <p class=\"text-not-found\">Không tìm thấy sản phẩm</p>\n"
                    + "</div>";
        }
        StringBuilder sb = new StringBuilder();
        int index = 0;
        for (Product pro : products) {
            sb.append("<div class=\"col-md-4 col-xs-6 cart-filter\">");
            sb.append(renderCard(pro, contextPath, pathUrl, wishlistByProduct));
            sb.append("</div>");
            if ((index + 1) % 3 == 0) {
                sb.append("<div class=\"clearfix visible-md visible-lg\"></div>");
            }
            if ((index + 1) % 2 == 0) {
                sb.append("<div class=\"clearfix visible-sm visible-xs\"></div>");
            }
            index++;
        }
        return sb.toString();
    }

    public String renderCard(Product pro, String contextPath, String pathUrl) {
        return renderCard(pro, contextPath, pathUrl, Collections.<Integer, int[]>emptyMap());
    }

    public String renderCard(Product pro, String contextPath, String pathUrl,
            Map<Integer, int[]> wishlistByProduct) {
        if (pathUrl == null || pathUrl.isEmpty()) {
            pathUrl = contextPath + "/product";
        }
        String detail = contextPath + "/product/detail/" + pro.getID();
        String img = imageUrl.resolve(pro.getMainImg(), contextPath);
        ProductVariant def = variantDao.findDefaultOrFirst(pro.getID());
        int variantId = def != null ? def.getID() : 0;
        int wishlistId = 0;
        if (wishlistByProduct != null) {
            int[] wl = wishlistByProduct.get(pro.getID());
            if (wl != null && wl.length >= 2 && wl[0] > 0) {
                wishlistId = wl[0];
                if (wl[1] > 0) {
                    variantId = wl[1];
                }
            }
        }
        String cartHref = variantId > 0
                ? contextPath + "/cart/add?productVariantID=" + variantId + "&quantity=1&pathUrl=" + esc(pathUrl)
                : detail;

        StringBuilder sb = new StringBuilder();
        sb.append("<div class=\"product mb-product-card\">");
        sb.append("<div class=\"product-img mb-product-card__media\">");
        sb.append("<a href=\"").append(detail).append("\" class=\"mb-product-card__img-link\">");
        sb.append("<img class=\"mb-img\" src=\"").append(escAttr(img)).append("\" alt=\"")
                .append(escAttr(pro.getName())).append("\" onerror=\"mbImgOnError(this)\"/>");
        sb.append("</a>");
        sb.append(badgesHtml(pro));
        sb.append(wishlistHtml(contextPath, pathUrl, variantId, wishlistId));
        sb.append(overlayHtml(detail, cartHref));
        sb.append("</div>");
        sb.append("<div class=\"product-body mb-product-card__body\">");
        sb.append("<h3 class=\"product-name\"><a href=\"").append(detail).append("\">")
                .append(esc(pro.getName())).append("</a></h3>");
        sb.append(priceHtml(pro, pathUrl));
        sb.append(swatchesHtml(pro.getID()));
        sb.append("</div></div>");
        return sb.toString();
    }

    private String badgesHtml(Product pro) {
        StringBuilder b = new StringBuilder("<div class=\"product-label mb-product-card__badges\">");
        List<ProductVariant> all = variantDao.findByProductId(pro.getID());
        ProductPriceRange range = ProductCardPricing.compute(pro, all);
        int badgePct = 0;
        if (range.isHasSale() && range.getMinOld() > 0 && range.getMaxEffective() > 0) {
            float oldRef = range.getMaxOld() > 0 ? range.getMaxOld() : range.getMinOld();
            badgePct = (int) Math.round((oldRef - range.getMaxEffective()) / oldRef * 100.0);
        } else {
            ProductVariant def = variantDao.findDefaultOrFirst(pro.getID());
            float dispNew = pro.getNewPrice();
            float dispOld = pro.getOldPrice();
            if (def != null) {
                dispNew = def.getNewPrice();
                dispOld = def.getOldPrice();
            }
            badgePct = sale.salePercent(dispNew, dispOld);
        }
        if (badgePct > 0) {
            b.append("<span class=\"sale\">-").append(badgePct).append("%</span>");
        } else if (range.getMinEffective() <= 0) {
            b.append("<span class=\"new\">Mới</span>");
        }
        if (pro.getPriority() == 3) {
            b.append("<span class=\"hot\">Nổi bật</span>");
        }
        b.append("</div>");
        return b.toString();
    }

    private String wishlistHtml(String ctx, String pathUrl, int variantId, int wishlistId) {
        if (variantId <= 0 && wishlistId <= 0) {
            return "";
        }
        if (wishlistId > 0) {
            return "<div class=\"mb-product-card__wish-slot\"><a href=\"" + ctx
                    + "/wishlist/remove?id=" + wishlistId
                    + "\" class=\"mb-product-card__wish mb-product-card__wish--saved mb-confirm\""
                    + " data-confirm-key=\"wishlist-remove\">"
                    + "<i class=\"fa fa-heart\"></i></a></div>";
        }
        return "<div class=\"mb-product-card__wish-slot\"><form class=\"mb-product-card__wish-form\" method=\"post\" action=\"" + ctx
                + "/wishlist/add\">"
                + "<input type=\"hidden\" name=\"productVariantID\" value=\"" + variantId + "\"/>"
                + "<input type=\"hidden\" name=\"pathUrl\" value=\"" + escAttr(pathUrl) + "\"/>"
                + "<button type=\"submit\" class=\"mb-product-card__wish\" title=\"Yeu thich\" aria-label=\"Yeu thich\">"
                + "<i class=\"fa fa-heart-o\"></i></button></form></div>";
    }

    private String overlayHtml(String detail, String cartHref) {
        return "<div class=\"add-to-cart mb-product-card__overlay\">"
                + "<a class=\"mb-product-card__choose\" href=\"" + detail + "\">Chọn tùy chọn</a>"
                + "<a class=\"mb-product-card__quick\" href=\"" + detail + "\" title=\"Xem nhanh\">"
                + "<i class=\"fa fa-eye\"></i></a>"
                + "<a class=\"mb-product-card__cart add-to-cart-btn\" href=\"" + cartHref + "\">"
                + "<i class=\"fa fa-shopping-cart\"></i> Thêm giỏ</a></div>";
    }

    private String priceHtml(Product pro, String pathUrl) {
        List<ProductVariant> all = variantDao.findByProductId(pro.getID());
        ProductPriceRange range = ProductCardPricing.compute(pro, all);
        ProductVariant def = variantDao.findDefaultOrFirst(pro.getID());
        float dispNew = pro.getNewPrice();
        float dispOld = pro.getOldPrice();
        if (def != null) {
            dispNew = def.getNewPrice();
            dispOld = def.getOldPrice();
        }
        String inner = ProductCardPricing.formatDisplayHtml(currency, range, dispNew, dispOld);
        return "<h4 class=\"product-price mb-product-card__price\">" + inner + "</h4>";
    }

    private String swatchesHtml(int productId) {
        List<ProductVariant> all = variantDao.findByProductId(productId);
        Set<Integer> seen = new LinkedHashSet<>();
        List<ColorOption> colors = new ArrayList<>();
        for (ProductVariant v : all) {
            int cid = v.getColorOptionID();
            if (cid > 0 && seen.add(cid)) {
                ColorOption c = colorDao.findById(cid);
                if (c != null) {
                    colors.add(c);
                }
                if (colors.size() >= 5) {
                    break;
                }
            }
        }
        if (colors.isEmpty()) {
            return "";
        }
        StringBuilder s = new StringBuilder("<div class=\"mb-product-card__swatches\">");
        for (ColorOption c : colors) {
            String hex = c.getHexCode();
            if (hex == null || hex.isBlank()) {
                hex = "#cccccc";
            }
            if (!hex.startsWith("#")) {
                hex = "#" + hex;
            }
            s.append("<span class=\"mb-product-card__swatch\" style=\"background-color:")
                    .append(escAttr(hex)).append(";\" title=\"")
                    .append(escAttr(c.getName())).append("\"></span>");
        }
        s.append("</div>");
        return s.toString();
    }

    private static String esc(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }

    private static String escAttr(String s) {
        if (s == null) {
            return "";
        }
        return esc(s).replace("\"", "&quot;");
    }
}
