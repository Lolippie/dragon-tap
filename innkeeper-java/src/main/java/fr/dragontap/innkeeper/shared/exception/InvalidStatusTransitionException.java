package fr.dragontap.innkeeper.shared.exception;

import fr.dragontap.innkeeper.order.entity.OrderStatus;
import lombok.Getter;

import java.util.List;

@Getter
public class InvalidStatusTransitionException extends RuntimeException {

    private final OrderStatus current;
    private final OrderStatus requested;
    private final List<OrderStatus> allowed;

    public InvalidStatusTransitionException(OrderStatus current, OrderStatus requested, List<OrderStatus> allowed) {
        super("Invalid status transition from %s to %s".formatted(current, requested));
        this.current = current;
        this.requested = requested;
        this.allowed = allowed;
    }
}
