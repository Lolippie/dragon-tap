package fr.dragontap.innkeeper.menu;

import fr.dragontap.innkeeper.menu.entity.MenuItem;
import fr.dragontap.innkeeper.menu.repository.MenuRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

import java.math.BigDecimal;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class MenuControllerTest {

    @Autowired
    private WebApplicationContext context;

    @Autowired
    private MenuRepository menuRepository;

    private MockMvc mockMvc;
    private MenuItem potion;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();

        menuRepository.deleteAll();

        potion = menuRepository.save(MenuItem.builder()
                .name("Potion de Clarté")
                .category("potions")
                .type("liquid")
                .price(new BigDecimal("12.50"))
                .description("Un liquide bleuté.")
                .build());

        menuRepository.save(MenuItem.builder()
                .name("Hydromel des Brumes")
                .category("breuvages")
                .type("liquid")
                .price(new BigDecimal("5.00"))
                .description("Doux et ambré.")
                .build());
    }

    @Test
    void getMenu_returnsAllItems() throws Exception {
        mockMvc.perform(get("/api/menu"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(2)));
    }

    @Test
    void getMenu_filterByCategory_returnsOnlyMatchingItems() throws Exception {
        mockMvc.perform(get("/api/menu").param("category", "potions"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$", hasSize(1)))
                .andExpect(jsonPath("$[0].category", is("potions")));
    }

    @Test
    void getMenu_invalidCategory_returns400() throws Exception {
        mockMvc.perform(get("/api/menu").param("category", "invalid_category"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error", is("Validation failed")))
                .andExpect(jsonPath("$.details[0].field", is("category")));
    }

    @Test
    void getMenuItem_existingId_returnsItem() throws Exception {
        mockMvc.perform(get("/api/menu/{id}", potion.getId()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id", is(potion.getId())))
                .andExpect(jsonPath("$.name", is("Potion de Clarté")))
                .andExpect(jsonPath("$.price", is("12.50")));
    }

    @Test
    void getMenuItem_nonExistingId_returns404() throws Exception {
        mockMvc.perform(get("/api/menu/9999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.error", is("Not found")));
    }
}
