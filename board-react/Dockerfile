# Build stage
FROM node:22-alpine AS builder

WORKDIR /board-react

# Copier les fichiers package
COPY package*.json ./

# Installer les dépendances
RUN npm install --legacy-peer-deps

# Copier le code source
COPY . .

# Builder l'application (vite build uniquement, sans tsc)
RUN npx vite build

# Serve stage
FROM nginx:alpine

WORKDIR /app

# Copier la config nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copier les fichiers buildés depuis le stage builder
COPY --from=builder /board-react/dist /usr/share/nginx/html

EXPOSE 4182

CMD ["nginx", "-g", "daemon off;"]

