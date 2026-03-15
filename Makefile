.PHONY: help install install-dev run docker-up docker-down docker-build test test-cov clean logs

help:
	@echo "User Service - Available commands:"
	@echo "  make install      - Create venv and install dependencies"
	@echo "  make install-dev  - Install dev dependencies (includes test tools)"
	@echo "  make run          - Run service locally"
	@echo "  make test         - Run tests with pytest"
	@echo "  make test-cov     - Run tests with coverage report"
	@echo "  make docker-up    - Start services with Docker Compose"
	@echo "  make docker-down  - Stop Docker Compose services"
	@echo "  make docker-build - Rebuild Docker images"
	@echo "  make logs         - Show Docker logs"
	@echo "  make clean        - Clean up Python cache and venv"

install:
	@echo "Creating virtual environment..."
	python3 -m venv venv
	@echo "Installing dependencies..."
	./venv/bin/pip install -r requirements.txt
	@echo "Done! Activate with: source venv/bin/activate"

install-dev:
	@echo "Creating virtual environment..."
	python3 -m venv venv
	@echo "Installing dev dependencies..."
	./venv/bin/pip install -r requirements-dev.txt
	@echo "Done! Activate with: source venv/bin/activate"

run:
	@echo "Starting User Service..."
	./start.sh

docker-up:
	@echo "Starting services with Docker Compose..."
	docker-compose up -d
	@echo "Services started! API available at http://localhost:8000"
	@echo "Docs at http://localhost:8000/docs"

docker-down:
	@echo "Stopping Docker Compose services..."
	docker-compose down

docker-build:
	@echo "Building Docker images..."
	docker-compose build

logs:
	docker-compose logs -f

clean:
	@echo "Cleaning up..."
	rm -rf __pycache__ app/__pycache__ app/routers/__pycache__ tests/__pycache__
	rm -rf .pytest_cache htmlcov .coverage
	rm -rf venv
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@echo "Cleanup complete!"

test:
	@echo "Running tests..."
	./venv/bin/pytest

test-cov:
	@echo "Running tests with coverage..."
	./venv/bin/pytest --cov=app --cov-report=term-missing --cov-report=html
	@echo "Coverage report generated in htmlcov/index.html"
