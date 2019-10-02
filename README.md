# ![dnscrypt-proxy 2](https://raw.github.com/jedisct1/dnscrypt-proxy/master/logo.png?3)

## DNSCrypt Proxy 2 for Android
A flexible DNS proxy, with support for modern encrypted DNS protocols such as [DNSCrypt v2](https://github.com/DNSCrypt/dnscrypt-protocol/blob/master/DNSCRYPT-V2-PROTOCOL.txt) and [DNS-over-HTTP/2](https://tools.ietf.org/html/draft-ietf-doh-dns-over-https-03).
- [![Chinese](https://img.shields.io/badge/-%E4%B8%AD%E6%96%87-blue.svg?style=for-the-badge&logo=github)](./README_CN.md)
## Features
- arm, arm64, x86 and x86_64 are supported.
- ipv4 and ipv6 are supported.
- Core binary files are downloaded from [https://github.com/jedisct1/dnscrypt-proxy/releases](https://github.com/jedisct1/dnscrypt-proxy/releases)

## Installation
### Need [Magisk](https://github.com/topjohnwu/Magisk/release)
- [![Releases](https://img.shields.io/github/release/x4455/dnscrypt-proxy.svg?label=Latest%20Release&style=popout)](https://github.com/x4455/dnscrypt-proxy/releases/latest)
- Flash in Magisk Manager or Recovery and follow the instructions.

## Installation options
### Automatic mode
Just flash and forget.
- Control script
 Usage: dnsproxy [string]
 Common command: `-start` `-stop` `-usage`

## Configuration (post-installing)
- Main config, located on `/data/media/0/dnscrypt-proxy`
- Script config, located on `/data/adb/modules/dnscrypt-proxy/constant.sh`
- For more detailed configuration please refer to [official documentation](https://github.com/jedisct1/dnscrypt-proxy/wiki/Configuration) Or use [other presets](https://github.com/jedisct1/dnscrypt-proxy/wiki/Public-blacklists)

## ChangeLog
- [Core ChangeLog](https://github.com/jedisct1/dnscrypt-proxy/blob/master/ChangeLog)
### v2.9.0
- Updated binary & configuration files to 2.0.27
- Update control script
### v2.7.5
- Manual mode removed
- Update Core binary files to 2.0.23
- Update control script
- Adaptation Magisk v19
### v2.6.1
- Update Core binary files to 2.0.19
- Add control script

## Credit
- DNSCrypt-Proxy2 upstream | [jedisct1](https://github.com/jedisct1/dnscrypt-proxy)
- Keycheck binary | [sonyxperiadev](https://github.com/sonyxperiadev/device-sony-common-init/tree/master/keycheck) compiled by [Zackptg5](https://github.com/Zackptg5/Keycheck)
- Idea for keycheck code implementation | [Zappo @xda-developers](https://forum.xda-developers.com/showpost.php?p=71016567&postcount=98)
