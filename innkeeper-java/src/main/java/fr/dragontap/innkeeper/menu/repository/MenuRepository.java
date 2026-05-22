package fr.dragontap.innkeeper.menu.repository;

import fr.dragontap.innkeeper.menu.entity.MenuItem;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface MenuRepository extends JpaRepository<MenuItem, Integer> {

    List<MenuItem> findByCategory(String category, Sort sort);
}
