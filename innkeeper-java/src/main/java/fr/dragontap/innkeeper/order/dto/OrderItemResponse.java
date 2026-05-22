package fr.dragontap.innkeeper.order.dto;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class OrderItemResponse {
    int orderItemId;
    int menuItemId;
    String name;
    int quantity;
    String note;
    String unitPrice;
}
