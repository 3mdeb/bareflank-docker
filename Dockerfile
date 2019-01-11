FROM ubuntu:18.04

RUN  \
	useradd -p locked -m bareflank && \
	apt-get -qq update && \
	apt-get -qqy install \
	git \
	build-essential \
	cmake \
	cmake-curses-gui \
	nasm \
	clang \
	libelf-dev \
	vim \
	&& \
	apt-get clean

USER bareflank
