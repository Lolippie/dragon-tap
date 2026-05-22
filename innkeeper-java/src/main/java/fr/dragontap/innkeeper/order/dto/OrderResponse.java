package fr.dragontap.innkeeper.order.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import fr.dragontap.innkeeper.order.entity.OrderStatus;
import lombok.Builder;
import lombok.Value;

import java.time.Instant;
import java.util.List;

@Value
@Builder
public class OrderResponse {
    int id;
    int tableNumber;
    OrderStatus status;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", timezone = "UTC")
    Instant createdAt;
    List<OrderItemResponse> items;
}
