### flyer-generator

Generador de flyers para estados de WhatsApp.  
Produce imágenes **1080×1920 px** a partir de un listado de locaciones y horarios,
calculando automáticamente la fecha del próximo primer sábado del mes.

## Requisitos

- Bash 4+
- [ImageMagick](https://imagemagick.org/) (`convert`)

```bash
# Debian (y derivados)
apt install imagemagick

# macOS
brew install imagemagick

# OpenBSD
pkg_add imagemagick
```

No requiere Python ni ninguna otra dependencia.

## Instalación

```bash
git clone git@github.com:jorgied/flyer-generator.git 
cd flyer-generator
chmod +x main.sh
```

## Uso

```bash
# Uso básico (usa locaciones.txt y fondo negro)
./main.sh

# Con imagen de fondo personalizada
./main.sh --fondo assets/mi-fondo.jpg

# Con otro archivo de locaciones
./main.sh --locaciones otra-lista.txt

# Especificando carpeta de salida
./main.sh --output ./imagenes/

# Combinado
./main.sh --fondo assets/fondo.jpg --locaciones lista.txt --output salida/
```

Los flyers se guardan en `output/flyer_01.png`, `output/flyer_02.png`, etc.

## Formato de `locaciones.txt`

Una locación por línea. Las líneas que empiezan con `#` son comentarios.

```
# Ejemplo
A las 16h frente a la catedral - Resistencia, Chaco
A las 8h en la plaza España, Reconquista
```

## Integrantes del equipo:
- Carlos Sabo (CS)
- Jorge Lencina (JL)

## Estructura del proyecto:

- readme (JL)
- main.sh (CS)
- lib/
  * dates (CS)
  * parser (JL)
  * images (CS)
- locations (CS)

//TODO: Armar banco de imágenes para los fondos y crear unas pruebas.
