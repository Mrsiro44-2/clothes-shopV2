package Utils;

/**
 * Chuẩn hóa đường dẫn ảnh lưu trong DB thành URL trình duyệt tải được.
 */
public class ImageUrl {

    public String resolve(String storedPath, String contextPath) {
        if (storedPath == null) {
            return "";
        }
        String path = storedPath.trim();
        if (path.isEmpty()) {
            return "";
        }
        if (path.startsWith("http://") || path.startsWith("https://")) {
            return path;
        }
        if (path.startsWith("//")) {
            return "https:" + path;
        }
        String ctx = contextPath == null ? "" : contextPath.trim();
        if (ctx.endsWith("/")) {
            ctx = ctx.substring(0, ctx.length() - 1);
        }

        String rel = path;
        
        if (!ctx.isEmpty()) {
            while (rel.startsWith(ctx + "/")) {
                rel = rel.substring(ctx.length());
            }
        }
        
        if (rel.startsWith("./")) {
            rel = rel.substring(2);
        }
        while (rel.startsWith("/")) {
            rel = rel.substring(1);
        }
        
        if (ctx.isEmpty()) {
            return "/" + rel;
        }
        return ctx + "/" + rel;
    }

    public boolean isEmpty(String storedPath) {
        return storedPath == null || storedPath.trim().isEmpty();
    }
}
