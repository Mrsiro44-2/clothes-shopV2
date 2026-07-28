package Utils;

/**
 *
 * @author Le Tan Kim
 */
public class Sale {


    /** Phần trăm giảm (0 nếu không giảm). */
    public int salePercent(double newPrice, double oldPrice) {
        if (oldPrice <= 0 || newPrice <= 0 || newPrice >= oldPrice) {
            return 0;
        }
        return (int) Math.round(((oldPrice - newPrice) / oldPrice) * 100.0);
    }

    public String saleBadge(double newPrice, double oldPrice) {
        int pct = salePercent(newPrice, oldPrice);
        return pct > 0 ? "-" + pct + "%" : "";
    }
}
