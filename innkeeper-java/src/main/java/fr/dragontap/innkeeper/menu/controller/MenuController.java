package fr.dragontap.innkeeper.menu.controller;

import fr.dragontap.innkeeper.menu.dto.MenuItemResponse;
import fr.dragontap.innkeeper.menu.usecase.GetMenuItemUseCase;
import fr.dragontap.innkeeper.menu.usecase.GetMenuUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/menu")
@RequiredArgsConstructor
public class MenuController {

    private final GetMenuUseCase getMenuUseCase;
    private final GetMenuItemUseCase getMenuItemUseCase;

    @GetMapping
    public ResponseEntity<List<MenuItemResponse>> getMenu(
            @RequestParam(required = false) String category) {
        return ResponseEntity.ok(getMenuUseCase.execute(category));
    }

    @GetMapping("/{id}")
    public ResponseEntity<MenuItemResponse> getMenuItem(@PathVariable int id) {
        return ResponseEntity.ok(getMenuItemUseCase.execute(id));
    }
}
