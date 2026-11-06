# Imagen de Ubuntu con servidor SSH y el usuario "ansible"
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# SSH, sudo y Python (Ansible necesita Python en los servidores)
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server sudo python3 && \
    rm -rf /var/lib/apt/lists/*

# Carpeta que necesita sshd para funcionar
RUN mkdir -p /var/run/sshd

# Usuario ansible con clave "ansible" y sudo sin password
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd && \
    echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible && \
    chmod 0440 /etc/sudoers.d/ansible

# Permitir inicio de sesión por contraseña
RUN sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE 22

# sshd en primer plano para que el contenedor siga activo
CMD ["/usr/sbin/sshd", "-D"]
