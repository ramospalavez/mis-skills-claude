#!/usr/bin/env python3
"""
Convierte un manual HTML (generado con assets/template.html) a PDF.

Uso:
    python3 html_to_pdf.py manual-usuario.html manual-usuario.pdf

Requiere weasyprint:
    pip install weasyprint --break-system-packages

Notas:
- El PDF oculta el sidebar automáticamente (regla @media print en el template)
  y evita cortar pasos o secciones a la mitad de la página.
- Las imágenes deben estar embebidas como base64 (data:image/...) o como
  rutas locales junto al HTML — weasyprint no puede resolver imágenes remotas
  que requieran autenticación.
"""
import sys
from pathlib import Path


def convert(html_path: str, pdf_path: str) -> None:
    from weasyprint import HTML

    html_path = Path(html_path).resolve()
    if not html_path.exists():
        raise FileNotFoundError(f"No se encontró el HTML: {html_path}")

    HTML(filename=str(html_path), base_url=str(html_path.parent)).write_pdf(pdf_path)
    print(f"PDF generado: {pdf_path}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Uso: python3 html_to_pdf.py <entrada.html> <salida.pdf>")
        sys.exit(1)
    convert(sys.argv[1], sys.argv[2])
