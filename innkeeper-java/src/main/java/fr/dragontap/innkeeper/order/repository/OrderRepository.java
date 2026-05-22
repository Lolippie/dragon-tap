package fr.dragontap.innkeeper.order.repository;

import fr.dragontap.innkeeper.order.entity.Order;
import fr.dragontap.innkeeper.order.entity.OrderStatus;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface OrderRepository extends JpaRepository<Order, Integer> {

    @EntityGraph(attributePaths = {"items", "items.menuItem"})
    @Query("SELECT o FROM Order o ORDER BY o.id")
    List<Order> findAllWithItems();

    @EntityGraph(attributePaths = {"items", "items.menuItem"})
    @Query("SELECT o FROM Order o WHERE o.status = :status ORDER BY o.id")
    List<Order> findByStatusWithItems(@Param("status") OrderStatus status);

    @EntityGraph(attributePaths = {"items", "items.menuItem"})
    @Query("SELECT o FROM Order o WHERE o.id = :id")
    Optional<Order> findByIdWithItems(@Param("id") Integer id);
}
