-- ============================================================
-- DragonTap — Cellar : Schéma + Seed Data
-- ============================================================

-- ── Schéma ───────────────────────────────────────────────────

CREATE TABLE menu_items (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(120) NOT NULL,
    category    VARCHAR(50)  NOT NULL,
    type        VARCHAR(10)  NOT NULL CHECK (type IN ('liquid', 'solid')),
    price       NUMERIC(6,2) NOT NULL,
    description TEXT         NOT NULL
);

CREATE TABLE orders (
    id           SERIAL PRIMARY KEY,
    table_number INTEGER      NOT NULL,
    status       VARCHAR(20)  NOT NULL DEFAULT 'pending'
                              CHECK (status IN ('pending', 'preparing', 'served', 'cancelled')),
    created_at   TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE order_items (
    id           SERIAL PRIMARY KEY,
    order_id     INTEGER      NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id INTEGER      NOT NULL REFERENCES menu_items(id),
    quantity     INTEGER      NOT NULL DEFAULT 1 CHECK (quantity > 0),
    note         TEXT
);

-- ── Menu items ────────────────────────────────────────────────
-- potions (80) · breuvages (70) · infusions_froides (38)
-- soupes_bouillons (50) · victuailles (60)
-- pains_viennoiseries (40) · fromages_affines (30)
-- desserts_douceurs (50)
-- Total : 418

-- ── potions (80 items, liquid, 6.00–18.00) ───────────────────

INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Clarté Mentale', 'potions', 'liquid', 12.50, 'Un liquide bleuté qui aiguise l''esprit pour la nuit.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Force du Guerrier', 'potions', 'liquid', 14.00, 'Renforce les muscles du buveur pendant plusieurs heures.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Vision Nocturne', 'potions', 'liquid', 10.50, 'Permet de voir dans les ténèbres les plus épaisses.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Courage Ardent', 'potions', 'liquid', 9.00, 'Insuffle une bravoure inébranlable face aux plus sombres périls.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Soin des Blessures', 'potions', 'liquid', 15.00, 'Referme les plaies fraîches en quelques instants.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Rapidité des Vents', 'potions', 'liquid', 13.50, 'Accélère les pas du buveur comme une brise légère.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Résistance au Feu', 'potions', 'liquid', 16.00, 'Protège la peau contre les flammes et les brûlures.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Souffle du Dragon', 'potions', 'liquid', 18.00, 'Confère temporairement le souffle enflammé d''un dragon.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Mémoire Ancienne', 'potions', 'liquid', 11.00, 'Ravive les souvenirs oubliés avec une précision absolue.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Silence des Ombres', 'potions', 'liquid', 12.00, 'Efface les bruits de pas et les sons du buveur.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Lumière Dorée', 'potions', 'liquid', 9.50, 'Émet une lueur chaude et apaisante dans les endroits sombres.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Force des Pierres', 'potions', 'liquid', 14.50, 'Durcit la peau comme un roc invulnérable.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Grâce Féline', 'potions', 'liquid', 10.00, 'Offre l''agilité et l''équilibre parfait d''un grand félin.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Vitalité Renouvelée', 'potions', 'liquid', 13.00, 'Restaure l''énergie et la santé après un long voyage.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Protection des Runes', 'potions', 'liquid', 16.50, 'Tisse un voile magique autour du buveur.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Chance du Trèfle', 'potions', 'liquid', 8.00, 'Attire la fortune et détourne les mauvaises augures.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Sagesse des Anciens', 'potions', 'liquid', 17.00, 'Ouvre l''esprit aux connaissances des âges révolus.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Régénération Lente', 'potions', 'liquid', 15.50, 'Accélère doucement la guérison naturelle du corps.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Tromperie des Sens', 'potions', 'liquid', 11.50, 'Trouble la perception des ennemis proches.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Sang du Phénix', 'potions', 'liquid', 18.00, 'Ressuscite les forces vitales à leur maximum absolu.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Brume Mystique', 'potions', 'liquid', 9.00, 'Enveloppe le buveur d''un voile de brume légère.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Racines Profondes', 'potions', 'liquid', 7.50, 'Stabilise le corps et l''ancre comme un vieux chêne.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Voix des Fantômes', 'potions', 'liquid', 12.50, 'Permet de comprendre les murmures des esprits errants.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Contemplation Zen', 'potions', 'liquid', 8.50, 'Apaise l''esprit et dissipe les pensées parasites.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Froid Glacial', 'potions', 'liquid', 10.00, 'Confère une résistance au grand froid des contrées nordiques.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Chaleur Volcanique', 'potions', 'liquid', 11.00, 'Réchauffe le corps au plus profond de la nuit hivernale.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Lame Affûtée', 'potions', 'liquid', 14.00, 'Améliore la précision et la rapidité au combat.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Marche Silencieuse', 'potions', 'liquid', 9.50, 'Rend les pas inaudibles sur tous les types de terrain.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Communion Animale', 'potions', 'liquid', 13.50, 'Permet de comprendre et de parler aux animaux sauvages.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Regard Perçant', 'potions', 'liquid', 12.00, 'Accentue la vue pour détecter le moindre mouvement.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Sommeil Réparateur', 'potions', 'liquid', 7.00, 'Plonge dans un sommeil profond et revitalisant.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Bouclier Runique', 'potions', 'liquid', 16.00, 'Crée un bouclier invisible gravé de runes protectrices.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Sève Vivifiante', 'potions', 'liquid', 10.50, 'Puisée dans les arbres anciens, elle revigore le corps.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Résistance au Poison', 'potions', 'liquid', 15.00, 'Neutralise les venins et poisons ingérés récemment.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Plongée des Abysses', 'potions', 'liquid', 14.50, 'Permet de respirer sous l''eau pendant une heure.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Sérénité Absolue', 'potions', 'liquid', 8.00, 'Efface toute anxiété et apaise les esprits tourmentés.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Tempête Électrique', 'potions', 'liquid', 17.50, 'Charge le corps d''une énergie fulgurante et crépitante.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Métamorphose Subtile', 'potions', 'liquid', 16.00, 'Modifie légèrement les traits du buveur pendant quelques heures.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Réflexes du Lynx', 'potions', 'liquid', 11.50, 'Rend les réflexes aussi vifs que ceux d''un lynx des neiges.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Cœur de Pierre', 'potions', 'liquid', 13.00, 'Durcit la volonté et immunise contre la peur.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Lune Argentée', 'potions', 'liquid', 9.00, 'Confère des aptitudes particulières les nuits de pleine lune.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Flamme Purifiante', 'potions', 'liquid', 12.50, 'Brûle les impuretés et les maladies du corps.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Rivière des Esprits', 'potions', 'liquid', 10.00, 'Permet d''entrevoir les plans éthérés et spirituels.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Guérison des Maux', 'potions', 'liquid', 14.00, 'Soigne les maladies courantes et les infections bénignes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Danse des Feuilles', 'potions', 'liquid', 7.50, 'Procure une légèreté surnaturelle et une grande souplesse.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Volonté de Fer', 'potions', 'liquid', 15.50, 'Renforce la résistance mentale contre les charmes et sortilèges.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Brume des Marais', 'potions', 'liquid', 8.50, 'Trouble les sens de ceux qui traquent le buveur.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Regard du Faucon', 'potions', 'liquid', 11.00, 'Permet de voir avec la précision d''un faucon en vol.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Protection Céleste', 'potions', 'liquid', 16.50, 'Attire la bienveillance des astres et des divinités.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Nuit Étoilée', 'potions', 'liquid', 9.50, 'Rend le buveur invisible dans l''obscurité totale.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Racine de Mandragore', 'potions', 'liquid', 13.50, 'Décuple les sens pendant une courte mais intense période.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Vent du Nord', 'potions', 'liquid', 10.50, 'Résiste aux températures extrêmes du Grand Hiver du Nord.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Purification Sacrée', 'potions', 'liquid', 15.00, 'Chasse les entités maléfiques qui hantent le buveur.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Morsure du Basilic', 'potions', 'liquid', 17.00, 'Confère une résistance à la pétrification et aux regards mortels.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Cendres du Phénix', 'potions', 'liquid', 18.00, 'Une dernière chance offerte par les flammes de renaissance.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Repos Éternel', 'potions', 'liquid', 7.00, 'Favorise un sommeil sans rêve de très longue durée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Peau de Granite', 'potions', 'liquid', 14.50, 'Rend la peau aussi dure que la roche de montagne.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Pas du Spectre', 'potions', 'liquid', 11.50, 'Permet de traverser les objets solides pendant quelques instants.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Charme Enchanté', 'potions', 'liquid', 12.00, 'Rend le buveur irrésistiblement sympathique et charismatique.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Murmure des Forêts', 'potions', 'liquid', 8.00, 'Permet d''entendre les secrets que murmurent les arbres.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Fièvre Solaire', 'potions', 'liquid', 10.00, 'Canalise l''énergie du soleil au cœur du buveur.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Résistance au Gel', 'potions', 'liquid', 13.00, 'Protège contre les engelures et le froid mortel.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Source Crystalline', 'potions', 'liquid', 9.00, 'Purifie l''organisme et détoxifie le sang en profondeur.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Fureur des Tempêtes', 'potions', 'liquid', 16.00, 'Déchaîne une rage combative puissante et incontrôlable.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Gardien des Portes', 'potions', 'liquid', 14.00, 'Permet de percevoir les entités franchissant les seuils magiques.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Tendresse Elfique', 'potions', 'liquid', 7.50, 'Apaise les blessures émotionnelles et réconforte l''âme.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Minerai Stellaire', 'potions', 'liquid', 17.50, 'Tire sa force des étoiles pour renforcer le corps.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Récupération Rapide', 'potions', 'liquid', 12.50, 'Restaure rapidement l''endurance après un effort intense.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Voile des Songes', 'potions', 'liquid', 9.50, 'Permet de contrôler ses rêves et d''y chercher des réponses.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Lien des Jumeaux', 'potions', 'liquid', 11.00, 'Crée un lien télépathique temporaire entre deux buveurs.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Montagne Sacrée', 'potions', 'liquid', 15.00, 'Donne la force et l''endurance des habitants des sommets.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Vague Déferlante', 'potions', 'liquid', 13.50, 'Insuffle une puissance brutale comme une vague déchaînée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Dague de Cristal', 'potions', 'liquid', 16.50, 'Affûte les sens au point de voir les auras des créatures.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Souffle Polaire', 'potions', 'liquid', 10.50, 'Permet de souffler un vent glacial paralysant.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Cœur du Léviathan', 'potions', 'liquid', 18.00, 'Confère la force monstrueuse de la créature des abysses.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Élixir de Sève des Dryades', 'potions', 'liquid', 8.50, 'Connecte le buveur à l''âme vivante de la forêt.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Décoction de Larmes du Dragon', 'potions', 'liquid', 17.00, 'Extraite de précieuses larmes, elle guérit les blessures profondes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Flamme de Salamandre', 'potions', 'liquid', 14.00, 'Immunise contre les brûlures et la chaleur extrême.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Philtre de Paix des Plaines', 'potions', 'liquid', 6.50, 'Calme les tensions et résout les conflits pacifiquement.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Potion de Lumière des Abysses', 'potions', 'liquid', 16.00, 'Éclaire les endroits où même les torches refusent de brûler.');

-- ── breuvages (70 items, liquid, 2.00–6.00) ──────────────────

INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Miel Sauvage', 'breuvages', 'liquid', 3.50, 'Doux nectar doré récolté dans les ruches des forêts profondes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar des Forêts du Nord', 'breuvages', 'liquid', 4.00, 'Subtil mélange de baies et de plantes des contrées boréales.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Baies de Givre', 'breuvages', 'liquid', 2.50, 'Pressé de baies cueillies sur les buissons givrés du Nord.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage aux Fleurs de Lune', 'breuvages', 'liquid', 3.00, 'Légère boisson parfumée, cueillie à la lueur lunaire.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar d''Ambre Doré', 'breuvages', 'liquid', 5.00, 'Dense et sucré, il coule comme de l''or liquide.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Racines Amères', 'breuvages', 'liquid', 2.00, 'Tonique fortifiant aux saveurs terreuses et vivifiantes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Pomme des Collines', 'breuvages', 'liquid', 3.50, 'Pressé de pommes gorgées de soleil des vergers anciens.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Rose des Sables', 'breuvages', 'liquid', 4.50, 'Pétales de roses des déserts infusées avec délicatesse.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Bourgeon de Saule', 'breuvages', 'liquid', 2.50, 'Léger et végétal, il apaise le corps et l''esprit.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Grenade Enchantée', 'breuvages', 'liquid', 5.50, 'Rubis en bouteille, doux et légèrement acidulé.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Cerise des Neiges', 'breuvages', 'liquid', 3.00, 'Saveur douce-amère des cerises poussant sous les sommets.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Thym des Garrigues', 'breuvages', 'liquid', 2.00, 'Aromatique et revitalisant, senteur des plaines ensoleillées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Figue de Roc', 'breuvages', 'liquid', 4.00, 'Épais et sucré, extrait des figues des parois rocheuses.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Pêche de Lumière', 'breuvages', 'liquid', 3.50, 'Doux et floral, parfum d''une pêche mûrie en plein soleil.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Pin Sylvestre', 'breuvages', 'liquid', 2.50, 'Résine et fraîcheur des vastes forêts de conifères.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Poire des Elfes', 'breuvages', 'liquid', 3.00, 'Poire rare cultivée par les artisans des clairières elfiques.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Lavande Bleue', 'breuvages', 'liquid', 4.50, 'Floral et apaisant, couleur du ciel des soirs d''été.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Genièvre Arctique', 'breuvages', 'liquid', 5.00, 'Baies sauvages des toundras du Grand Nord lointain.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Myrtille des Landes', 'breuvages', 'liquid', 2.50, 'Profond et fruité, cueilli dans les landes brumeuses.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Citron de Soleil', 'breuvages', 'liquid', 3.50, 'Acidulé et vif, il réveille les sens endormis.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Camomille Dorée', 'breuvages', 'liquid', 2.00, 'Doux et fleuri, tisane apaisante des prés d''or.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Raisin des Coteaux', 'breuvages', 'liquid', 4.00, 'Sucré et juteux, extrait des vignes des collines ensoleillées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Framboise des Bois', 'breuvages', 'liquid', 3.00, 'Acidulé et fruité, cueilli dans les sous-bois denses.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Menthe Glaciale', 'breuvages', 'liquid', 2.50, 'Fraîcheur intense qui revigore immédiatement les sens.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Coing des Cavernes', 'breuvages', 'liquid', 4.50, 'Épais et parfumé, il emplit la gorge de chaleur.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Sureau Mystique', 'breuvages', 'liquid', 5.00, 'Baies sacrées aux vertus protectrices et légèrement sucrées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Verveine des Prés', 'breuvages', 'liquid', 2.00, 'Délicat et herbacé, il détend après une longue journée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Mangue des Terres Chaudes', 'breuvages', 'liquid', 5.50, 'Exotique et soyeux, il rappelle les contrées tropicales.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Mûre Sauvage', 'breuvages', 'liquid', 3.50, 'Intense et légèrement amer, cueillie dans les haies sauvages.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Sauge des Ruines', 'breuvages', 'liquid', 2.50, 'Aromatique et purifiant, récolté dans les ruines antiques.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Prunelle des Hauts Pâturages', 'breuvages', 'liquid', 3.00, 'Acidulé et astringent, il fortifie la gorge.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Clémentine des Grottes', 'breuvages', 'liquid', 4.00, 'Doux agrume poussant dans les grottes lumineuses du Sud.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Romarin des Collines', 'breuvages', 'liquid', 2.00, 'Aromatique et stimulant, il éveille l''esprit engourdi.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Litchi des Tropiques Perdus', 'breuvages', 'liquid', 5.00, 'Nacré et parfumé, doux comme un pétale de fleur.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Papaye Enchantée', 'breuvages', 'liquid', 4.50, 'Moelleux et tropical, saveur des contrées lointaines.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Basilic Sacré', 'breuvages', 'liquid', 2.50, 'Herbacé et légèrement poivré, utilisé dans les rituels anciens.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Kiwi des Jardins Suspendus', 'breuvages', 'liquid', 4.00, 'Vert et acidulé, issu des jardins cultivés dans les airs.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Goyave des Forêts Denses', 'breuvages', 'liquid', 5.50, 'Parfumé et sucré, perle des jungles tropicales.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Coriandre des Marches', 'breuvages', 'liquid', 2.00, 'Herbacé et frais, typique des marchés des carrefours.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Fruit du Dragon Doré', 'breuvages', 'liquid', 6.00, 'Charnu et légèrement sucré, issu de la plante du dragon.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Carambole des Îles', 'breuvages', 'liquid', 5.00, 'Acide et juteux, en forme d''étoile brillante.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Jasmin des Nuits', 'breuvages', 'liquid', 3.00, 'Floral et entêtant, il parfume l''haleine pour la soirée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Papaye des Vallées', 'breuvages', 'liquid', 4.50, 'Fondant et sucré, mûri dans les vallées protégées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Nectarine des Plaines', 'breuvages', 'liquid', 3.50, 'Juteux et parfumé, chair fondante des vergers des plaines.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Fleurs de Pommier', 'breuvages', 'liquid', 2.50, 'Délicat et printanier, essence des vergers en fleurs.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Cassis des Marais', 'breuvages', 'liquid', 3.00, 'Intense et légèrement amer, baie des zones humides.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Groseille des Hauts Lieux', 'breuvages', 'liquid', 4.00, 'Acidulé et vif, cueilli sur les hauteurs venteuses.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Pétales de Rose', 'breuvages', 'liquid', 3.50, 'Romantique et floral, distillé de roses fraîchement cueillies.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Citrus des Cimes', 'breuvages', 'liquid', 4.50, 'Agrume rare poussant aux sommets des montagnes inaccessibles.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Mangue Stellaire', 'breuvages', 'liquid', 5.50, 'Variété rare brillant sous les étoiles des nuits chaudes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Noix de Muscade', 'breuvages', 'liquid', 2.00, 'Épicé et chaleureux, il réchauffe le ventre en hiver.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Prune des Vallées Boisées', 'breuvages', 'liquid', 3.00, 'Violet et fondant, prune mûrie dans les forêts ombragées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Pastèque des Déserts', 'breuvages', 'liquid', 4.00, 'Rafraîchissant et aqueux, oasis sucrée dans le sable.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Cannelle des Épices', 'breuvages', 'liquid', 2.50, 'Épicé et doux, il rappelle les marchés des épiciers.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Banane des Terres Tropicales', 'breuvages', 'liquid', 3.50, 'Onctueux et sucré, charnu fruit des terres chaudes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Datte des Oasis', 'breuvages', 'liquid', 5.00, 'Dense et caramélisé, trésor sucré des déserts dorés.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Cardamome Mystique', 'breuvages', 'liquid', 3.00, 'Épicé et parfumé, aux vertus digestives reconnues.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Figue de Barbarie', 'breuvages', 'liquid', 4.00, 'Doux et légèrement sucré, extrait du cactus du désert.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Melon des Contrées Chaudes', 'breuvages', 'liquid', 4.50, 'Fondant et sucré, soleil en bouteille des régions arides.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Gingembre des Épices', 'breuvages', 'liquid', 2.50, 'Piquant et réchauffant, tonique puissant contre le froid.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Noix de Coco des Rivages', 'breuvages', 'liquid', 5.00, 'Laiteux et doux, extrait des palmiers des plages.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Tamarin des Jungles', 'breuvages', 'liquid', 5.50, 'Acidulé et complexe, trésor des forêts tropicales denses.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Réglisse des Cavernes', 'breuvages', 'liquid', 2.00, 'Doux et anisé, récolté dans les racines souterraines.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus d''Ananas des Terres Vierges', 'breuvages', 'liquid', 4.00, 'Acide et sucré, soleil tropical concentré en bouteille.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Bergamote des Coteaux', 'breuvages', 'liquid', 4.50, 'Délicat agrume aux notes florales et légèrement amères.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage de Vanille des Archipels', 'breuvages', 'liquid', 3.50, 'Doux et crémeux, saveur des îles lointaines enchantées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Physalis des Plaines Dorées', 'breuvages', 'liquid', 3.00, 'Acidulé et fruité, petite baie dorée des prairies.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nectar de Maracuja des Brumes', 'breuvages', 'liquid', 5.50, 'Intense et acidulé, fruit des régions brumeuses tropicales.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Breuvage d''Hibiscus des Savanes', 'breuvages', 'liquid', 2.50, 'Rouge et acidulé, fleur séchée des grandes savanes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jus de Pomelo des Terres Lointaines', 'breuvages', 'liquid', 4.00, 'Amer et rafraîchissant, agrume des contrées éloignées.');

-- ── infusions_froides (38 items, liquid, 0.50–3.00) ──────────

INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Menthe Sauvage', 'infusions_froides', 'liquid', 1.50, 'Fraîcheur intense d''une menthe cueillie en bord de ruisseau.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Tilleul des Clairières', 'infusions_froides', 'liquid', 1.00, 'Douce et florale, servie fraîche après longue macération.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Verveine Dorée', 'infusions_froides', 'liquid', 1.50, 'Légère et citronnée, parfait rafraîchissement des soirs chauds.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Fleurs de Sureau', 'infusions_froides', 'liquid', 1.00, 'Délicate et légèrement florale, aux vertus apaisantes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Camomille des Prés', 'infusions_froides', 'liquid', 0.75, 'Douce et apaisante, idéale pour calmer les tensions.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Romarin Sauvage', 'infusions_froides', 'liquid', 1.25, 'Aromatique et légèrement résineuse, cueillie en garrigue.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Rose des Hautes Terres', 'infusions_froides', 'liquid', 1.50, 'Eau parfumée aux pétales de rose des sommets.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Lavande Montagnarde', 'infusions_froides', 'liquid', 2.00, 'Florale et apaisante, arôme des champs de lavande.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Concombre des Jardins', 'infusions_froides', 'liquid', 0.75, 'Fraîche et légère, parfaite pour étancher la soif.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Basilic Citronné', 'infusions_froides', 'liquid', 1.25, 'Herbacée et fraîche, alliance parfaite du vert et d''acidulé.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Gingembre Frais', 'infusions_froides', 'liquid', 1.50, 'Piquante et revitalisante, éveille les sens immédiatement.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Thé Vert des Cimes', 'infusions_froides', 'liquid', 1.75, 'Légère et végétale, aux douces notes des hauteurs.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Citron et Menthe', 'infusions_froides', 'liquid', 1.00, 'Simple et rafraîchissante, duo classique des auberges.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Fleurs d''Oranger', 'infusions_froides', 'liquid', 2.00, 'Florale et douce, parfum des vergers du Sud.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Fraise des Bois', 'infusions_froides', 'liquid', 1.50, 'Légèrement fruitée, arôme subtil des petites fraises sauvages.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Pêche Blanche', 'infusions_froides', 'liquid', 1.75, 'Douce et sucrée, parfum d''une pêche gorgée de soleil.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Pastèque Fraîche', 'infusions_froides', 'liquid', 0.75, 'Ultra-désaltérante, extrait aqueux du fruit d''été.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Hibiscus Rouge', 'infusions_froides', 'liquid', 1.50, 'Acidulée et colorée, saveur intense des fleurs séchées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Cactus des Déserts Arides', 'infusions_froides', 'liquid', 1.25, 'Pure et légèrement minérale, fraîcheur du désert.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Rooibos des Savanes', 'infusions_froides', 'liquid', 2.00, 'Douce et rougeoyante, sans amertume, longue macération.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Pamplemousse et Thym', 'infusions_froides', 'liquid', 1.50, 'Légèrement amère et herbacée, alliance audacieuse.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Maté des Plaines', 'infusions_froides', 'liquid', 2.50, 'Énergisante et herbacée, boisson des guerriers des plaines.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Myrtille et Citron', 'infusions_froides', 'liquid', 1.25, 'Acidulée et fruitée, mariage des forêts et des agrumes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Chrysanthème', 'infusions_froides', 'liquid', 1.75, 'Florale et délicate, macération de fleurs orientales.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Melon et Basilic', 'infusions_froides', 'liquid', 1.00, 'Alliance surprenante du doux et de l''herbacé.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Pissenlit des Champs', 'infusions_froides', 'liquid', 0.75, 'Légèrement amère et purifiante, récolte printanière.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Poire et Cardamome', 'infusions_froides', 'liquid', 2.00, 'Douce et épicée, mariage subtil du fruit et de l''aromate.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide d''Ortie des Lisières', 'infusions_froides', 'liquid', 1.50, 'Minérale et purifiante, récoltée aux lisières des forêts.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Grenade et Rose', 'infusions_froides', 'liquid', 2.50, 'Acidulée et florale, alliance luxueuse des jardins orientaux.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Mélisse des Ruisseaux', 'infusions_froides', 'liquid', 1.25, 'Citronnée et apaisante, cueillie au bord des eaux.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Cerise et Cannelle', 'infusions_froides', 'liquid', 1.75, 'Douce et épicée, mariage hivernal servi froid.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Sauge Pourpre', 'infusions_froides', 'liquid', 1.50, 'Légèrement amère et aromatique, feuilles violettes séchées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau d''Aloe Vera des Terres Chaudes', 'infusions_froides', 'liquid', 2.00, 'Légère et purifiante, gel d''aloès dilué en eau fraîche.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Ronces des Haies', 'infusions_froides', 'liquid', 1.00, 'Légèrement tannique, feuilles sauvages des haies buissonnantes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Framboises et Menthe', 'infusions_froides', 'liquid', 1.50, 'Fruitée et fraîche, combo estival des plus apprécié.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Calendula des Prés', 'infusions_froides', 'liquid', 0.75, 'Florale et douce, pétales d''or macérés longuement.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Eau de Pomme et Gingembre', 'infusions_froides', 'liquid', 1.75, 'Douce et piquante, mariage réconfortant des saisons froides.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Infusion Froide de Bourrache des Champs', 'infusions_froides', 'liquid', 1.25, 'Légèrement iodée et florale, petites fleurs étoilées bleues.');

-- ── soupes_bouillons (50 items, liquid, 2.00–6.00) ───────────

INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Champignons des Cavernes', 'soupes_bouillons', 'liquid', 4.00, 'Champignons rares des grottes, riche et terreuse en bouche.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Racines Sauvages', 'soupes_bouillons', 'liquid', 3.00, 'Mijotée avec des racines des sous-bois, saveur profonde.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Poireaux des Marais', 'soupes_bouillons', 'liquid', 3.50, 'Veloutée et douce, poireaux fondants des zones humides.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon d''Os de Dragon Fumé', 'soupes_bouillons', 'liquid', 5.50, 'Puissant et fumé, bouilli longuement pour l''essentiel.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Chou des Hauts Plateaux', 'soupes_bouillons', 'liquid', 3.00, 'Simple et nourrissante, chou vert des terres froides.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Herbes des Ruines', 'soupes_bouillons', 'liquid', 2.50, 'Parfumé aux herbes sauvages poussant dans les ruines.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Courge des Clairières', 'soupes_bouillons', 'liquid', 4.00, 'Onctueuse et sucrée, courge dorée des lisières forestières.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Morilles Enchantées', 'soupes_bouillons', 'liquid', 5.00, 'Rare et parfumé, morilles des forêts mystérieuses.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Lentilles des Collines', 'soupes_bouillons', 'liquid', 3.50, 'Épaisse et réconfortante, lentilles mijotées au thym.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Gingembre et Curcuma', 'soupes_bouillons', 'liquid', 2.50, 'Chaud et épicé, vivifiant lors des froides journées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Truffe des Bois Profonds', 'soupes_bouillons', 'liquid', 6.00, 'Luxueuse et intense, truffe noire des forêts obscures.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Céleri des Prairies', 'soupes_bouillons', 'liquid', 2.00, 'Léger et aromatique, idéal en début de repas.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe d''Épinards Sauvages', 'soupes_bouillons', 'liquid', 3.00, 'Verte et nutritive, épinards sauvages des sous-bois.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Châtaigne des Forêts', 'soupes_bouillons', 'liquid', 3.50, 'Doux et légèrement sucré, châtaignes d''automne mijoté.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Potiron des Champs', 'soupes_bouillons', 'liquid', 3.50, 'Veloutée et dorée, saveur chaude des récoltes d''automne.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon d''Ail des Ours', 'soupes_bouillons', 'liquid', 2.50, 'Parfumé et tonique, ail sauvage des lisières printanières.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Navet des Terres Froides', 'soupes_bouillons', 'liquid', 2.50, 'Rustique et nourrissante, racine des contrées nordiques.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Persil des Ruisseaux', 'soupes_bouillons', 'liquid', 2.00, 'Léger et herbacé, persil cueilli près des eaux vives.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Carotte des Jardins Anciens', 'soupes_bouillons', 'liquid', 3.00, 'Douce et légèrement sucrée, carottes des vieux jardins.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Thym et Laurier', 'soupes_bouillons', 'liquid', 2.50, 'Classique et aromatique, base de toutes les grandes sauces.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Topinambour des Landes', 'soupes_bouillons', 'liquid', 3.50, 'Douce et légèrement noisettée, racine des terres incultes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Cresson des Sources', 'soupes_bouillons', 'liquid', 2.50, 'Poivré et vivifiant, cresson cueilli aux sources pures.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Maïs des Plaines Dorées', 'soupes_bouillons', 'liquid', 3.00, 'Sucrée et légère, épis dorés des grandes plaines.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Sarriette des Garrigues', 'soupes_bouillons', 'liquid', 2.00, 'Aromatique et légèrement poivré, herbe des garrigues.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Betterave des Collines', 'soupes_bouillons', 'liquid', 3.50, 'Rouge profond et légèrement sucrée, terreuse et douce.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Romarin et Origan', 'soupes_bouillons', 'liquid', 2.50, 'Méditerranéen et parfumé, herbes des coteaux ensoleillés.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Pomme de Terre des Hauteurs', 'soupes_bouillons', 'liquid', 3.00, 'Épaisse et réconfortante, pommes de terre des montagnes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Cerfeuil des Prairies', 'soupes_bouillons', 'liquid', 2.00, 'Délicat et anisé, herbe des prés humides.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe d''Oignon des Plaines', 'soupes_bouillons', 'liquid', 3.50, 'Caramélisée et profonde, oignons fondants longuement cuits.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Miso des Terres de l''Est', 'soupes_bouillons', 'liquid', 4.00, 'Umami et savoureux, pâte fermentée des contrées orientales.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Pois Cassés des Champs', 'soupes_bouillons', 'liquid', 2.50, 'Épaisse et nourrissante, pois verts des jardins paysans.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Feuilles de Laurier', 'soupes_bouillons', 'liquid', 2.00, 'Simple et aromatique, base légère aux feuilles nobles.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Tomate des Jardins Ensoleillés', 'soupes_bouillons', 'liquid', 3.00, 'Rouge et acidulée, tomates mûries au soleil d''été.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Poulet des Basse-Cours', 'soupes_bouillons', 'liquid', 3.50, 'Doré et réconfortant, cuit longuement avec légumes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Poivron des Contrées Chaudes', 'soupes_bouillons', 'liquid', 3.50, 'Douce et colorée, poivrons rouges des terres du Sud.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Champignons Séchés', 'soupes_bouillons', 'liquid', 3.00, 'Concentré et umami, champignons séchés réhydratés lentement.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Haricots Blancs des Plaines', 'soupes_bouillons', 'liquid', 2.50, 'Crémeuse et nourrissante, haricots mitonnés au bouquet garni.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Safran des Épices', 'soupes_bouillons', 'liquid', 5.00, 'Doré et parfumé, épice précieuse des marchés lointains.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Panais des Terres du Nord', 'soupes_bouillons', 'liquid', 3.00, 'Douce et légèrement anisée, racine des contrées froides.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Cumin des Déserts', 'soupes_bouillons', 'liquid', 2.50, 'Épicé et chaud, graines des contrées arides et chaudes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Coriandre et Citron', 'soupes_bouillons', 'liquid', 3.50, 'Fraîche et herbacée, agrémentée d''un trait d''agrume.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Cèpes des Bois Obscurs', 'soupes_bouillons', 'liquid', 5.50, 'Intense et terreux, roi des champignons forestiers.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Salsifis des Champs', 'soupes_bouillons', 'liquid', 3.00, 'Douce et légèrement sucrée, racine oubliée des jardins.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Menthe et Citron', 'soupes_bouillons', 'liquid', 2.00, 'Frais et légèrement acidulé, bouillon surprenant du voyageur.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Fenouil des Falaises', 'soupes_bouillons', 'liquid', 3.50, 'Anisée et légère, fenouil sauvage des côtes rocheuses.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon d''Estragon des Collines', 'soupes_bouillons', 'liquid', 2.50, 'Délicat et légèrement anisé, herbe noble des jardins.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Poireau et Pomme de Terre', 'soupes_bouillons', 'liquid', 3.00, 'Classique et réconfortante, veloutée des auberges.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Baies de Genièvre', 'soupes_bouillons', 'liquid', 3.00, 'Boisé et légèrement amer, baies des forêts de conifères.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soupe de Roquette des Jardins', 'soupes_bouillons', 'liquid', 2.50, 'Légèrement piquante et herbacée, servie avec croûtons.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bouillon de Laurier et Baies', 'soupes_bouillons', 'liquid', 2.00, 'Simple et aromatique, parfum d''automne dans une tasse.');

-- ── victuailles (60 items, solid, 4.00–10.00) ────────────────

INSERT INTO menu_items (name, category, type, price, description) VALUES ('Rôti de Sanglier des Marais', 'victuailles', 'solid', 9.00, 'Viande sauvage mijotée dans son jus, chair fondante.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Cuisse de Poulet Rôti des Forêts', 'victuailles', 'solid', 7.50, 'Dorée et croustillante, farcie aux herbes sylvestres.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tranche de Cerf des Hautes Terres', 'victuailles', 'solid', 10.00, 'Noble viande des cerfs chassés dans les hautes landes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pavé de Saumon des Rivières Froides', 'victuailles', 'solid', 9.50, 'Chair rosée et savoureuse, grillée sur plancher de bois.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Filet de Perche des Lacs Enchantés', 'victuailles', 'solid', 8.00, 'Poisson délicat des lacs aux eaux cristallines.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Côtelette d''Agneau des Collines', 'victuailles', 'solid', 9.00, 'Tendre et parfumée, pâturages herbeux des collines.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Brochette de Chevreuil des Bois', 'victuailles', 'solid', 8.50, 'Morceaux marinés et grillés sur feu de bois vif.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Aile de Canard des Étangs', 'victuailles', 'solid', 7.50, 'Confite lentement, chair fondante et peau croustillante.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Médaillon de Bœuf des Plaines', 'victuailles', 'solid', 10.00, 'Pièce noble des grands troupeaux des plaines fertiles.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Truite Fumée des Torrents', 'victuailles', 'solid', 8.00, 'Pêchée dans les torrents, fumée au bois de hêtre.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Jambon de Montagne Séché', 'victuailles', 'solid', 6.50, 'Affiné longuement dans le vent froid des hauteurs.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Côte de Porc des Fermes', 'victuailles', 'solid', 7.00, 'Généreuse et savoureuse, cochon élevé en plein air.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Lapin Confit des Garrigues', 'victuailles', 'solid', 8.50, 'Cuit doucement dans ses graisses aux herbes provençales.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Rôti de Bison des Grandes Plaines', 'victuailles', 'solid', 10.00, 'Viande puissante et maigre des troupeaux sauvages.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Filet de Bar des Côtes Rocheuses', 'victuailles', 'solid', 9.00, 'Chair ferme et blanche, pêché entre les rochers.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Perdrix Rôtie des Landes', 'victuailles', 'solid', 8.50, 'Petit gibier sauvage aux saveurs intenses des landes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Dinde Farcie des Festins', 'victuailles', 'solid', 9.00, 'Farcie aux marrons et aux herbes, festin de saison.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Cabillaud Grillé des Abysses', 'victuailles', 'solid', 7.50, 'Chair blanche et feuilletée, pêché dans les eaux profondes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Oie Confite des Terres Grasses', 'victuailles', 'solid', 9.50, 'Confite dans sa graisse, cuisse fondante et dorée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Rôti de Veau des Vertes Prairies', 'victuailles', 'solid', 10.00, 'Tendre et délicat, veau élevé dans les pâturages verts.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Brochette de Caille des Vignes', 'victuailles', 'solid', 7.00, 'Petits oiseaux marinés et grillés au feu de sarment.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Filet de Brochet des Marais', 'victuailles', 'solid', 8.00, 'Chair ferme du prédateur des zones humides.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Épaule de Mouton des Pâturages', 'victuailles', 'solid', 8.50, 'Longuement braisée, chair effeuillée aux épices douces.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Cuisse de Faisan des Bois Royaux', 'victuailles', 'solid', 9.00, 'Gibier noble des forêts, rôti aux baies sauvages.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Steak de Buffle des Savanes', 'victuailles', 'solid', 10.00, 'Chair rouge et sauvage, venue des grandes savanes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tranches de Lard des Montagnes', 'victuailles', 'solid', 5.00, 'Épaisses tranches fumées du lard des hauteurs.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Anguille Fumée des Roseaux', 'victuailles', 'solid', 8.50, 'Pêchée dans les roseaux, fumée longuement au chêne.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Poitrine de Dinde des Festins', 'victuailles', 'solid', 7.50, 'Tendre et juteuse, cuite lentement au four de pierre.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Gigot d''Agneau des Plaines Vertes', 'victuailles', 'solid', 10.00, 'Rôti entier, chair tendre effleurée aux herbes fraîches.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Joue de Bœuf des Prairies Fertiles', 'victuailles', 'solid', 9.00, 'Braisée longuement, fondante à la façon paysanne.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Écrevisse des Ruisseaux Clairs', 'victuailles', 'solid', 7.00, 'Petits crustacés grillés au beurre et à l''ail.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Brochette de Canard aux Herbes', 'victuailles', 'solid', 8.00, 'Morceaux juteux marinés aux herbes des jardins.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Filet de Dorade des Golfes', 'victuailles', 'solid', 9.50, 'Poisson noble des eaux chaudes, grillé à la plancha.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Rôti de Chevreau des Causses', 'victuailles', 'solid', 8.50, 'Jeune chèvre rôtie aux herbes des causses secs.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Entrecôte de Bœuf des Hauts Pâturages', 'victuailles', 'solid', 10.00, 'Persillée et savoureuse, des meilleurs pâturages d''altitude.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Lotte Rôtie des Fonds Marins', 'victuailles', 'solid', 9.00, 'Chair ferme et délicate de la reine des fonds marins.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Fricassée de Lapin des Garennes', 'victuailles', 'solid', 7.50, 'Morceaux de lapin mijotés en sauce onctueuse.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Saucisse de Sanglier des Forêts', 'victuailles', 'solid', 6.00, 'Épicée et sauvage, façonnée selon la recette ancienne.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Magret de Canard des Étangs', 'victuailles', 'solid', 9.00, 'Chair rosée et peau croustillante, cuit à la perfection.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pavé de Thon des Mers du Sud', 'victuailles', 'solid', 9.50, 'Cœur rouge du thon, saisi à feu vif, rosé dedans.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Ragoût de Cerf des Plaines', 'victuailles', 'solid', 8.00, 'Mijoté longuement aux légumes et aux herbes sauvages.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Rôti de Marcassin des Taillis', 'victuailles', 'solid', 9.00, 'Jeune sanglier rôti, saveur intense et rustique.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Sole Meunière des Baies', 'victuailles', 'solid', 8.50, 'Délicate sole cuite au beurre noisette et citron.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Carpe Fumée des Étangs Mystiques', 'victuailles', 'solid', 7.00, 'Grande carpe des eaux tranquilles, fumée au cerisier.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pintade Rôtie des Campagnes', 'victuailles', 'solid', 8.50, 'Volaille de choix, rôtie aux herbes et au citron.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tajine de Chevreuil aux Épices', 'victuailles', 'solid', 9.00, 'Mijoté longuement aux épices des routes caravanières.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tranches de Terrine des Forêts', 'victuailles', 'solid', 5.50, 'Terrine artisanale aux gibiers et herbes sylvestres.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Crépinette de Veau des Collines', 'victuailles', 'solid', 7.50, 'Petite saucisse enveloppée dans la crépine du veau.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Filet de Hareng des Eaux Froides', 'victuailles', 'solid', 6.00, 'Poisson gras et savoureux des mers nordiques froides.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Émincé de Poulet des Bosquets', 'victuailles', 'solid', 7.00, 'Lanières de poulet sautées aux légumes des jardins.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Ballotine de Volaille aux Herbes', 'victuailles', 'solid', 8.00, 'Rouleau de volaille farci aux herbes aromatiques.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Andouillette de Montagne', 'victuailles', 'solid', 6.50, 'Charcuterie rustique des régions montagneuses fromagères.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Noisette d''Agneau des Causses', 'victuailles', 'solid', 9.00, 'Petit médaillon d''agneau, tendre et parfumé aux herbes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Paleron de Bœuf Braisé', 'victuailles', 'solid', 8.50, 'Morceau fondant, braisé pendant des heures au bouillon.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Sardines Grillées des Côtes', 'victuailles', 'solid', 5.00, 'Petits poissons huileux grillés sur braises ardentes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Rôti de Cochon de Lait', 'victuailles', 'solid', 9.50, 'Peau croustillante et chair fondante du jeune cochon.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Cuisse de Lièvre des Collines', 'victuailles', 'solid', 8.00, 'Chair sombre et sauvage, mijotée aux baies sauvages.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Filet de Saint-Pierre des Profondeurs', 'victuailles', 'solid', 10.00, 'Chair délicate et fine du poisson des grands fonds.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Brochette de Crevettes des Lagunes', 'victuailles', 'solid', 7.50, 'Crevettes grillées à l''ail et aux herbes marines.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Lamproie des Rivières Sombres', 'victuailles', 'solid', 8.00, 'Créature des rivières obscures, préparée à la bordelaise.');

-- ── pains_viennoiseries (40 items, solid, 0.50–3.00) ─────────

INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain de Seigle des Collines', 'pains_viennoiseries', 'solid', 1.50, 'Dense et légèrement acide, cuit dans le four de pierre.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Miche de Froment des Plaines', 'pains_viennoiseries', 'solid', 1.00, 'Ronde et dorée, croûte croustillante et mie moelleuse.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Baguette Croustillante des Fours Anciens', 'pains_viennoiseries', 'solid', 1.00, 'Longue et craquante, cuite selon la tradition ancestrale.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Petit Pain aux Graines de Pavot', 'pains_viennoiseries', 'solid', 0.75, 'Doux et parsemé de graines, parfait pour accompagner.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tourte aux Noix des Forêts', 'pains_viennoiseries', 'solid', 2.50, 'Dense et riche, truffée de noix des sous-bois.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Fougasse aux Herbes des Garrigues', 'pains_viennoiseries', 'solid', 2.00, 'Plate et parfumée, huile et herbes en abondance.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain d''Épautre des Hauts Pâturages', 'pains_viennoiseries', 'solid', 2.00, 'Rustique et nutritif, farine ancienne des hauts plateaux.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bretzel des Marchés du Nord', 'pains_viennoiseries', 'solid', 1.25, 'Croustillant et salé, emblème des foires du Nord.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain au Levain des Monastères', 'pains_viennoiseries', 'solid', 1.75, 'Long levage, acidité douce et mie aérée légèrement.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Galette de Sarrasin des Landes', 'pains_viennoiseries', 'solid', 1.50, 'Fine et croustillante, farine de blé noir des landes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain Complet des Moulins', 'pains_viennoiseries', 'solid', 1.25, 'Riche en fibres, farine de blé complète des anciens moulins.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Croissant aux Amandes des Jardins', 'pains_viennoiseries', 'solid', 1.50, 'Feuilleté et beurré, garni d''amandes dorées craquantes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Brioche Dorée des Matins', 'pains_viennoiseries', 'solid', 2.00, 'Moelleuse et beurrée, dorée comme le soleil du matin.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Chausson aux Pommes des Vergers', 'pains_viennoiseries', 'solid', 2.50, 'Croustillant fourré aux pommes caramélisées des vergers.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain aux Raisins des Vignobles', 'pains_viennoiseries', 'solid', 2.00, 'Spirale moelleuse parsemée de raisins secs dorés.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Crêpe de Froment des Marchés', 'pains_viennoiseries', 'solid', 1.00, 'Fine et souple, servie nature ou légèrement sucrée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain à l''Épeautre des Champs', 'pains_viennoiseries', 'solid', 1.75, 'Saveur de noisette douce, farine d''épeautre antique.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tresse Dorée au Beurre', 'pains_viennoiseries', 'solid', 2.00, 'Tressée et beurrée, croûte brillante au jaune d''œuf.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain de Maïs des Contrées Chaudes', 'pains_viennoiseries', 'solid', 1.50, 'Jaune et légèrement sucré, moelleux et fondant.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Muffin aux Myrtilles des Bois', 'pains_viennoiseries', 'solid', 1.75, 'Moelleux et fruité, troué de myrtilles sauvages.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Scone à la Cannelle des Épices', 'pains_viennoiseries', 'solid', 1.50, 'Friable et parfumé, tradition des contrées du Nord.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain de Campagne aux Olives', 'pains_viennoiseries', 'solid', 2.00, 'Rustique et parfumé aux olives noires des terroirs.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Biscuit aux Flocons d''Avoine', 'pains_viennoiseries', 'solid', 0.75, 'Croquant et nourrissant, simple gâteau des voyageurs.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain aux Herbes de Provence', 'pains_viennoiseries', 'solid', 1.75, 'Aromatique et méditerranéen, croûte parfumée en bouche.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Petit Four aux Noisettes', 'pains_viennoiseries', 'solid', 1.00, 'Petite douceur croquante aux noisettes grillées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain de Sable aux Noix', 'pains_viennoiseries', 'solid', 1.25, 'Sablé et friable, riche en noix des forêts sauvages.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Focaccia aux Tomates Séchées', 'pains_viennoiseries', 'solid', 2.50, 'Moelleuse et parfumée, généreusement huilée et herbeuse.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain aux Figues des Jardins', 'pains_viennoiseries', 'solid', 2.00, 'Moelleux et sucré, parsemé de figues séchées des jardins.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Kouglof aux Raisins Secs', 'pains_viennoiseries', 'solid', 3.00, 'Couronne de brioche parfumée aux raisins et amandes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain Brioché des Fêtes', 'pains_viennoiseries', 'solid', 2.50, 'Riche et moelleux, réservé aux grandes occasions festives.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bagel aux Graines de Sésame', 'pains_viennoiseries', 'solid', 1.75, 'Anneau élastique et croustillant, généreusement sesamisé.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain Naan des Contrées Orientales', 'pains_viennoiseries', 'solid', 1.50, 'Souple et légèrement grillé, pita des routes caravanières.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Ciabatta aux Olives Noires', 'pains_viennoiseries', 'solid', 2.00, 'Alvéolée et légère, parsemée d''olives noires généreuses.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain aux Lardons et Noix', 'pains_viennoiseries', 'solid', 2.50, 'Savoureux et rustique, alliance du fumé et du croquant.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Cramique aux Raisins', 'pains_viennoiseries', 'solid', 2.00, 'Brioche nordique aux raisins, sucrée et légèrement beurrée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Crumpet au Miel des Ruches', 'pains_viennoiseries', 'solid', 1.75, 'Spongieux et troué, nappé d''un filet de miel doré.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain Perdu aux Épices', 'pains_viennoiseries', 'solid', 2.00, 'Doré et parfumé, tranches imbibées et poêlées lentement.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Streusel aux Pommes des Vergers', 'pains_viennoiseries', 'solid', 2.50, 'Tarte streusel croustillante aux pommes caramélisées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Cake Marbré à la Vanille', 'pains_viennoiseries', 'solid', 2.00, 'Alternance de pâtes vanillée et chocolatée fondantes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain Azyme des Pèlerins', 'pains_viennoiseries', 'solid', 0.50, 'Fine galette sans levain, nourriture des longs pèlerinages.');

-- ── fromages_affines (30 items, solid, 4.00–10.00) ───────────

INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tome des Montagnes Glacées', 'fromages_affines', 'solid', 6.00, 'Pâte pressée cuite, saveur douce et légèrement fruitée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Affiné de Brebis des Causses', 'fromages_affines', 'solid', 7.00, 'Pâte dure au lait de brebis, saveur longue et intense.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Croûte Fleurie des Collines', 'fromages_affines', 'solid', 5.50, 'Pâte molle à croûte blanche, fondante et crémeuse.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bleu des Grottes Profondes', 'fromages_affines', 'solid', 8.00, 'Pâte persillée affinée dans les grottes fraîches.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Chèvre Cendré des Garrigues', 'fromages_affines', 'solid', 6.50, 'Bûche cendrée de chèvre, acidulée et légèrement herbacée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Comté des Hauts Pâturages', 'fromages_affines', 'solid', 7.50, 'Pâte pressée cuite aux notes fruitées et de noisette.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Raclette des Sommets Enneigés', 'fromages_affines', 'solid', 8.00, 'Pâte à fondre, parfaite des alpages d''altitude.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Munster des Vallées Fraîches', 'fromages_affines', 'solid', 6.00, 'Pâte molle à croûte lavée, caractère puissant et affirmé.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Ossau-Iraty des Plaines Basques', 'fromages_affines', 'solid', 8.50, 'Pâte pressée de brebis, doux et légèrement noisettée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Roquefort des Caves Mystiques', 'fromages_affines', 'solid', 9.00, 'Bleu puissant affiné dans les caves naturelles creusées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Emmental des Prairies Alpines', 'fromages_affines', 'solid', 5.50, 'Pâte dure aux grandes alvéoles, saveur douce et lactée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Camembert des Terres Normandes', 'fromages_affines', 'solid', 6.00, 'Pâte molle crémeuse, croûte duvetée et odeur prononcée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Brie des Forêts Royales', 'fromages_affines', 'solid', 7.00, 'Grand fromage plat, pâte onctueuse et croûte fleurie.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Livarot des Prairies Riantes', 'fromages_affines', 'solid', 6.50, 'Pâte molle à croûte lavée, forte et colorée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Cantal des Hauts Volcans', 'fromages_affines', 'solid', 7.00, 'Pâte pressée fermière, saveur lactée des volcans anciens.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Fourme d''Ambert des Cavernes', 'fromages_affines', 'solid', 8.00, 'Bleu doux et crémeux, affiné en cave froide de montagne.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Saint-Nectaire des Plaines Vertes', 'fromages_affines', 'solid', 7.50, 'Pâte pressée semi-cuite, noisette et croûte grise.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Reblochon des Alpages Secrets', 'fromages_affines', 'solid', 8.00, 'Pâte pressée non cuite, onctueux et parfumé du matin.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Époisses des Bourgognes', 'fromages_affines', 'solid', 8.50, 'Croûte orange lavée, pâte coulante et arôme puissant.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Maroilles des Marches du Nord', 'fromages_affines', 'solid', 7.00, 'Pâte molle lavée, franche et affirmée du Nord.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Morbier des Vallées Jurassiennes', 'fromages_affines', 'solid', 7.50, 'Pâte pressée non cuite, ligne de cendre en son cœur.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Brocciu des Îles Sauvages', 'fromages_affines', 'solid', 6.50, 'Fromage frais de brebis, léger et délicat des îles.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Banon des Plateaux Secs', 'fromages_affines', 'solid', 5.50, 'Enveloppé de feuilles de châtaignier, doux et fondant.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pélardon des Causses Secs', 'fromages_affines', 'solid', 6.00, 'Petit chèvre des causses secs, fin et légèrement acidulé.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Rocamadour des Falaises', 'fromages_affines', 'solid', 5.00, 'Minuscule chèvre des falaises, fondant et légèrement acidulé.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Salers des Terres Volcaniques', 'fromages_affines', 'solid', 8.00, 'Pâte pressée fermière, saveur intense de terre et d''herbe.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Laguiole des Hauts Pâturages', 'fromages_affines', 'solid', 8.50, 'Pâte pressée cuite, fruité et floral de l''Aubrac.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Beaufort des Cimes Alpines', 'fromages_affines', 'solid', 9.00, 'Roi des fromages gruyères, saveur complexe des alpages.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Gruyère des Forêts Profondes', 'fromages_affines', 'solid', 7.00, 'Pâte cuite ferme, trous caractéristiques et goût fruité.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Vacherin des Prés Enneigés', 'fromages_affines', 'solid', 10.00, 'Pâte molle d''hiver, coulante et résineuse, cerclée de bois.');

-- ── desserts_douceurs (50 items, solid, 6.00–18.00) ──────────

INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tarte au Miel de Grotte', 'desserts_douceurs', 'solid', 8.00, 'Fond sablé garni de miel cristallisé des grottes profondes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Gâteau Fondant au Chocolat Noir', 'desserts_douceurs', 'solid', 9.00, 'Cœur coulant intense au cacao des forêts lointaines.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Crème Brûlée aux Épices', 'desserts_douceurs', 'solid', 7.50, 'Caramel craquant sur crème aux épices de caravane.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Forêt Noire des Bois Enchantés', 'desserts_douceurs', 'solid', 10.00, 'Gâteau généreux aux cerises et à la crème fouettée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Mousse de Fraises des Bois', 'desserts_douceurs', 'solid', 8.50, 'Légère et acidulée, fraises sauvages en crème aérienne.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tarte Tatin aux Pommes des Vergers', 'desserts_douceurs', 'solid', 9.00, 'Pommes caramélisées renversées sur pâte beurrée dorée.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Millefeuille à la Vanille des Îles', 'desserts_douceurs', 'solid', 10.00, 'Feuillets croustillants et crème vanillée généreuse.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pannacotta aux Fruits Rouges', 'desserts_douceurs', 'solid', 8.00, 'Crème délicate nappée de coulis de fruits des bois.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Soufflé au Citron Doré', 'desserts_douceurs', 'solid', 9.50, 'Léger et aérien, parfum intense du citron des jardins.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bavarois aux Framboises des Bois', 'desserts_douceurs', 'solid', 10.00, 'Mousse légère sur biscuit, nappée de framboises acidulées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Charlotte aux Poires des Vergers', 'desserts_douceurs', 'solid', 9.00, 'Biscuits imbibés entourant une mousse de poire fondante.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Clafoutis aux Cerises des Jardins', 'desserts_douceurs', 'solid', 7.50, 'Pâte épaisse aux cerises, cuite dorée au four de pierre.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tarte Meringuée au Citron', 'desserts_douceurs', 'solid', 9.00, 'Meringue blanche et crème citronnée sur fond sablé.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Fondant au Caramel Beurre Salé', 'desserts_douceurs', 'solid', 8.50, 'Cœur coulant caramel, alliance douce et salée parfaite.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Savarin au Rhum des Terres Lointaines', 'desserts_douceurs', 'solid', 11.00, 'Brioche légère imbibée de sirop aux épices exotiques.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Dacquoise aux Noisettes des Forêts', 'desserts_douceurs', 'solid', 10.00, 'Meringue fondante aux noisettes et crème légère.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Opéra des Grandes Occasions', 'desserts_douceurs', 'solid', 12.00, 'Gâteau somptueux aux couches de café et chocolat.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Paris-Brest à la Praline', 'desserts_douceurs', 'solid', 11.00, 'Pâte à choux garnie de crème pralinée aux noisettes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Saint-Honoré des Fêtes', 'desserts_douceurs', 'solid', 13.00, 'Couronne de choux garnie de crème et caramel filé.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Éclair au Café des Caravanes', 'desserts_douceurs', 'solid', 7.00, 'Choux allongé garni de crème au café des marchands.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Profiteroles à la Crème Dorée', 'desserts_douceurs', 'solid', 9.00, 'Petits choux garnis de crème, nappés de chocolat chaud.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Religieuse au Chocolat Amer', 'desserts_douceurs', 'solid', 8.00, 'Double choux superposés, crème chocolat et glaçage amer.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Madeleine au Beurre Noisette', 'desserts_douceurs', 'solid', 6.50, 'Petite bosse dorée, fondante et parfumée au beurre.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Financier aux Amandes Grillées', 'desserts_douceurs', 'solid', 6.00, 'Petit gâteau humide aux amandes, beurre noisette intenso.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Cannelé des Terres Bordelaises', 'desserts_douceurs', 'solid', 7.00, 'Croûte caramélisée sur intérieur moelleux et vanillé.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Calisson des Plaines Méridionales', 'desserts_douceurs', 'solid', 8.00, 'Losange d''amande et de melon, glaçage blanc délicat.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Nougat de la Montagne Blanche', 'desserts_douceurs', 'solid', 9.00, 'Doux et moelleux, miel des alpages et amandes entières.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Guimauve aux Fleurs de Rose', 'desserts_douceurs', 'solid', 6.50, 'Légère et parfumée, petits cubes roses et moelleux.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Caramel aux Épices des Contrées', 'desserts_douceurs', 'solid', 7.00, 'Caramel dur parfumé à la cannelle et au gingembre.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Truffes au Cacao des Forêts', 'desserts_douceurs', 'solid', 10.00, 'Bouchées intenses de chocolat roulées dans le cacao.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Halva aux Pistaches des Jardins', 'desserts_douceurs', 'solid', 9.00, 'Dessert oriental à la semoule et pistaches vertes.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Lokum aux Pétales de Rose', 'desserts_douceurs', 'solid', 8.00, 'Cube gélatineux parfumé à la rose et sucre glace.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Miel Cristallisé des Abeilles', 'desserts_douceurs', 'solid', 7.50, 'Miel brut légèrement cristallisé, servi avec fromage.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Confiture de Figues des Jardins', 'desserts_douceurs', 'solid', 6.50, 'Figues lentement confites au sucre et zeste de citron.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Gelée de Framboise des Bois', 'desserts_douceurs', 'solid', 7.00, 'Gelée brillante aux framboises sauvages et pectine.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Compote de Coings des Vergers', 'desserts_douceurs', 'solid', 6.50, 'Coings fondants cuits longuement au sucre et vanille.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Sorbet à la Menthe Arctique', 'desserts_douceurs', 'solid', 8.00, 'Glace sans lait, fraîcheur absolue de la menthe glaciale.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Glace aux Noix de Pécan', 'desserts_douceurs', 'solid', 9.00, 'Onctueuse crème glacée parsemée de noix caramélisées.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Sundae des Festins Royaux', 'desserts_douceurs', 'solid', 11.00, 'Coupe glacée généreuse aux multiples saveurs et garnitures.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Coulis de Fruits des Forêts', 'desserts_douceurs', 'solid', 6.00, 'Sauce fruitée concentrée, délicieuse sur glace ou gâteau.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Sablé aux Amandes des Cimes', 'desserts_douceurs', 'solid', 7.00, 'Biscuit friable et beurré aux amandes des hauteurs.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Biscuit aux Épices de Noël', 'desserts_douceurs', 'solid', 6.50, 'Croquant et parfumé aux épices hivernales des marchés.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tuile Dentelle aux Oranges', 'desserts_douceurs', 'solid', 7.00, 'Fines gaufrettes croustillantes parfumées à l''orange.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Macaron au Miel des Ruches', 'desserts_douceurs', 'solid', 8.00, 'Coques moelleuses et ganache au miel des ruches.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Palmier au Sucre Vanillé', 'desserts_douceurs', 'solid', 6.00, 'Feuilleté caramélisé en forme de cœur, croustillant.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Pain d''Épices des Forêts', 'desserts_douceurs', 'solid', 7.50, 'Dense et parfumé, miel et épices des forêts d''automne.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tourteau Fromager des Marais', 'desserts_douceurs', 'solid', 9.00, 'Gâteau au fromage de chèvre, croûte noire et intérieur fondant.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Tarte aux Myrtilles des Hauteurs', 'desserts_douceurs', 'solid', 10.00, 'Fond sablé garni de myrtilles sauvages des sommets.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Galette des Rois Dorée', 'desserts_douceurs', 'solid', 12.00, 'Feuilletage doré à la frangipane, fève cachée dans la pâte.');
INSERT INTO menu_items (name, category, type, price, description) VALUES ('Bûche aux Marrons Glacés', 'desserts_douceurs', 'solid', 15.00, 'Roulé à la crème de marrons, décoré de marrons glacés.');

-- ── Commandes seed ────────────────────────────────────────────

-- Commande 1 : pending, table 3
INSERT INTO orders (table_number, status) VALUES (3, 'pending');
INSERT INTO order_items (order_id, menu_item_id, quantity, note) VALUES
  (1, 1, 2, NULL),
  (1, 45, 1, 'bien chaud');

-- Commande 2 : preparing, table 7
INSERT INTO orders (table_number, status) VALUES (7, 'preparing');
INSERT INTO order_items (order_id, menu_item_id, quantity, note) VALUES
  (2, 12, 1, NULL),
  (2, 88, 2, NULL),
  (2, 134, 1, 'sans sauce');

-- Commande 3 : served, table 12
INSERT INTO orders (table_number, status) VALUES (12, 'served');
INSERT INTO order_items (order_id, menu_item_id, quantity, note) VALUES
  (3, 200, 1, NULL),
  (3, 310, 3, NULL);

-- Commande 4 : cancelled, table 5
INSERT INTO orders (table_number, status) VALUES (5, 'cancelled');
INSERT INTO order_items (order_id, menu_item_id, quantity, note) VALUES
  (4, 7, 1, NULL);
