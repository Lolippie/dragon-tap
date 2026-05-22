package fr.dragontap.innkeeper.menu.mapper;

import fr.dragontap.innkeeper.menu.dto.MenuItemResponse;
import fr.dragontap.innkeeper.menu.entity.MenuItem;
import org.springframework.stereotype.Component;

@Component
public class MenuMapper {

    public MenuItemResponse toResponse(MenuItem item) {
        return MenuItemResponse.builder()
                .id(item.getId())
                .name(item.getName())
                .category(item.getCategory())
                .type(item.getType())
                .price(item.getPrice().toPlainString())
                .description(item.getDescription())
                .build();
    }
}
