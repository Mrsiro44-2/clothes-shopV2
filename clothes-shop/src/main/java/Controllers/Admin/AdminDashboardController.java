package Controllers.Admin;

import DAO.AccountDAO;
import DAO.ProductDAO;
import DAO.CategoryDAO;
import DAO.BrandDAO;
import DAO.ReportDAO;
import Utils.ServletPaths;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardController", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            
            if (startDate == null || startDate.isEmpty() || endDate == null || endDate.isEmpty()) {
                LocalDate today = LocalDate.now();
                startDate = today.with(TemporalAdjusters.firstDayOfMonth()).format(DateTimeFormatter.ISO_LOCAL_DATE);
                endDate = today.with(TemporalAdjusters.lastDayOfMonth()).format(DateTimeFormatter.ISO_LOCAL_DATE);
            }
            
            int topLimit = 5;
            try {
                if (request.getParameter("topLimit") != null) {
                    topLimit = Integer.parseInt(request.getParameter("topLimit"));
                }
            } catch (Exception e) {}

            ReportDAO reportDao = new ReportDAO();
            
            // Lấy dữ liệu thống kê
            Map<String, Object> summary = reportDao.getRevenueSummary(startDate, endDate);
            Map<String, Object> interactions = reportDao.getInteractionSummary(startDate, endDate);
            List<Map<String, Object>> bestSelling = reportDao.getBestSellingProducts(topLimit, startDate, endDate);
            List<Map<String, Object>> worstSelling = reportDao.getWorstSellingProducts(topLimit, startDate, endDate);
            List<Map<String, Object>> topCustomers = reportDao.getTopCustomers(topLimit, startDate, endDate);
            List<Map<String, Object>> revenueOverTime = reportDao.getRevenueOverTime(startDate, endDate);
            
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("topLimit", topLimit);
            
            request.setAttribute("summary", summary);
            request.setAttribute("interactions", interactions);
            request.setAttribute("bestSelling", bestSelling);
            request.setAttribute("worstSelling", worstSelling);
            request.setAttribute("topCustomers", topCustomers);
            
            // Xây dựng chuỗi JSON cho biểu đồ (đơn giản)
            StringBuilder datesJson = new StringBuilder("[");
            StringBuilder revsJson = new StringBuilder("[");
            for (int i = 0; i < revenueOverTime.size(); i++) {
                Map<String, Object> map = revenueOverTime.get(i);
                datesJson.append("'").append(map.get("date")).append("'");
                revsJson.append(map.get("revenue"));
                if (i < revenueOverTime.size() - 1) {
                    datesJson.append(",");
                    revsJson.append(",");
                }
            }
            datesJson.append("]");
            revsJson.append("]");
            
            request.setAttribute("chartDates", datesJson.toString());
            request.setAttribute("chartRevenues", revsJson.toString());

            request.getRequestDispatcher("/admin/index.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("AdminDashboard: " + e);
            request.setAttribute("error", "Lỗi tải dữ liệu dashboard: " + e.getMessage());
            request.getRequestDispatcher("/admin/index.jsp").forward(request, response);
        }
    }
}
