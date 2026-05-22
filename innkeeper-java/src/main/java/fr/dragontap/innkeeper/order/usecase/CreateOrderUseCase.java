package fr.dragontap.innkeeper.order.usecase;

import fr.dragontap.innkeeper.menu.entity.MenuItem;
import fr.dragontap.innkeeper.menu.repository.MenuRepository;
import fr.dragontap.innkeeper.order.dto.CreateOrderRequest;
import fr.dragontap.innkeeper.order.dto.OrderResponse;
import fr.dragontap.innkeeper.order.entity.Order;
import fr.dragontap.innkeeper.order.entity.OrderItem;
import fr.dragontap.innkeeper.order.entity.OrderStatus;
import fr.dragontap.innkeeper.order.mapper.OrderMapper;
import fr.dragontap.innkeeper.order.repository.OrderRepository;
import fr.dragontap.innkeeper.shared.exception.ValidationException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CreateOrderUseCase {

    private final OrderRepository orderRepository;
    private final MenuRepository menuRepository;
    private final OrderMapper orderMapper;

    @Transactional
    public OrderResponse execute(CreateOrderRequest request) {
        // Verify all menu_item_ids exist
        Set<Integer> requestedIds = request.items().stream()
                .map(CreateOrderRequest.OrderItemRequest::menuItemId)
                .collect(Collectors.toSet());

        List<MenuItem> foundItems = menuRepository.findAllById(requestedIds);
        Map<Integer, MenuItem> menuItemById = foundItems.stream()
                .collect(Collectors.toMap(MenuItem::getId, m -> m));

        List<Integer> missingIds = requestedIds.stream()
                .filter(id -> !menuItemById.containsKey(id))
                .sorted()
                .toList();

        if (!missingIds.isEmpty()) {
            List<ValidationException.FieldError> details = missingIds.stream()
                    .map(id -> new ValidationException.FieldError("menu_item_id", "item " + id + " not found"))
                    .toList();
            throw new ValidationException(details);
        }

        // Build order items
        List<OrderItem> orderItems = new ArrayList<>();
        Order order = Order.builder()
                .tableNumber(request.tableNumber())
                .status(OrderStatus.PENDING)
                .items(orderItems)
                .build();

        for (CreateOrderRequest.OrderItemRequest itemReq : request.items()) {
            OrderItem orderItem = OrderItem.builder()
                    .order(order)
                    .menuItem(menuItemById.get(itemReq.menuItemId()))
                    .quantity(itemReq.quantity())
                    .note(itemReq.note())
                    .build();
            orderItems.add(orderItem);
        }

        Order saved = orderRepository.save(order);

        // Reload with join fetch to return full response
        return orderRepository.findByIdWithItems(saved.getId())
                .map(orderMapper::toResponse)
                .orElseThrow();
    }
}
