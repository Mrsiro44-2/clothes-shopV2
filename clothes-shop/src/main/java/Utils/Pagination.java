package Utils;

/**
 * Phân trang HTML cho trang user (store listing).
 */
public class Pagination {

    private static final int DEFAULT_PAGE_SIZE = 9;

    public int totalPages(int totalItems, int pageSize) {
        if (pageSize < 1) {
            pageSize = DEFAULT_PAGE_SIZE;
        }
        if (totalItems <= 0) {
            return 1;
        }
        return (int) Math.ceil((double) totalItems / pageSize);
    }

    public String generatePagination(int currentPage, int totalPages, String typePage, String... key) {
        return generatePagination(currentPage, totalPages, DEFAULT_PAGE_SIZE, 0, typePage, key);
    }

    public String generatePagination(int currentPage, int totalPages, int pageSize, int totalItems,
            String typePage, String... key) {
        if (currentPage < 1) {
            currentPage = 1;
        }
        if (totalPages < 1) {
            totalPages = 1;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        if (pageSize < 1) {
            pageSize = DEFAULT_PAGE_SIZE;
        }

        String keyPath = buildKeyPath(key);

        int from = (currentPage - 1) * pageSize + 1;
        int to = totalItems > 0
                ? Math.min(currentPage * pageSize, totalItems)
                : Math.min(currentPage * pageSize, totalPages * pageSize);

        StringBuilder html = new StringBuilder();
        html.append("<div class=\"store-filter clearfix\">");
        html.append("<span class=\"store-qty\">Hiển thị ").append(from).append("–").append(to)
                .append(" / ").append(totalItems).append(" sản phẩm</span>");
        html.append("<ul class=\"store-pagination\">");

        if (currentPage > 1) {
            html.append(pageLink(typePage, currentPage - 1, keyPath, "<i class=\"fa fa-angle-left\"></i>"));
        }

        int delta = 2;
        Integer previousShown = null;

        for (int p = 1; p <= totalPages; p++) {
            boolean show = p == 1 || p == totalPages
                    || (p >= currentPage - delta && p <= currentPage + delta);

            if (!show) {
                continue;
            }

            if (previousShown != null && p - previousShown > 1) {
                html.append("<li><span>...</span></li>");
            }

            if (p == currentPage) {
                html.append("<li class=\"active\">").append(p).append("</li>");
            } else {
                html.append(pageLink(typePage, p, keyPath, String.valueOf(p)));
            }
            previousShown = p;
        }

        if (currentPage < totalPages) {
            html.append(pageLink(typePage, currentPage + 1, keyPath, "<i class=\"fa fa-angle-right\"></i>"));
        }

        html.append("</ul></div>");
        return html.toString();
    }

    private String buildKeyPath(String... key) {
        String keyPath = String.join("", key);
        if (keyPath == null || keyPath.isEmpty()) {
            return "";
        }
        if (!keyPath.startsWith("?")) {
            keyPath = "?keyword=" + keyPath;
        }
        return keyPath;
    }

    private String pageLink(String typePage, int page, String keyPath, String label) {
        return "<li><a href=\"" + typePage + "/page-" + page + keyPath + "\">" + label + "</a></li>";
    }
}
