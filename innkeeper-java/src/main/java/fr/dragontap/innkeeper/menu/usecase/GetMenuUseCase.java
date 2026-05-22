package fr.dragontap.innkeeper.menu.usecase;

import fr.dragontap.innkeeper.menu.dto.MenuItemResponse;
import fr.dragontap.innkeeper.menu.mapper.MenuMapper;
import fr.dragontap.innkeeper.menu.repository.MenuRepository;
import fr.dragontap.innkeeper.shared.exception.ValidationException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class GetMenuUseCase {

    private static final Set<String> VALID_CATEGORIES = Set.of(
            "potions", "breuvages", "infusions_froides", "soupes_bouillons",
            "victuailles", "pains_viennoiseries", "fromages_affines", "desserts_douceurs"
    );

    private final MenuRepository menuRepository;
    private final MenuMapper menuMapper;

    @Transactional(readOnly = true)
    public List<MenuItemResponse> execute(String category) {
        if (category != null && !VALID_CATEGORIES.contains(category)) {
            throw new ValidationException("category",
                    "must be one of: " + String.join(", ", VALID_CATEGORIES.stream().sorted().toList()));
        }

        var sort = Sort.by("id");

        if (category != null) {
            return menuRepository.findByCategory(category, sort).stream()
                    .map(menuMapper::toResponse)
                    .toList();
        }

        return menuRepository.findAll(sort).stream()
                .map(menuMapper::toResponse)
                .toList();
    }
}
