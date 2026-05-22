package fr.dragontap.innkeeper.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableTransactionManagement
public class JpaConfig {
    // Spring Boot auto-configure JPA. Ce fichier accueille les futures
    // personnalisations (auditing, custom converters, etc.).
}
