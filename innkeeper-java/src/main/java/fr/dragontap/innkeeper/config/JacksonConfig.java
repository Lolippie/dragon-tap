package fr.dragontap.innkeeper.config;

import org.springframework.boot.jackson.autoconfigure.JsonMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import tools.jackson.databind.PropertyNamingStrategies;
import tools.jackson.databind.cfg.DateTimeFeature;
import tools.jackson.databind.json.JsonMapper;

import java.util.TimeZone;

@Configuration
public class JacksonConfig {

    /**
     * Configure Jackson 3.x (tools.jackson) :
     * - Nommage snake_case pour les propriétés JSON (table_number, order_item_id…)
     * - Dates sérialisées en ISO 8601 (pas en timestamp numérique)
     * - Timezone UTC
     */
    @Bean
    public JsonMapperBuilderCustomizer jacksonCustomizer() {
        return (JsonMapper.Builder builder) -> builder
                .propertyNamingStrategy(PropertyNamingStrategies.SNAKE_CASE)
                .disable(DateTimeFeature.WRITE_DATES_AS_TIMESTAMPS)
                .defaultTimeZone(TimeZone.getTimeZone("UTC"));
    }
}
