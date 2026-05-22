package fr.dragontap.innkeeper.order.usecase;

import fr.dragontap.innkeeper.order.dto.OrderResponse;
import fr.dragontap.innkeeper.order.entity.OrderStatus;
import fr.dragontap.innkeeper.order.mapper.OrderMapper;
import fr.dragontap.innkeeper.order.repository.OrderRepository;
import fr.dragontap.innkeeper.shared.exception.ValidationException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class GetOrdersUseCase {

    private final OrderRepository orderRepository;
    private final OrderMapper orderMapper;

    @Transactional(readOnly = true)
    public List<OrderResponse> execute(String statusParam) {
        if (statusParam == null) {
            return orderRepository.findAllWithItems().stream()
                    .map(orderMapper::toResponse)
                    .toList();
        }

        OrderStatus status;
        try {
            status = OrderStatus.fromJson(statusParam);
        } catch (IllegalArgumentException e) {
            String valid = Arrays.stream(OrderStatus.values())
                    .map(OrderStatus::toJson)
                    .collect(Collectors.joining(", "));
            throw new ValidationException("status", "must be one of: " + valid);
        }

        return orderRepository.findByStatusWithItems(status).stream()
                .map(orderMapper::toResponse)
                .toList();
    }
}
