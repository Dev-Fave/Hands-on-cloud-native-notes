# ============================================
# Week 2: Simple Dockerfile
# ============================================

FROM python:3.11-slim

WORKDIR /app

# Copy the single file
COPY app.py .

# Run the app
EXPOSE 3000
CMD ["python", "app.py"]
