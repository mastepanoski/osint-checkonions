FROM python:3.11-slim

WORKDIR /app

# Instala dependencias del sistema necesarias
RUN apt-get update && apt-get install -y build-essential gcc

# Instala librerías de Python (con soporte SOCKS)
RUN pip install --no-cache-dir requests[socks] beautifulsoup4 PySocks

COPY onions_list.py .

CMD ["python", "onions_list.py"]

