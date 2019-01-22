Docker container for Bareflank builds
-------------------------------------

[![Build Status](https://travis-ci.com/3mdeb/bareflank-docker.svg?branch=master)](https://travis-ci.com/3mdeb/yocto-docker)

Usage
-----

Next, instructions from [Bareflank README](https://github.com/Bareflank/hypervisor)
or [YoutTube video](https://www.youtube.com/watch?v=FuEyjDqA53M) need to be
followed in the container:

1. Start Docker container

Make and enter a working directory before running following command:

```
docker run --rm -it -v $PWD:/home/bareflank/bareflank -w /home/bareflank/bareflank \
3mdeb/bareflank-docker /bin/bash
```

> You can also bind mount another directories or files. A common option for
> developers is to mount `.ssh` directory for easier repository operations:
> `-v /home/<host_username>/.ssh:/home/bareflank/.ssh`

2. Clone both hypervisor and extended_apis

Procedure was tested with version `ba613e2c687f` of Bareflank, other versions may or
may not work, there may be some differences in code from different revisions.

```
git clone https://github.com/Bareflank/hypervisor.git
cd hypervisor
git checkout ba613e2c687f
```

3. Prepare config file for CMake

```
cd ..
cp hypervisor/scripts/cmake/config/example_config.cmake config.cmake
vi config.cmake
```

Change `set(ENABLE_BUILD_EFI OFF)` to `ON`. Uncomment and change names in the
`Override VMM` section - change this:

```
# set(OVERRIDE_VMM <name>)
# set(OVERRIDE_VMM_TARGET <name>)
```

to this:

```
set(OVERRIDE_VMM integration_intel_x64_efi_test_efi)
set(OVERRIDE_VMM_TARGET integration)
```

> These names were taken from `extended_apis/bfvmm/integration/arch/intel_x64/efi/CMakeLists.txt`

4. Prepare build directory and build

```
mkdir build
cd build
cmake ../hypervisor
make -j<# cores + 1>
```

Resulting file is located in `build/efi/x86_64-efi-pe/build`.

Building Docker image
---------------------

Image can be build from directory containing `Dockerfile` with:

```
docker build -t 3mdeb/bareflank-docker .
```

This is one time operation. It is required only to build image for the first
time or when any changes to the image were made. Image contains all necessary
tools to build Bareflank for UEFI.
