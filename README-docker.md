# Projet Docker Avancé 

 

## Objectif 

 

L'objectif de ce projet était de mettre en place une architecture conteneurisée complète avec Docker. 

 

Nous devions : 

 

- Paramétrer un `docker-compose` permettant la communication entre le front-end, le back-end et la base de données. 

- Mettre en place un réseau interne afin d'assurer les échanges entre les différents services. 

- Garantir le bon fonctionnement de la base de données utilisée par le back-end. 

- Configurer un reverse proxy permettant de relier le réseau interne au monde extérieur. 

 

## Technologies utilisées 

 

- **Front-end** : ReactJS 

- **Back-end** : Spring Boot 

- **Base de données** : PostgreSQL/MySQL (à adapter selon votre projet) 

- **Conteneurisation** : Docker & Docker Compose 

- **Reverse Proxy** : Nginx 

 

## Lancement du projet 

 

### Construction des images 

 

```bash 

docker compose build 

``` 

 

### Démarrage des conteneurs 

 

```bash 

docker compose up -d 

``` 

 

### Vérification des services 

 

```bash 

docker compose ps 

``` 

 

## Architecture 

 

Le projet est composé de plusieurs conteneurs : 

 

- Un conteneur **ReactJS** pour l'interface utilisateur. 

- Un conteneur **Spring Boot** pour l'API. 

- Un conteneur **Base de données** pour le stockage des données. 

- Un conteneur **Nginx** servant de reverse proxy. 

 

L'ensemble des services communique via un réseau Docker interne sécurisé. 

 

## Difficultés rencontrées 

 

### 1. Problèmes de connexion réseau 

 

Nous avons rencontré des problèmes de communication entre les conteneurs en raison d'une mauvaise configuration des ports. 

 

Les principales causes étaient : 

 

- Mauvaise correspondance entre les ports exposés et les ports internes des conteneurs. 

- Erreurs dans les variables de configuration utilisées par le front-end et le back-end. 

 

### 2. Initialisation de la base de données 

 

L'initialisation automatique de la base de données ne fonctionnait pas toujours comme prévu. 

 

Les difficultés rencontrées étaient : 

 

- Oubli des scripts d'initialisation. 

- Ordre de démarrage des conteneurs non respecté. 

- Paramétrage incorrect des variables d'environnement liées à la connexion à la base de données. 

 

## Résultat 

 

À la fin du projet, nous avons obtenu une architecture Docker fonctionnelle permettant : 

 

- La communication entre le front-end et le back-end. 

- La connexion du back-end à la base de données. 

- L'exposition sécurisée de l'application grâce au reverse proxy. 

- Un déploiement simplifié via Docker Compose. 

 

## Conclusion 

 

Ce projet nous a permis d'approfondir notre compréhension de Docker, Docker Compose, de la gestion des réseaux entre conteneurs ainsi que de la mise en place d'un reverse proxy dans une architecture web moderne. 