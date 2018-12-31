# docker-bareflank

Image can be build from directory containing `Dockerfile` with:

```
docker build -t bareflank-uefi .
```

This is one time operation. It is required only to build image for the first
time or when any changes to the image were made. Image contains all necessary
tools to build Bareflank for UEFI.

Next, instructions from [Bareflank README](https://github.com/Bareflank/hypervisor)
or [YoutTube video](https://www.youtube.com/watch?v=FuEyjDqA53M) need to be
followed in the container:

1. Start Docker container

Make and enter a working directory before running following command:

```
docker run --rm -it -v $PWD:/home/bareflank/bareflank -w /home/bareflank/bareflank bareflank-uefi /bin/bash
```

> You can also bind mount another directories or files. A common option for
> developers is to mount `.ssh` directory for easier repository operations:
> `-v /home/<host_username>/.ssh:/home/bareflank/.ssh`

2. Clone both hypervisor and extended_apis

```
git clone https://github.com/Bareflank/hypervisor.git
git clone https://github.com/Bareflank/extended_apis.git
```

3. Prepare config file for CMake

```
cp hypervisor/scripts/cmake/config/example_config.cmake config.cmake
vi config.cmake
```

Change both `set(ENABLE_EXTENDED_APIS OFF)` and `set(ENABLE_BUILD_EFI OFF)` to
`ON`. Uncomment and change names in the `Override VMM` section - change this:

```
# set(OVERRIDE_VMM <name>)
# set(OVERRIDE_VMM_TARGET <name>)
```

to this:

```
set(OVERRIDE_VMM eapis_integration_intel_x64_efi_test_efi)
set(OVERRIDE_VMM_TARGET eapis_integration)
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
