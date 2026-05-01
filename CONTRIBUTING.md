# Contribuer à DragonTap

Merci de l'intérêt que vous portez au projet ! Voici comment contribuer efficacement.

---

## Avant de commencer

Merci d'**ouvrir une issue** avant de soumettre une Merge Request significative. Cela permet de discuter de la pertinence et de l'approche avant d'investir du temps des deux côtés.

Pour les corrections mineures (typos, fautes, petits bugs évidents), une PR directe est la bienvenue sans issue préalable.

---

## Types de contributions acceptées

**Corrections**
- Bugs dans l'API ou le frontend
- Typos ou erreurs dans la documentation
- Erreurs dans le schéma SQL ou le seed data

**Contenu**
- Nouveaux items du menu (dans le respect de la charte : fantasy médiéval, aucune référence à l'alcool, descriptions en une phrase)
- Corrections ou améliorations des 418 descriptions existantes

**Variantes techniques**
- Implémentation alternative de `innkeeper` dans une autre stack (Python/FastAPI, Go, PHP…)
- Ces variantes doivent respecter le contrat d'API défini dans `openapi.yaml`

**Internationalisation**
- Traduction de la carte (noms et descriptions des items) dans d'autres langues
- À placer dans `cellar/i18n/init.<lang>.sql`

---

## Charte du contenu

DragonTap est un projet à destination d'étudiants de tous âges et contextes.
Tout contenu soumis doit respecter les règles suivantes :

- ✅ Univers fantasy médiéval (potions, élixirs, victuailles, breuvages fantastiques)
- ✅ Noms et descriptions en français soigné
- ❌ Aucune référence à l'alcool, à l'ivresse ou aux boissons alcoolisées
- ❌ Aucun contenu offensant, discriminatoire ou inapproprié

---

## Processus

1. Forker le dépôt
2. Créer une branche explicite (`fix/typo-readme`, `feat/innkeeper-python`, `content/menu-items`)
3. Faire des commits clairs et atomiques
4. Ouvrir une Merge Request en décrivant ce qui change et pourquoi

---

## Ce qui n'est pas dans le scope

Pour garder le projet simple et pédagogiquement lisible, les contributions suivantes ne seront pas acceptées :

- Ajout d'authentification ou de gestion de sessions
- Remplacement du frontend vanilla par un framework (React, Vue…)
- Ajout d'un ORM côté `innkeeper`
- Toute complexité qui éloignerait le projet de son objectif : être une cible de conteneurisation accessible aux débutants
