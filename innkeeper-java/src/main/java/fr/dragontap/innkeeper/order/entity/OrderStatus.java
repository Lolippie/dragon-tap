package fr.dragontap.innkeeper.order.entity;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

import java.util.List;
import java.util.Map;

public enum OrderStatus {

    PENDING,
    PREPARING,
    SERVED,
    CANCELLED;

    // Transitions autorisées : terminal states have empty lists
    private static final Map<OrderStatus, List<OrderStatus>> TRANSITIONS = Map.of(
            PENDING,    List.of(PREPARING, CANCELLED),
            PREPARING,  List.of(SERVED),
            SERVED,     List.of(),
            CANCELLED,  List.of()
    );

    public List<OrderStatus> allowedTransitions() {
        return TRANSITIONS.getOrDefault(this, List.of());
    }

    public boolean canTransitionTo(OrderStatus target) {
        return allowedTransitions().contains(target);
    }

    @JsonValue
    public String toJson() {
        return name().toLowerCase();
    }

    @JsonCreator
    public static OrderStatus fromJson(String value) {
        return valueOf(value.toUpperCase());
    }
}
