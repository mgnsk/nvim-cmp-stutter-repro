FROM archlinux:latest AS toolbox-base

RUN pacman -Syy --noconfirm \
	&& pacman -S --noconfirm --needed \
    neovim \
    git \
    go \
    gopls

ARG uid
ARG gid
ARG user
ARG group

RUN if grep -q "${group}:" /etc/group; then \
	groupmod -o -g ${gid} ${group}; \
	else \
	groupadd -f -g ${gid} ${group}; \
	fi \
	&& useradd \
	-m \
	-s /usr/bin/fish \
	-g ${group} \
	--uid ${uid} \
	${user}

USER ${user}

RUN mkdir -p /home/${user}/.config/nvim \
	/home/${user}/.local/share/nvim/lazy \
	/home/${user}/workspace

WORKDIR /home/${user}/workspace

RUN git clone --depth=1 https://github.com/grpc/grpc-go.git
