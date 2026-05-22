# DragonTap

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Projet pédagogique](https://img.shields.io/badge/usage-p%C3%A9dagogique-blue)](./README.md)
[![Pas en prod](https://img.shields.io/badge/production-never-red)](./README.md)

Application web de gestion des commandes de l'Antre des 418 Dragons — une auberge fantastique dont la carte compte exactement 418 références : potions, victuailles et breuvages des contrées lointaines.

> ⚠️ **Projet pédagogique** — DragonTap est conçu comme support de formation pour pratiquer, entre autre, la conteneurisation d'une application full stack. Les choix techniques minimalistes sont intentionnels pour rester accessibles aux débutants. Ne pas utiliser en production.

---

## Prise en main rapide

```bash
# 1. Lancer la base de données
docker run -d --name cellar \
  -e POSTGRES_DB=dragontap -e POSTGRES_USER=dragontap -e POSTGRES_PASSWORD=dragontap \
  -v $(pwd)/cellar/init.sql:/docker-entrypoint-initdb.d/init.sql \
  -p 4183:5432 postgres:16-alpine

# 2. Lancer l'API (choisir UNE des deux variantes ci-dessous)

# ── Variante Node.js ─────────────────────────────────────────────
cd innkeeper; $env:DATABASE_URL="postgres://dragontap:dragontap@localhost:4183/dragontap"; $env:PORT="4181"; node src/index.js

# ── Variante Java (Spring Boot) ───────────────────────────────
cd innkeeper-java
DATABASE_URL="jdbc:postgresql://localhost:4183/dragontap?user=dragontap&password=dragontap" \
  PORT=4181 java -jar target/innkeeper-1.0.0.jar
cd innkeeper && npm install
DATABASE_URL=postgres://dragontap:dragontap@localhost:4183/dragontap PORT=4181 node src/index.js

# ── Variante Java (Spring Boot) ───────────────────────────────
cd innkeeper-java
DATABASE_URL="jdbc:postgresql://localhost:4183/dragontap?user=dragontap&password=dragontap" \
  PORT=4181 java -jar target/innkeeper-1.0.0.jar

# 3. Lancer le frontend (depuis la racine)
# ── Variante Vanilla ─────────────────────────────────────────────
npx serve board/public -l 4182

# ── Frontend React (alternative) ────────────────────────────────
cd board-react && npm install
npm run dev
# Disponible sur http://localhost:4182
```

- Frontend : http://localhost:4182
- API : http://localhost:4181/api/health

---

## Objectif pédagogique

DragonTap est une application full stack volontairement simple, prête à l'emploi, conçue pour être donnée aux étudiants telle quelle. L'objectif est de fournir une cible concrète et cohérente pour pratiquer :

- L'écriture de `Dockerfile` pour chaque service
- La gestion des volumes et de la persistance
- La mise en réseau de conteneurs
- L'orchestration multi-services

L'application est intentionnellement fonctionnelle et complète pour que les étudiants se concentrent sur la conteneurisation, pas sur le code.

---

## Architecture

| Service          | Rôle                | Port   | Techno                          |
|------------------|---------------------|--------|---------------------------------|
| `board`          | Frontend SPA        | `4182` | HTML / CSS / JS vanilla + nginx |
| `board-react`    | Frontend SPA (React)| `4182` | React 18 + Vite + TypeScript    |
| `cellar`         | Base de données     | `4183` | PostgreSQL 16                   |
| `innkeeper`      | API REST (Node.js)  | `4181` | Node.js LTS + Express 4         |
| `innkeeper-java` | API REST (Java)     | `4181` | Spring Boot 4 + Java 25         |

---

## Choisir son backend

Les deux backends (`innkeeper` et `innkeeper-java`) sont interchangeables et exposent le même contrat d’API sur le port `4181`. Le frontend `board` appelle `http://localhost:4181` dans les deux cas, sans distinction.

- **`innkeeper/`** — backend Node.js, recommandé pour les débutants ou les exercices orientés JavaScript
- **`innkeeper-java/`** — backend Spring Boot, recommandé pour les exercices orientés Java ou JPA

> Démarrer **un seul backend à la fois**.

---

## Structure du projet

```
dragontap/
├── board/
│   ├── public/
│   │   └── # fichiers du frontend
│   └── nginx.conf
├── board-react/
│   ├── src/
│   │   └── # sources React + TypeScript
│   ├── .env.example
│   └── vite.config.ts
├── cellar/
│   └── init.sql # script d'initialisation de la base de données
├── innkeeper/
│   ├── src/
│   │   └── # sources de l'API REST
│   ├── package.json
│   └── package-lock.json
├── scripts/
│   └── validate.js # script de validation d'installation
└── openapi.yaml
```

---

## Prérequis

- [Node.js LTS](https://nodejs.org/)
- [Docker](https://www.docker.com/) (pour la base de données uniquement)
- npm

---

## Installation

### 1. Base de données — `cellar`

PostgreSQL tourne dans un conteneur Docker. Depuis la racine du projet :

```bash
docker run -d \
  --name cellar \
  -e POSTGRES_DB=dragontap \
  -e POSTGRES_USER=dragontap \
  -e POSTGRES_PASSWORD=dragontap \
  -v ./cellar/init.sql:/docker-entrypoint-initdb.d/init.sql \
  -p 4183:5432 \
  --network dragontap-net \
  -v cellar:/var/lib/postgresql/data \
  postgres:16-alpine
```

Le schéma et les données initiales sont chargés automatiquement au premier démarrage.

Vérification :
```bash
docker logs cellar
# Attendre : "database system is ready to accept connections"
```

> **Repartir de zéro** (re-exécuter le `init.sql`) :
> ```bash
> docker rm -f cellar && docker run ...  # relancer la commande ci-dessus
> ```

### 2. API — `innkeeper`

```bash
cd innkeeper
npm install
DATABASE_URL=postgres://dragontap:dragontap@localhost:4183/dragontap \
PORT=4181 \
node src/index.js
```

L'API est disponible sur http://localhost:4181.
Vérification : http://localhost:4181/api/health

### 3. Frontend — `board`

```bash
# depuis la racine du projet
npx serve board/public -l 4182
```

Le frontend est disponible sur http://localhost:4182.

---

## Variables d'environnement — `innkeeper`

| Variable       | Défaut        | Description                                   |
|----------------|---------------|-----------------------------------------------|
| `DATABASE_URL` | —             | URL de connexion PostgreSQL complète (requis) |
| `PORT`         | `4181`        | Port d'écoute de l'API                        |
| `NODE_ENV`     | `development` | Environnement (`development` / `production`)  |

Exemple :
```
DATABASE_URL=postgres://dragontap:dragontap@localhost:4183/dragontap
PORT=4181
NODE_ENV=production
```

---

## Contrat d'API

Le contrat complet est documenté dans [`openapi.yaml`](./openapi.yaml) (OpenAPI 3.0).

**Visualiser dans Swagger UI (sans rien installer) :**
Ouvrir [editor.swagger.io](https://editor.swagger.io), puis `File → Import URL` ou coller le contenu de `openapi.yaml`.

### Résumé des routes

| Méthode | Route                    | Description                               |
|---------|--------------------------|-------------------------------------------|
| `GET`   | `/api/health`            | État de l'API et de la DB                 |
| `GET`   | `/api/menu`              | Liste des 418 items (`?category=potions`) |
| `GET`   | `/api/menu/:id`          | Détail d'un item                          |
| `GET`   | `/api/orders`            | Liste des commandes (`?status=pending`)   |
| `POST`  | `/api/orders`            | Créer une commande                        |
| `GET`   | `/api/orders/:id`        | Détail d'une commande                     |
| `PATCH` | `/api/orders/:id/status` | Changer le statut                         |

### Transitions de statut

```
pending ──► preparing ──► served
   │
   └──────────────────────► cancelled
```

---

## Base de données

### Schéma

```sql
menu_items  (id, name, category, type, price, description)
orders      (id, table_number, status, created_at)
order_items (id, order_id, menu_item_id, quantity, note)
```

### Catégories du menu

`potions` · `breuvages` · `infusions_froides` · `soupes_bouillons` · `victuailles` · `pains_viennoiseries` · `fromages_affines` · `desserts_douceurs`

### Seed data

Le fichier `cellar/init.sql` contient le schéma complet, les 418 items du menu et 4 commandes initiales (une par statut).

---

## Frontend React

`board-react` est une réécriture de `board` en React 18 + TypeScript + Vite.
Fonctionnellement identique à la version vanilla, elle est destinée à servir
de support alternatif pour des exercices orientés React ou TypeScript.

L'URL de l'API est configurée via une variable d'environnement :

```bash
# board-react/.env
VITE_API_URL=http://localhost:4181
```

**Lancement :**
```bash
cd board-react
npm install
npm run dev      # dev server sur http://localhost:4182
npm run build    # build de production
npm run test     # tests unitaires (Vitest + React Testing Library)
```

---

## Frontend

`board` est une SPA en JavaScript vanilla. Elle communique avec `innkeeper` via l'API Fetch.

L'URL de l'API est configurée dans `board/public/app.js` :

```js
const API_URL = 'http://localhost:4181';
```

**Fonctionnalités :**
- Vue "Commandes" : tableau des commandes groupées par statut, avec prise de commande et boutons d'action (Préparer / Servir / Annuler)
- Vue "La Carte" : liste des 418 références, filtrable par catégorie

---

## Liens

- Repo Git : https://framagit.org/digicrafters/dragon-tap
- Auteur : Nathaniel Vaur Henel https://framagit.org/nathvh/me

---

## Contributing

Les contributions sont les bienvenues, notamment :

- Corrections de bugs ou de typos
- Amélioration du seed data (nouveaux items du menu)
- Traductions de la carte en d'autres langues
- Suggestions de variantes du projet (autre stack backend, etc.)

Merci d'ouvrir une **issue** avant de soumettre une PR significative, pour en discuter au préalable.

---

## Licence

Ce projet est distribué sous licence [MIT](./LICENSE).
Vous êtes libre de l'utiliser, le modifier et le redistribuer, y compris dans un cadre commercial, à condition de conserver la mention de licence d'origine.
