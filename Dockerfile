# 1. Базовый образ с Node.js
FROM node:20-alpine AS builder

# 2. Устанавливаем рабочую директорию внутри контейнера
WORKDIR /app

# 3. Копируем package.json и package-lock.json
COPY package*.json ./

# 4. Устанавливаем зависимости
RUN npm ci

# 5. Копируем остальные файлы проекта
COPY . .

# 6. Собираем frontend с помощью webpack
RUN npm run build

# 7. Второй этап - продакшен-образ
FROM node:20-alpine

# 8. Устанавливаем рабочую директорию
WORKDIR /app

# 9. Копируем только необходимые файлы из builder
COPY --from=builder /app/package.json ./
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

# 10. Указываем порт
EXPOSE 3000

# 11. Запускаем сервер
CMD ["npm", "start"]
