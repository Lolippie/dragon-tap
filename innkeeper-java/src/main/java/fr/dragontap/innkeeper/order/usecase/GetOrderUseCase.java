package fr.dragontap.innkeeper.order.usecase;

import fr.dragontap.innkeeper.order.dto.OrderResponse;
import fr.dragontap.innkeeper.order.mapper.OrderMapper;
import fr.dragontap.innkeeper.order.repository.OrderRepository;
import fr.dragontap.innkeeper.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class GetOrderUseCase {

    private final OrderRepository orderRepository;
    private final OrderMapper orderMapper;

    @Transactional(readOnly = true)
    public OrderResponse execute(int id) {
        return orderRepository.findByIdWithItems(id)
                .map(orderMapper::toResponse)
                .orElseThrow(ResourceNotFoundException::new);
    }
}
