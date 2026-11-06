# Práctica 8: Uso de Ansible para automatizar tareas en servidores

Se crean 5 servidores Ubuntu como contenedores de Docker y se configuran con Ansible.

## Archivos

| Archivo | Para qué sirve |
|---|---|
| `Dockerfile` | Imagen de Ubuntu con SSH y el usuario `ansible` (clave `ansible`, sudo sin password) |
| `docker-compose.yml` | Crea 5 servidores (`servidor1` a `servidor5`) con IPs fijas `172.28.0.11` a `172.28.0.15` |
| `inventario.ini` | Nombres, IPs, usuario y clave de los servidores |
| `inventario_puertos.ini` | Inventario alternativo por puertos (2201 a 2205), por si las IPs no se alcanzan |
| `ansible.cfg` | Usa el inventario y ignora la advertencia de SSH |
| `playbooks/` | Los playbooks de Ansible |

## Pasos

### 1. Levantar los servidores (necesita Docker)

```bash
docker compose up -d
docker compose ps
```

### 2. Instalar Ansible

En Windows, primero se instala WSL desde PowerShell como administrador y se reinicia:

```powershell
wsl --install
```

Dentro de Ubuntu (WSL):

```bash
sudo apt update
sudo apt install ansible sshpass -y
```

`sshpass` hace falta porque el inventario usa contraseña para entrar por SSH.

### 3. Probar la conexión

Trabaja desde una carpeta de Linux (por ejemplo `~/practica8`) y no desde `/mnt/c`, porque Ansible ignora el `ansible.cfg` en carpetas con permisos abiertos.

```bash
ansible all -m ping
```

Debe responder `pong` en los 5 servidores. Si no se alcanzan las IPs (pasa con Docker Desktop), usa el inventario alternativo:

```bash
ansible all -i inventario_puertos.ini -m ping
```

### 4. Ejecutar los playbooks

Uno por uno:

```bash
ansible-playbook playbooks/01-actualizar-apt.yml
ansible-playbook playbooks/02-crear-usuario-itla.yml
ansible-playbook playbooks/03-crear-carpeta-app.yml
ansible-playbook playbooks/04-crear-hola-txt.yml
ansible-playbook playbooks/05-instalar-apps.yml
```

O todos de una vez:

```bash
ansible-playbook playbooks/site.yml
```

### 5. Verificar

```bash
ansible all -m command -a "cat /home/itla/app/hola.txt"
ansible all -m command -a "/usr/games/cowsay Hola"
ansible all -m command -a "which htop"
```

## Qué hace cada playbook

1. `01-actualizar-apt.yml`: actualiza la caché de APT.
2. `02-crear-usuario-itla.yml`: crea el usuario `itla` en cada servidor.
3. `03-crear-carpeta-app.yml`: crea la carpeta `app` en `/home/itla/app`.
4. `04-crear-hola-txt.yml`: crea `hola.txt` dentro de la carpeta `app`.
5. `05-instalar-apps.yml`: instala `cowsay` y `htop`, y comprueba que cowsay funcione.

## Apagar todo

```bash
docker compose down
```
