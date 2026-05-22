package fr.dragontap.innkeeper.order.usecase;

import fr.dragontap.innkeeper.order.dto.OrderResponse;
import fr.dragontap.innkeeper.order.dto.UpdateOrderStatusRequest;
import fr.dragontap.innkeeper.order.entity.OrderStatus;
import fr.dragontap.innkeeper.order.mapper.OrderMapper;
import fr.dragontap.innkeeper.order.repository.OrderRepository;
import fr.dragontap.innkeeper.shared.exception.InvalidStatusTransitionException;
import fr.dragontap.innkeeper.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UpdateOrderStatusUseCase {

    private final OrderRepository orderRepository;
    private final OrderMapper orderMapper;

    @Transactional
    public OrderResponse execute(int id, UpdateOrderStatusRequest request) {
        var order = orderRepository.findByIdWithItems(id)
                .orElseThrow(ResourceNotFoundException::new);

        OrderStatus currentStatus = order.getStatus();
        OrderStatus requestedStatus = request.status();

        if (!currentStatus.canTransitionTo(requestedStatus)) {
            throw new InvalidStatusTransitionException(
                    currentStatus,
                    requestedStatus,
                    currentStatus.allowedTransitions()
            );
        }

        order.updateStatus(requestedStatus);
        orderRepository.save(order);

        return orderRepository.findByIdWithItems(order.getId())
                .map(orderMapper::toResponse)
                .orElseThrow();
    }
}
