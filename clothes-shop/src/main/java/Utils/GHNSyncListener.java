package Utils;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class GHNSyncListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;
    private GHNSyncService syncService;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[GHN Sync Listener] Initializing background task...");
        syncService = new GHNSyncService();
        scheduler = Executors.newSingleThreadScheduledExecutor();

        // Chạy ngay lập tức lần đầu (delay 0), sau đó chạy định kỳ mỗi 1 phút (theo yêu cầu của user)
        scheduler.scheduleAtFixedRate(() -> {
            try {
                syncService.syncOrders();
            } catch (Exception e) {
                System.out.println("[GHN Sync Listener] Execution error: " + e.getMessage());
            }
        }, 0, 1, TimeUnit.MINUTES);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[GHN Sync Listener] Shutting down background task...");
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
    }
}
