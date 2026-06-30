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
            
            // Map existing revenue
            java.util.Map<String, Float> revMap = new java.util.HashMap<>();
            for (Map<String, Object> map : revenueOverTime) {
                String d = map.get("date").toString();
                float rev = Float.parseFloat(map.get("revenue").toString());
                revMap.put(d, rev);
            }

            // Xây dựng chuỗi JSON cho biểu đồ (đơn giản), fill những ngày không có doanh thu
            StringBuilder datesJson = new StringBuilder("[");
            StringBuilder revsJson = new StringBuilder("[");
            
            LocalDate start = LocalDate.parse(startDate);
            LocalDate end = LocalDate.parse(endDate);
            boolean first = true;
            
            for (LocalDate d = start; !d.isAfter(end); d = d.plusDays(1)) {
                String dStr = d.toString();
                float rev = revMap.getOrDefault(dStr, 0f);
                if (!first) {
                    datesJson.append(",");
                    revsJson.append(",");
                }
                datesJson.append("'").append(dStr).append("'");
                revsJson.append(rev);
                first = false;
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
