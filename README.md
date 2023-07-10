# bcftools-static 🧬⚡

Fully static bcftools binary using alpine linux docker containers. The script [build.sh](build.sh) is very simple, in case you need to tweak/see how it's built (and/or suggest or PR).

Executables are available in the [releases](https://github.com/mliezun/bcftools-static/releases) section.

Static binaries are compiled with the following dependencies:

- htslib 1.17
- curl 8.1.2
- openssl 3.1.1
- libssh2 1.10.0
- nghttp2 1.53.0
- xz 5.4.3
- zlib 1.2.13
- bzip2 1.0.8

## Usage

The intention of this project is to provide rapid access to multiple versions of bcftools.

Download it with the following commands:

```bash
VERSION=1.17
TARGET=x86_64-linux
wget https://github.com/mliezun/bcftools-static/releases/download/v${VERSION}/bcftools-${VERSION}-${TARGET}
chmod +x bcftools-*
./bcftools-${VERSION}-${TARGET}
```
