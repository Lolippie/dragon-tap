package fr.dragontap.innkeeper.health;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/health")
@RequiredArgsConstructor
@Slf4j
public class HealthController {

    private final DataSource dataSource;

    @GetMapping
    public ResponseEntity<Map<String, String>> health() {
        try (Connection conn = dataSource.getConnection()) {
            conn.createStatement().executeQuery("SELECT 1");
            var body = new LinkedHashMap<String, String>();
            body.put("status", "ok");
            body.put("database", "ok");
            body.put("timestamp", Instant.now().toString());
            return ResponseEntity.ok(body);
        } catch (SQLException e) {
            log.error("Database health check failed", e);
            var body = new LinkedHashMap<String, String>();
            body.put("status", "error");
            body.put("database", "unreachable");
            return ResponseEntity.status(503).body(body);
        }
    }
}
