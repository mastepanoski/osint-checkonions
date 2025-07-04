import requests
from bs4 import BeautifulSoup
import json
import csv
import re
import time

# Proxy para Tor
proxies = {
    'http': 'socks5h://tor:9050',
    'https': 'socks5h://tor:9050'
}

ahmia_url = 'https://ahmia.fi/onions'

# Wait for Tor to be ready
print("Esperando a que Tor esté listo...")
time.sleep(10)  # Wait 10 seconds for Tor to bootstrap

try:
    # Hacemos la petición a través de Tor
    print(f"Obteniendo {ahmia_url} a través de Tor...")
    response = requests.get(ahmia_url, proxies=proxies, timeout=60)
    response.raise_for_status()

    # Add this line to inspect the HTML content
    print("\n--- HTML Content Sample ---")
    print(response.text[:1000])
    print("---------------------------\n")

    # Extraemos todos los enlaces .onion usando regex
    onions = set()
    # Regex to find v3 onion addresses, optionally followed by a path
    onion_pattern = re.compile(r'\b(?:https?://)?[a-z0-9]{16,56}\.onion(?:\/[^\s<]*)?\b')

    # Find all matches in the response text
    found_onions = onion_pattern.findall(response.text)

    for onion_url in found_onions:
        # Basic cleaning: remove trailing slashes if present and ensure http:// prefix
        clean_url = onion_url.strip()
        if not clean_url.startswith('http'):
             clean_url = 'http://' + clean_url
        # Remove trailing slash if it's just the root directory
        if clean_url.endswith('/') and len(clean_url) > len('http://') + 56 + 7:
            clean_url = clean_url.rstrip('/')

        onions.add(clean_url)

    print(f"Encontradas {len(onions)} direcciones .onion")

    # Guardar en TXT
    with open('onions_list.txt', 'w') as f:
        for onion in sorted(onions):
            f.write(onion + '\n')

    # Guardar en JSON
    with open('onions_list.json', 'w', encoding='utf-8') as f:
        json.dump(sorted(list(onions)), f, ensure_ascii=False, indent=2)

    # Guardar en CSV (mantener el formato original para compatibilidad)
    with open('onions_results.csv', 'w', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(['onion_url'])
        for onion in sorted(onions):
            writer.writerow([onion])

    print("Archivos generados: onions_list.txt, .json y onions_results.csv")

except requests.exceptions.ConnectionError as e:
    print(f"Error al conectar con el proxy o el servidor: {e}")
    print("Por favor, asegúrate de que el servicio Tor esté funcionando y sea accesible en tor:9050.")
except requests.exceptions.Timeout as e:
    print(f"Tiempo de espera agotado al conectar a {ahmia_url} a través del proxy: {e}")
except requests.exceptions.RequestException as e:
    print(f"Ocurrió un error durante la petición: {e}")
except Exception as e:
    print(f"Ocurrió un error inesperado: {e}")