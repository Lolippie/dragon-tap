package fr.dragontap.innkeeper.menu.usecase;

import fr.dragontap.innkeeper.menu.dto.MenuItemResponse;
import fr.dragontap.innkeeper.menu.mapper.MenuMapper;
import fr.dragontap.innkeeper.menu.repository.MenuRepository;
import fr.dragontap.innkeeper.shared.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class GetMenuItemUseCase {

    private final MenuRepository menuRepository;
    private final MenuMapper menuMapper;

    @Transactional(readOnly = true)
    public MenuItemResponse execute(int id) {
        return menuRepository.findById(id)
                .map(menuMapper::toResponse)
                .orElseThrow(ResourceNotFoundException::new);
    }
}
