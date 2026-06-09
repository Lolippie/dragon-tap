package fr.dragontap.innkeeper.order.entity;

import java.time.OffsetDateTime;
import java.util.List;

import org.hibernate.annotations.CreationTimestamp;

import fr.dragontap.innkeeper.order.OrderStatusConverter;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderBy;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

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
