.PHONY: help build build-cli build-app clean test run run-cli run-app install

help: ## Показать эту справку
	@echo "Доступные команды:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Собрать CLI и App
	@BUILD_APP=1 ./build.sh

build-cli: ## Собрать только CLI
	@./build.sh

build-app: ## Собрать только GUI приложение
	@swift build -c release --product HomebrewServicesManager
	@mkdir -p dist
	@cp .build/release/HomebrewServicesManager dist/
	@echo "✅ Built App to dist/HomebrewServicesManager"

clean: ## Очистить build артефакты
	@swift package clean
	@rm -rf dist
	@echo "🧹 Cleaned build artifacts"

test: ## Запустить тесты
	@swift test

run: run-app ## Запустить GUI приложение

run-cli: build-cli ## Собрать и запустить CLI
	@./dist/hsmanager-cli

run-app: build-app ## Собрать и запустить GUI приложение
	@./dist/HomebrewServicesManager

install: build ## Установить CLI в /usr/local/bin
	@echo "Installing hsmanager-cli to /usr/local/bin..."
	@sudo cp dist/hsmanager-cli /usr/local/bin/
	@sudo chmod +x /usr/local/bin/hsmanager-cli
	@echo "✅ Installed hsmanager-cli"

format: ## Форматировать код (если установлен swift-format)
	@if command -v swift-format >/dev/null 2>&1; then \
		swift-format -i -r Sources Tests; \
		echo "✅ Formatted code"; \
	else \
		echo "⚠️  swift-format not installed. Run: brew install swift-format"; \
	fi

.DEFAULT_GOAL := help
