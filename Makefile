.PHONY: help up down logs restart build clean

help:
	@echo "Anti-Deepfake System - Docker Makefile"
	@echo ""
	@echo "Comandos disponibles:"
	@echo "  make up       - Iniciar la aplicación"
	@echo "  make down     - Detener la aplicación"
	@echo "  make logs     - Ver logs en tiempo real"
	@echo "  make restart  - Reiniciar los contenedores"
	@echo "  make build    - Construir las imágenes"
	@echo "  make clean    - Eliminar volúmenes y contenedores"

up:
	docker-compose up --build

down:
	docker-compose down

logs:
	docker-compose logs -f

logs-backend:
	docker-compose logs -f backend

logs-frontend:
	docker-compose logs -f frontend

restart:
	docker-compose restart

build:
	docker-compose build --no-cache

clean:
	docker-compose down -v

shell-backend:
	docker-compose exec backend /bin/bash

shell-frontend:
	docker-compose exec frontend /bin/sh

status:
	docker-compose ps
