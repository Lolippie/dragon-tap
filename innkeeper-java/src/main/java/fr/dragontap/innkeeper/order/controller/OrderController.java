package fr.dragontap.innkeeper.order.controller;

import fr.dragontap.innkeeper.order.dto.CreateOrderRequest;
import fr.dragontap.innkeeper.order.dto.OrderResponse;
import fr.dragontap.innkeeper.order.dto.UpdateOrderStatusRequest;
import fr.dragontap.innkeeper.order.usecase.CreateOrderUseCase;
import fr.dragontap.innkeeper.order.usecase.GetOrderUseCase;
import fr.dragontap.innkeeper.order.usecase.GetOrdersUseCase;
import fr.dragontap.innkeeper.order.usecase.UpdateOrderStatusUseCase;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final GetOrdersUseCase getOrdersUseCase;
    private final GetOrderUseCase getOrderUseCase;
    private final CreateOrderUseCase createOrderUseCase;
    private final UpdateOrderStatusUseCase updateOrderStatusUseCase;

    @GetMapping
    public ResponseEntity<List<OrderResponse>> getOrders(
            @RequestParam(required = false) String status) {
        return ResponseEntity.ok(getOrdersUseCase.execute(status));
    }

    @PostMapping
    public ResponseEntity<OrderResponse> createOrder(
            @Valid @RequestBody CreateOrderRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(createOrderUseCase.execute(request));
    }

    @GetMapping("/{id}")
    public ResponseEntity<OrderResponse> getOrder(@PathVariable int id) {
        return ResponseEntity.ok(getOrderUseCase.execute(id));
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<OrderResponse> updateStatus(
            @PathVariable int id,
            @Valid @RequestBody UpdateOrderStatusRequest request) {
        return ResponseEntity.ok(updateOrderStatusUseCase.execute(id, request));
    }
}
