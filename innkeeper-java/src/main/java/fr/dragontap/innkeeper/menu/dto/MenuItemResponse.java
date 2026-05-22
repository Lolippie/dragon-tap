package fr.dragontap.innkeeper.menu.dto;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class MenuItemResponse {
    int id;
    String name;
    String category;
    String type;
    String price;
    String description;
}
