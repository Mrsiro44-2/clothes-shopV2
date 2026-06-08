package Utils;
import Controllers.User.*;
import DAO.BrandDAO;
import DAO.CategoryDAO;
import DAO.FeedbackDAO;
import DAO.ImgDescriptionDAO;
import DAO.ProductDAO;
import DAO.ProductVariantDAO;
import Model.Brand;
import Model.Category;
import Model.Feedback;
import Model.ImgDescription;
import Model.Product;
import Model.ProductVariant;
import Utils.ServletPaths;
import Utils.Validation;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;


@WebServlet(name = "ProductUserController", urlPatterns = {"/product/*"})
public class ProductUserController extends HttpServlet {

    private static CategoryDAO categoryDao;
    private static BrandDAO brandDao;
    private static ProductDAO productDao;
    private static Validation validate;
    private static FeedbackDAO feedbackDao;
    private static final int numberProductInPage = 9;

    public ProductUserController() {
        this.categoryDao = new CategoryDAO();
        this.productDao = new ProductDAO();
        this.validate = new Validation();
        this.feedbackDao = new FeedbackDAO();
        this.brandDao = new BrandDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (ServletPaths.relativeEquals(request, "/product")
                || ServletPaths.relativeEquals(request, "/product/")) {
            this.productPage(request, response, 1, numberProductInPage);
        } else if (ServletPaths.relativeStartsWith(request, "/product/page-")) {
            int page = ServletPaths.parsePageSuffix(request, "page-");
            if (page <= 0) {
                ServletPaths.redirect404(request, response);
                return;
            }
            this.productPage(request, response, page, numberProductInPage);
        } else if (ServletPaths.relativeStartsWith(request, "/product/detail/")) {
            int id = validate.getInt(ServletPaths.lastSegment(request));
            Product p = productDao.statusIsActive(id);
            if (p == null) {
                ServletPaths.redirect404(request, response);
            } else {
                ImgDescriptionDAO imgDescDao = new ImgDescriptionDAO();
                ProductVariantDAO variantDao = new ProductVariantDAO();
                List<ImgDescription> imgDesc = imgDescDao.getAllImgDescriptionByProduct(id);
                List<Product> productsRelative = productDao.getAllProductActiveRelative(p);
                List<Feedback> feedbacks = feedbackDao.allFeedbackActiveByProduct(id);
                List<ProductVariant> variants = variantDao.findByProductId(id);
                ProductVariant defaultVariant = variantDao.findDefaultOrFirst(id);
                request.setAttribute("feedbacks", feedbacks);
                request.setAttribute("product", p);
                request.setAttribute("imgDesc", imgDesc);
                request.setAttribute("productsRelative", productsRelative);
                request.setAttribute("variants", variants);
                request.setAttribute("defaultVariant", defaultVariant);
                request.setAttribute("variantsJson", new Gson().toJson(variants));
                if (variants.isEmpty()) {
                    request.setAttribute("variantStockNote", "Sản phẩm chưa có biến thể khả dụng.");
                }
                request.getRequestDispatcher("/user/detailProduct.jsp").forward(request, response);
            }
        }
    }



    private void productPage(HttpServletRequest request, HttpServletResponse response, int page, int pageSize)
            throws IOException, ServletException {
        try {
            String keyword = request.getParameter("keyword");
            String[] categoryIds = request.getParameterValues("category");
            String[] brandIds = request.getParameterValues("brand");
            float minPrice = validate.getFloat(request.getParameter("minPrice"));
            float maxPrice = validate.getFloat(request.getParameter("maxPrice"));
            int sort = validate.getInt(request.getParameter("sort"));

            List<Category> categories = categoryDao.getCategoryActive();
            List<Brand> brands = brandDao.getBrandActive();
            
            List<Product> products = productDao.searchAndFilterProducts(keyword, categoryIds, brandIds, minPrice, maxPrice, sort, page, pageSize);
            int allProduct = productDao.countSearchAndFilterProducts(keyword, categoryIds, brandIds, minPrice, maxPrice);

            StringBuilder keyBuilder = new StringBuilder("?");
            if (keyword != null && !keyword.trim().isEmpty()) {
                keyBuilder.append("keyword=").append(keyword).append("&");
            }
            if (categoryIds != null) {
                for (String cat : categoryIds) {
                    keyBuilder.append("category=").append(cat).append("&");
                }
            }
            if (brandIds != null) {
                for (String brand : brandIds) {
                    keyBuilder.append("brand=").append(brand).append("&");
                }
            }
            if (minPrice >= 0) keyBuilder.append("minPrice=").append(minPrice).append("&");
            if (maxPrice > 0) keyBuilder.append("maxPrice=").append(maxPrice).append("&");
            if (sort >= 0) keyBuilder.append("sort=").append(sort).append("&");
            
            String key = keyBuilder.toString();
            if (key.endsWith("&")) key = key.substring(0, key.length() - 1);
            if (key.equals("?")) key = "";

            if (products.size() == 0 && page != 1) {
                ServletPaths.redirect404(request, response);
            } else {
                request.setAttribute("categories", categories);
                request.setAttribute("brands", brands);
                request.setAttribute("products", products);
                request.setAttribute("page", page);
                request.setAttribute("pageSize", pageSize);
                request.setAttribute("sizeProduct", allProduct);
                request.setAttribute("urlPage", "product");
                request.setAttribute("key", key);
                
                List<Integer> selectedCats = new ArrayList<>();
                if (categoryIds != null) {
                    for (String s : categoryIds) {
                        selectedCats.add(validate.getInt(s));
                    }
                }
                
                List<Integer> selectedBrnds = new ArrayList<>();
                if (brandIds != null) {
                    for (String s : brandIds) {
                        selectedBrnds.add(validate.getInt(s));
                    }
                }
                
                request.setAttribute("keyword", keyword != null ? keyword : "");
                request.setAttribute("selectedCategories", selectedCats);
                request.setAttribute("selectedBrands", selectedBrnds);
                request.setAttribute("minPrice", minPrice >= 0 ? minPrice : "");
                request.setAttribute("maxPrice", maxPrice > 0 ? maxPrice : "");
                request.setAttribute("sort", sort >= 0 ? sort : 0);
                
                request.getRequestDispatcher("/user/product.jsp").forward(request, response);
            }
        } catch (Exception e) {
            System.out.println("Product page: " + e);
        }
    }
}


