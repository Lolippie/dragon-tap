package fr.dragontap.innkeeper.order.entity;

import fr.dragontap.innkeeper.order.OrderStatusConverter;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "orders")
@Getter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "table_number", nullable = false)
    private Integer tableNumber;

    @Convert(converter = OrderStatusConverter.class)
    @Column(name = "status", nullable = false, length = 20)
    private OrderStatus status;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @OneToMany(mappedBy = "order", cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    @OrderBy("id ASC")
    private List<OrderItem> items;

    public void updateStatus(OrderStatus newStatus) {
        this.status = newStatus;
    }
}
