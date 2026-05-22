package fr.dragontap.innkeeper.order.dto;

import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import java.util.List;

public record CreateOrderRequest(

        @NotNull(message = "must be a positive integer")
        @Min(value = 1, message = "must be a positive integer")
        Integer tableNumber,

        @NotEmpty(message = "must contain at least one item")
        @Valid
        List<OrderItemRequest> items

) {
    public record OrderItemRequest(

            @NotNull(message = "must be a positive integer")
            @Min(value = 1, message = "must be a positive integer")
            Integer menuItemId,

            @NotNull(message = "must be a positive integer")
            @Min(value = 1, message = "must be a positive integer")
            Integer quantity,

            String note

    ) {}
}
