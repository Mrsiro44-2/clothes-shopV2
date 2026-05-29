/*

 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license

 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template

 */
package Controllers.User;

import DAO.BrandDAO;
import DAO.CategoryDAO;
import DAO.ProductDAO;
import Model.Brand;
import Model.Category;
import Model.Product;
import Utils.ServletPaths;
import Utils.Validation;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 *
 *
 * @author HP
 *
 */
@WebServlet(name = "SearchProductController", urlPatterns = {"/product/search/*"})

public class SearchProductController extends HttpServlet {

    private static final int numberProductInPage = 9;

    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        if (ServletPaths.relativeEquals(request, "/product/search")
                || ServletPaths.relativeEndsWith(request, "/product/search/")) {

            String keyword = request.getParameter("keyword");

            session.setAttribute("key", keyword);

            this.searchPage(request, response, keyword, 1, numberProductInPage);

        } else if (ServletPaths.relativeStartsWith(request, "/product/search/page-")) {

            String key = (String) session.getAttribute("key");

            int page = ServletPaths.parsePageSuffix(request, "page-");

            if (page <= 0) {

                ServletPaths.redirect404(request, response);

                return;

            }

            this.searchPage(request, response, key, page, numberProductInPage);

        }

    }

    private void searchPage(HttpServletRequest request, HttpServletResponse response, String keyword, int page, int pageSize)
            throws ServletException, IOException {

        try {

            BrandDAO brandDao = new BrandDAO();

            CategoryDAO categoryDao = new CategoryDAO();

            ProductDAO productDao = new ProductDAO();

            List<Product> products = productDao.seachProduct(keyword, page, pageSize);

            List<Category> categories = categoryDao.getCategoryActive();

            List<Brand> brands = brandDao.getBrandActive();

            request.setAttribute("categories", categories);

            request.setAttribute("brands", brands);

            request.setAttribute("keyword", keyword);

            request.setAttribute("products", products);

            int total = productDao.seachProduct(keyword).size();

            request.setAttribute("page", page);

            request.setAttribute("pageSize", pageSize);

            request.setAttribute("sizeProduct", total);

            request.setAttribute("searchEmpty", total == 0);

            request.getRequestDispatcher("/user/search.jsp").forward(request, response);

        } catch (Exception e) {

            System.out.println("Product page: " + e);

        }

    }

    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override

    public String getServletInfo() {

        return "Short description";

    }

}
