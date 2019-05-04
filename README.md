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
 Usage: dnsproxy {string}
 Common command: `-start` `-stop` `-help`
### Manual mode
- DNS server address is `127.0.0.1:53` for ipv4 and `[::1]:53` for ipv6
- If you use [AfWall](https://github.com/ukanth/afwall/releases), you can write this enter custom script
  ```
  iptables -t nat -A OUTPUT -p tcp ! -d 9.9.9.9 --dport 53 -j DNAT --to-destination 127.0.0.1:53
  iptables -t nat -A OUTPUT -p udp ! -d 9.9.9.9 --dport 53 -j DNAT --to-destination 127.0.0.1:53
  ip6tables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination [::1]:53
  ip6tables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination [::1]:53
  ```
  and this shutdown script
  ```
  iptables -t nat -D OUTPUT -p tcp ! -d 9.9.9.9 --dport 53 -j DNAT --to-destination 127.0.0.1:53
  iptables -t nat -D OUTPUT -p udp ! -d 9.9.9.9 --dport 53 -j DNAT --to-destination 127.0.0.1:53
  ip6tables -t nat -D OUTPUT -p tcp --dport 53 -j DNAT --to-destination [::1]:53
  ip6tables -t nat -D OUTPUT -p udp --dport 53 -j DNAT --to-destination [::1]:53
  ```

## Configuration (post-installing)
- Default configuration, located on `/data/media/dnscrypt-proxy`
- For more detailed configuration please refer to [official documentation](https://github.com/jedisct1/dnscrypt-proxy/wiki/Configuration) Or use [other presets](https://github.com/jedisct1/dnscrypt-proxy/wiki/Public-blacklists)

## ChangeLog
- [Core ChangeLog](https://github.com/jedisct1/dnscrypt-proxy/blob/master/ChangeLog)
### v2.7.4
- Update Core binary files to 2.0.23
### v2.7.3
- Update Core binary files to 2.0.22
- Update example configuration
- Adaptation Magisk v19
- Update control script
### v2.6.1
- Update Core binary files to 2.0.19
- Add control script

## Credit
- DNSCrypt-Proxy2 upstream | [jedisct1](https://github.com/jedisct1/dnscrypt-proxy)
- Keycheck binary | [sonyxperiadev](https://github.com/sonyxperiadev/device-sony-common-init/tree/master/keycheck) compiled by [Zackptg5](https://github.com/Zackptg5/Keycheck)
- Idea for keycheck code implementation | [Zappo @xda-developers](https://forum.xda-developers.com/showpost.php?p=71016567&postcount=98)
