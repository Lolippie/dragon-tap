package fr.dragontap.innkeeper.order;

import fr.dragontap.innkeeper.menu.entity.MenuItem;
import fr.dragontap.innkeeper.menu.repository.MenuRepository;
import fr.dragontap.innkeeper.order.entity.Order;
import fr.dragontap.innkeeper.order.entity.OrderItem;
import fr.dragontap.innkeeper.order.entity.OrderStatus;
import fr.dragontap.innkeeper.order.repository.OrderRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class OrderControllerTest {

    @Autowired
    private WebApplicationContext context;

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private MenuRepository menuRepository;

    private MockMvc mockMvc;
    private MenuItem menuItem;
    private Order pendingOrder;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();

        orderRepository.deleteAll();
        menuRepository.deleteAll();

        menuItem = menuRepository.save(MenuItem.builder()
                .name("Potion de Test")
                .category("potions")
                .type("liquid")
                .price(new BigDecimal("10.00"))
                .description("Pour les tests.")
                .build());

        List<OrderItem> items = new ArrayList<>();
        pendingOrder = Order.builder()
                .tableNumber(3)
                .status(OrderStatus.PENDING)
                .items(items)
                .build();
        OrderItem oi = OrderItem.builder()
                .order(pendingOrder)
                .menuItem(menuItem)
                .quantity(2)
                .note(null)
                .build();
        items.add(oi);
        pendingOrder = orderRepository.save(pendingOrder);
    }

    @Test
    void getOrders_returns200() throws Exception {
        mockMvc.perform(get("/api/orders"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(greaterThanOrEqualTo(1))));
    }

    @Test
    void getOrders_filterByStatus_returnsMatchingOrders() throws Exception {
        mockMvc.perform(get("/api/orders").param("status", "pending"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].status", is("pending")));
    }

    @Test
    void getOrders_invalidStatus_returns400() throws Exception {
        mockMvc.perform(get("/api/orders").param("status", "unknown"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error", is("Validation failed")));
    }

    @Test
    void getOrder_existingId_returns200() throws Exception {
        mockMvc.perform(get("/api/orders/{id}", pendingOrder.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id", is(pendingOrder.getId())))
                .andExpect(jsonPath("$.table_number", is(3)))
                .andExpect(jsonPath("$.status", is("pending")))
                .andExpect(jsonPath("$.items", hasSize(1)));
    }

    @Test
    void getOrder_nonExistingId_returns404() throws Exception {
        mockMvc.perform(get("/api/orders/9999"))
                .andExpect(status().isNotFound());
    }

    @Test
    void createOrder_validRequest_returns201() throws Exception {
        String body = """
                {
                  "table_number": 5,
                  "items": [
                    {"menu_item_id": %d, "quantity": 1}
                  ]
                }
                """.formatted(menuItem.getId());

        mockMvc.perform(post("/api/orders")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.status", is("pending")))
                .andExpect(jsonPath("$.table_number", is(5)))
                .andExpect(jsonPath("$.items", hasSize(1)));
    }

    @Test
    void createOrder_unknownMenuItemId_returns400() throws Exception {
        String body = """
                {
                  "table_number": 5,
                  "items": [
                    {"menu_item_id": 9999, "quantity": 1}
                  ]
                }
                """;

        mockMvc.perform(post("/api/orders")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error", is("Validation failed")));
    }

    @Test
    void updateStatus_validTransition_returns200() throws Exception {
        mockMvc.perform(patch("/api/orders/{id}/status", pendingOrder.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"status\": \"preparing\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status", is("preparing")));
    }

    @Test
    void updateStatus_invalidTransition_returns422() throws Exception {
        mockMvc.perform(patch("/api/orders/{id}/status", pendingOrder.getId())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"status\": \"served\"}"))
                .andExpect(status().isUnprocessableEntity())
                .andExpect(jsonPath("$.error", is("Invalid transition")))
                .andExpect(jsonPath("$.current", is("pending")))
                .andExpect(jsonPath("$.requested", is("served")));
    }
}
