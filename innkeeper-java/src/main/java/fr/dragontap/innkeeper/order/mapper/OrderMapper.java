package fr.dragontap.innkeeper.order.mapper;

import fr.dragontap.innkeeper.order.dto.OrderItemResponse;
import fr.dragontap.innkeeper.order.dto.OrderResponse;
import fr.dragontap.innkeeper.order.entity.Order;
import fr.dragontap.innkeeper.order.entity.OrderItem;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class OrderMapper {

    public OrderResponse toResponse(Order order) {
        List<OrderItemResponse> items = order.getItems() == null
                ? List.of()
                : order.getItems().stream().map(this::toItemResponse).toList();

        return OrderResponse.builder()
                .id(order.getId())
                .tableNumber(order.getTableNumber())
                .status(order.getStatus())
                .createdAt(order.getCreatedAt().toInstant())
                .items(items)
                .build();
    }

    private OrderItemResponse toItemResponse(OrderItem item) {
        return OrderItemResponse.builder()
                .orderItemId(item.getId())
                .menuItemId(item.getMenuItem().getId())
                .name(item.getMenuItem().getName())
                .quantity(item.getQuantity())
                .note(item.getNote())
                .unitPrice(item.getMenuItem().getPrice().toPlainString())
                .build();
    }
}
