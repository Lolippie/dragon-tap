package fr.dragontap.innkeeper.order.dto;

import fr.dragontap.innkeeper.order.entity.OrderStatus;
import jakarta.validation.constraints.NotNull;

public record UpdateOrderStatusRequest(

        @NotNull(message = "must not be null")
        OrderStatus status

) {}
