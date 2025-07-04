# PDTM Onion Scanner

Esta es una reestructuración del proyecto que utiliza [PDTM](https://github.com/projectdiscovery/pdtm) para escanear URLs .onion utilizando httpx a través de Tor.

## Estructura del proyecto

```
pdtm-scanner/
├── Dockerfile              # Imagen con PDTM y httpx
├── docker-compose.yml      # Orquestación de servicios
├── scan_onions.sh          # Script principal de escaneo
├── output/                 # Directorio para resultados
└── README.md              # Esta documentación
```

## Características

- **PDTM Integration**: Utiliza Project Discovery Tool Manager para gestionar herramientas
- **httpx**: Herramienta de verificación HTTP/HTTPS rápida y flexible
- **Tor Proxy**: Conexión a través de Tor para acceso a servicios .onion
- **JSON Output**: Resultados estructurados en formato JSON
- **CSV Summary**: Resumen en formato CSV para análisis
- **Tech Detection**: Detección de tecnologías utilizadas
- **Rate Limiting**: Control de velocidad para evitar sobrecargas

## Uso

1. **Construir y ejecutar los contenedores**:
   ```bash
   cd pdtm-scanner
   docker compose up --build
   ```

2. **Los resultados se guardan en**:
   - `output/httpx_results.json` - Resultados completos en JSON
   - `output/scan_summary.csv` - Resumen en CSV
   - `output/onions_list.txt` - Lista de URLs extraídas

## Configuración del escaneo

El script `scan_onions.sh` está configurado con:

- **Proxy**: socks5://tor:9050
- **Threads**: 10 conexiones paralelas
- **Timeout**: 30 segundos por request
- **Retries**: 2 intentos por URL
- **Rate Limit**: 5 requests por segundo
- **User Agent**: Mozilla/5.0 (Windows NT 10.0; Win64; x64)

## Datos de salida

### JSON Output
Cada entrada contiene:
- URL
- Status code
- Title de la página
- Server header
- Tecnologías detectadas
- Content length
- Response time

### CSV Summary
Formato CSV con columnas:
- URL, Status, Title, Server, Tech, Content-Length, Response-Time

## Consideraciones de Seguridad

- ✅ **Proxy Tor**: Todas las conexiones pasan por Tor
- ✅ **Rate Limiting**: Evita sobrecargar servicios
- ✅ **Timeout Control**: Evita conexiones colgadas
- ✅ **User Agent**: Simula navegador real
- ⚠️ **Logs**: Los resultados pueden contener información sensible

## Requisitos

- Docker
- Docker Compose
- Acceso a internet (para descargar herramientas PDTM)

## Personalización

Puedes modificar el script `scan_onions.sh` para:
- Cambiar parámetros de httpx
- Añadir filtros adicionales
- Modificar el formato de salida
- Integrar otras herramientas de PDTM

## Propósito principal

El comando automatiza la verificación masiva de servicios .onion para determinar cuáles están activos y obtener información básica sobre cada uno.

## Casos de Uso en OSINT

### 1. Verificación de servicios activos

* Identifica qué URLs .onion de tu lista están realmente operativas
* Filtra servicios inactivos o dados de baja
* Obtiene códigos de estado HTTP para clasificar respuestas

### 2. Reconocimiento de contenido

* Extrae títulos de páginas para identificar rápidamente el tipo de servicio
* Detecta tecnologías web utilizadas (nginx, Apache, etc.)
* Mapea la superficie de ataque inicial

### 3. Investigación de Dark Markets

* Monitorea la disponibilidad de mercados conocidos
* Identifica nuevos servicios o cambios en servicios existentes
* Rastrea patrones de actividad temporal

### 4. Análisis de infraestructura

* Identifica servicios relacionados por tecnología o configuración
* Detecta posibles servicios espejo o relacionados
* Analiza patrones de hosting

## Limitaciones

* Solo obtiene información superficial (títulos, códigos HTTP)
* No realiza análisis profundo de contenido
* Dependiente de la conectividad Tor
* Algunos servicios pueden bloquear requests automatizados

Este comando es especialmente útil como primer paso en investigaciones OSINT de servicios ocultos, proporcionando una vista general rápida de qué servicios están disponibles y su naturaleza básica.