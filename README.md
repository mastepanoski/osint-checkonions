# Onions List Extractor

Este proyecto extrae direcciones .onion de la red Tor utilizando la API de Ahmia.fi y genera archivos de salida en múltiples formatos.

## ¿Qué hace?

El script se conecta a través de Tor a la página `https://ahmia.fi/onions` y extrae todas las direcciones .onion disponibles utilizando expresiones regulares. Luego genera archivos de salida en tres formatos:

- **onions_list.txt**: Lista simple de URLs .onion (una por línea)
- **onions_list.json**: Array JSON con todas las direcciones .onion
- **onions_results.csv**: Archivo CSV con las direcciones .onion

## Requisitos

- Docker
- Docker Compose

## Estructura del proyecto

```
onions/
├── docker-compose.yml    # Configuración de servicios Docker
├── Dockerfile           # Imagen Python con dependencias
├── onions_list.py       # Script principal
├── onions_list.ipynb    # Notebook original (referencia)
└── README.md           # Este archivo
```

## Uso

1. **Clonar o descargar el proyecto**

2. **Ejecutar con Docker Compose**:
   ```bash
   docker compose up --build -d
   ```

3. **Archivos generados**:
   - `onions_list.txt`
   - `onions_list.json`
   - `onions_results.csv`

## Cómo funciona

### Servicios Docker

- **tor**: Servicio Tor proxy usando la imagen `dperson/torproxy`
- **onions_script**: Contenedor Python que ejecuta el script de extracción

### Script Python

1. **Configuración de proxy**: Se conecta a Tor a través del puerto 9050
2. **Espera de inicialización**: Aguarda 10 segundos para que Tor esté listo
3. **Extracción de datos**: Realiza una petición HTTP a `https://ahmia.fi/onions`
4. **Procesamiento**: Usa regex para extraer direcciones .onion válidas
5. **Generación de archivos**: Crea archivos en formato TXT, JSON y CSV

### Regex utilizada

```python
r'\b(?:https?://)?[a-z0-9]{16,56}\.onion(?:\/[^\s<]*)?\b'
```

Esta expresión regular encuentra:
- Direcciones .onion v2 (16 caracteres) y v3 (56 caracteres)
- Con o sin prefijo `http://` o `https://`
- Con o sin rutas adicionales

## Resultados esperados

El script típicamente extrae aproximadamente **16.324 direcciones .onion** únicas de la base de datos de Ahmia.

## Logs de ejemplo

```
Esperando a que Tor esté listo...
Obteniendo https://ahmia.fi/onions a través de Tor...

--- HTML Content Sample ---
http://222222223bmct6m464moskwt5hxgz2hj2wbsh224oh4m3rfe6e7olhqd.onion/<br>
http://222222227nt67h4vw6y3a547k24kal6en5kvd3janyqmi4wmrvq4afid.onion/<br>
---------------------------

Encontradas 16324 direcciones .onion
Archivos generados: onions_list.txt, .json y onions_results.csv
```

## Solución de problemas

### Error "Connection refused"
- Asegúrate de que el servicio Tor esté corriendo
- Verifica que el puerto 9050 esté disponible

### Error "Name or service not known"
- Revisa la conectividad a internet
- Verifica que Docker tenga acceso a la red

### Archivos vacíos
- Comprueba que Ahmia.fi esté disponible
- Verifica que el regex esté capturando correctamente

## Seguridad

⚠️ **Importante**: Este proyecto es solo para fines educativos y de investigación en seguridad defensiva. El acceso a la red Tor y contenido .onion debe realizarse de manera responsable y conforme a las leyes locales.

## Migración desde Notebook

Este proyecto fue migrado desde un Jupyter Notebook original (`onions_list.ipynb`) a una implementación Docker para mayor portabilidad y reproducibilidad.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.