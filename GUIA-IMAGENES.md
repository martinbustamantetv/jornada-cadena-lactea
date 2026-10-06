# Guía de imágenes — qué es cada archivo

Reemplazá los archivos dentro de `assets/` **manteniendo el nombre y la extensión exactos**.
Después recargá con Ctrl+Shift+R (Cmd+Shift+R en Mac) para saltear el caché.
Trabajá siempre sobre `index.html`, no sobre `jornada-preview.html`.

---

## Fotos y logo del evento

- **hero.jpg** — Fondo del inicio (se ve mientras no haya video). 1700 px de ancho.
- **stands.jpg** — Tarjeta 1 “Stands”, sección Qué vas a encontrar.
- **aerea.jpg** — Tarjeta 2 “Aportes tecnológicos”.
- **auditorio.jpg** — Tarjeta 3 “Disertantes calificados”.
- **tambo.jpg** — Fondo de la sección Epicentro (va con multiply sobre el azul).
- **tractor.jpg** — Fondo de la sección de marcas.
- **logo-vaca.png** — Vaca sola: barra superior y galería.
- **logo-blanco.png** — Logo completo con texto blanco: pie de página y galería.
- **logo-celeste.png / logo-verde.png / logo-azul.png / logo-texto-blanco.png** — Capas del logo que se ensamblan en la animación del inicio. No conviene tocarlas por separado.
- **favicon.ico / favicon-32.png / favicon-180.png / favicon-192.png / favicon-512.png** — Íconos de pestaña y de pantalla de inicio (cabeza de la vaca).
- **programa-jornada-cadena-lactea.pdf** — PDF del botón “Descargar programa”.

---

## El arco de la portada (sección "Ediciones anteriores")

Las fotos verticales que forman el arco en 3D de la landing van en:

```
assets/arco/01.jpg  02.jpg  03.jpg  04.jpg  05.jpg  06.jpg  07.jpg
```

Son **siete**, **verticales**, y se recomienda **600 × 860 px** (proporción 3:4,3).
Se ven recortadas a esa proporción, así que dejá el motivo centrado. El orden es
el del número: la `04` queda justo en el medio del arco y las `01` y `07` en las
puntas.

Si querés otra cantidad, en `index.html` hay una línea `const ARCO=[...]` con la
lista: sacás o agregás nombres y el arco se reacomoda solo, siempre simétrico. Si
alguno de los archivos no está, esa tarjeta se saltea sin romper nada. En pantallas
medianas se muestran 5 y en teléfono 3, siempre las del centro.

---

## Fotos de la galería (`galeria.html`)

Cada día tiene su carpeta, con las fotos en dos tamaños y un archivo índice:

```
assets/galeria/
└── 2026/
    ├── d1/                      ← martes 29
    │   ├── g/   las fotos en calidad  (visor + botón de descargar)
    │   ├── m/   las miniaturas        (la grilla)
    │   └── fotos.txt   o   fotos.json
    └── d2/                      ← miércoles 30 (este año no hubo fotos)
```

Lo único obligatorio: **el nombre del archivo tiene que ser el mismo en `g` y en
`m`**. Fuera de eso el nombre no importa — se puede llamar como salga de la
cámara. Si falta la miniatura, esa foto se muestra con la versión grande; si
falta la grande, el visor y la descarga usan la miniatura; y si una foto del
índice no está en ninguna de las dos, se saltea sin romper nada.

Para las miniaturas, lado largo de **900 px** anda bien: son las que carga la
grilla, así que cuanto más livianas, más rápido entra la gente.

### Preparar un día: `renombrar.ps1`

Está en `assets/galeria/renombrar.ps1` (y `renombrar.sh` para Mac o Linux).

1. Copiá `renombrar.ps1` adentro de la carpeta del día (la que tiene `g` y `m`).
2. Click derecho sobre el archivo → **Ejecutar con PowerShell**.
   Si Windows no te deja, abrí PowerShell ahí y pegá:
   `powershell -ExecutionPolicy Bypass -File .\renombrar.ps1`

Antes de tocar nada muestra qué encontró en cada carpeta, cómo va a emparejar y
cómo van a quedar las tres primeras, y espera que confirmes. Para verlo sin que
renombre nada:

```
powershell -ExecutionPolicy Bypass -File .\renombrar.ps1 -Revisar
```

Qué hace:

- Renombra todo a `JORNADA CADENA LACTEA-001.jpg`, `-002.jpg`, …: `g\JORNADA CADENA LACTEA-001.jpg, -002.jpg, …` y lo mismo en `m`, con
  **el mismo número para la misma foto**. Empareja primero por nombre; si los
  nombres de `m` no coinciden con los de `g` pero hay la misma cantidad en las
  dos carpetas, empareja por orden. No renombra nada hasta tener resuelto el
  emparejado de las dos, así nunca queda `g` numerada y `m` sin numerar.
- Respeta el orden actual de los nombres, con orden natural: `IMG_2` va antes que
  `IMG_10`, no después.
- Deja un `fotos.json` con la lista, que es lo que lee la galería.
- Deja un `nombres-originales.txt` con la equivalencia, por si alguna vez querés
  volver atrás.
- Te avisa si alguna foto de `g` se quedó sin miniatura en `m`.

Se puede correr las veces que haga falta: si agregás o sacás fotos, lo volvés a
correr y renumera todo de nuevo. `galeria.html` no se toca nunca.

### Si preferís no renombrar

No es obligatorio. La galería también acepta:

- Un **`fotos.txt`** en la carpeta del día, un nombre por línea (las líneas que
  empiezan con `#` se ignoran). En Windows sale con `dir /b /on m\*.jpg > fotos.txt`
  desde la carpeta del día; en Mac o Linux, `ls m/*.jpg | xargs -n1 basename > fotos.txt`.
- Un **`fotos.json`**: una lista de nombres `["DSC_0001.jpg", "DSC_0002.jpg"]`, o
  con las medidas `[["DSC_0001.jpg", 4000, 2667], …]` si querés que la grilla se
  arme de una sola vez sin ir midiendo.
- **Nada**: sólo si las fotos están numeradas `0001.jpg, 0002.jpg…` la galería las
  encuentra sola, tanteando. Anda bien, pero deja unos 404 en la consola del
  navegador mientras busca dónde termina la numeración — por eso el script deja
  el `fotos.json`, que resuelve todo en una sola consulta.

En los tres casos el orden del archivo es el orden que se ve. Un navegador **no
puede ver qué hay adentro de una carpeta** — ni en GitHub Pages ni en ningún
servidor —, por eso hace falta la lista o la numeración.

### Sumar una edición

En `galeria.html`, al principio del `<script>`, está el bloque `EDICIONES`: sólo
los datos de cada edición (año, fechas, lugar y los días), sin ninguna lista de
fotos. Para sumar una edición se copia el bloque de 2026, se cambia el año y las
fechas, y se deja al lado la carpeta `assets/galeria/<año>/`: la portada y las
pestañas se arman solas. Un día sin fotos se marca con `disponible:false` y queda
a la vista pero apagado, como el miércoles 30.

---

## Retratos de disertantes

Cuadrados, se recomiendan 760×760 px o más, en `.jpg`.

- **d-albino.jpg** — Abel Albino
- **d-alconada.jpg** — Sebastián Alconada
- **d-ceaglio.jpg** — Gonzalo Ceaglio
- **d-distefano.jpg** — Salvador Di Stefano
- **d-gorgerino.jpg** — Mauro Gorgerino *(hoy sin foto propia)*
- **d-larenze.jpg** — Ignacio Larenze
- **d-lus.jpg** — Juan Lus
- **d-maiztegui.jpg** — José Maiztegui
- **d-pineiro.jpg** — Guillermo Piñeiro
- **d-reynals.jpg** — Victoria Reynals
- **d-riffel.jpg** — Sebastián Riffel
- **d-rolandelli.jpg** — Alexia Rolandelli
- **d-sagardoy.jpg** — Rolando Luis Sagardoy
- **d-siri.jpg** — Pablo Siri
- **d-sorenson.jpg** — Federico Sörenson
- **d-urrets.jpg** — Gastón Urrets Zavalía
- *Faltan*: Ronald Lombardi, Leo Cortese y Tomás Vera (esas charlas muestran el placeholder).

---

## Logos de marcas

Cada marca tiene **dos archivos** y hay que reemplazar los dos:

- `m-<marca>.png` — versión a color, se usa sobre fondo claro (tarjeta del stand).
- `w-<marca>.png` — versión blanca calada, se usa sobre el azul (cinta de marcas, auspiciantes, pie).

Los dos son lienzos de 640×250 px con el logo centrado y escalado para que todos pesen 
ópticamente lo mismo. Si ponés el logo crudo se va a ver de otro tamaño que el resto: 
mejor pasámelo y lo normalizo.

- **m-agronorte.png / w-agronorte.png** — Agronorte · John Deere
- **m-agrotambo.png / w-agrotambo.png** — Agrotambo · DeLaval
- **m-bemix.png / w-bemix.png** — Bemix
- **m-bess.png / w-bess.png** — BESS
- **m-biosolares.png / w-biosolares.png** — BioSolares
- **m-cau-siglo21.png / w-cau-siglo21.png** — CAU Crespo · Siglo 21
- **m-cotapa.png / w-cotapa.png** — Cotapa
- **m-cremigal.png / w-cremigal.png** — Cremigal
- **m-fliegl.png / w-fliegl.png** — Fliegl · Fliegl Argentina
- **m-folmer.png / w-folmer.png** — Folmer
- **m-gauss.png / w-gauss.png** — Gauss
- **m-guemes.png / w-guemes.png** — Metalúrgica Güemes
- **m-heit.png / w-heit.png** — HEIT · BioGrow
- **m-indalac.png / w-indalac.png** — Indalac
- **m-jacob.png / w-jacob.png** — Jacob Maquinarias
- **m-la-ganadera.png / w-la-ganadera.png** — La Ganadera
- **m-la-sibila.png / w-la-sibila.png** — La Sibila
- **m-lar.png / w-lar.png** — LAR
- **m-lec-fri.png / w-lec-fri.png** — LEC-FRI
- **m-lely.png / w-lely.png** — Lely
- **m-magno.png / w-magno.png** — Magna
- **m-mb-maquinarias.png / w-mb-maquinarias.png** — MB Maquinarias · Traxor
- **m-nutriar.png / w-nutriar.png** — Nutrifar
- **m-pauer.png / w-pauer.png** — Pauer
- **m-peon.png / w-peon.png** — Peón Electrocercas
- **m-porta.png / w-porta.png** — Porta
- **m-santa-sylvina.png / w-santa-sylvina.png** — Santa Sylvina
- **m-stel.png / w-stel.png** — Stel Grupo
- **m-suplefeed.png / w-suplefeed.png** — Suplefeed · FutureCow
- **m-tonutti.png / w-tonutti.png** — Tonutti
- **m-trossero.png / w-trossero.png** — Trossero · BouMatic
- **m-tsc.png / w-tsc.png** — TSC Agroindustriales
- **m-vet-hernandez.png / w-vet-hernandez.png** — Veterinaria Hernández
- **m-weinbaur.png / w-weinbaur.png** — Weinbaur · Massey Ferguson