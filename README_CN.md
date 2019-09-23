# ![dnscrypt-proxy 2](https://raw.github.com/jedisct1/dnscrypt-proxy/master/logo.png?3)

## DNSCrypt Proxy 2 for Android
灵活的 DNS 代理，支持加密 DNS 协议，如 [DNSCrypt-v2](https://github.com/DNSCrypt/dnscrypt-protocol/blob/master/DNSCRYPT-V2-PROTOCOL.txt) 和 [DNS-over-HTTP/2](https://tools.ietf.org/html/draft-ietf-doh-dns-over-https-03).
- [![English](https://img.shields.io/badge/-English-brightgreen.svg?style=for-the-badge&logo=github)](./README.md)
## 特性
- 支持 arm, arm64, x86 和 x86_64 设备
- 支持 ipv4 和 ipv6
- Core binary 文件来自于 [jedisct1/dnscrypt-proxy](https://github.com/jedisct1/dnscrypt-proxy/releases)

## 安装
### 需要 [Magisk](https://github.com/topjohnwu/Magisk/release)
- [![Releases](https://img.shields.io/github/release/x4455/dnscrypt-proxy.svg?label=%E6%9C%80%E6%96%B0%E7%89%88%E6%9C%AC&style=popout)](https://github.com/x4455/dnscrypt-proxy/releases/latest)
- 在 Magisk Manager 或 Recovery 中刷入并按照说明操作。

## 安装选项
### 自动模式
刷入，然后你就可以忘了它了
- 控制脚本
 用法: dnsproxy [string]
 常用命令: `-start` `-stop` `-usage`

## 配置 (安装后)
- 主配置，存储于 `/data/media/dnscrypt-proxy`
- 脚本配置，储存于 `/data/adb/modules/dnscrypt-proxy/constant.sh`
- 有关更详细的配置，请参阅[官方文档](https://github.com/jedisct1/dnscrypt-proxy/wiki/Configuration)或使用[其他预设](https://github.com/jedisct1/dnscrypt-proxy/wiki/Public-blacklists)

## 更新日志
- [Core 更新日志](https://github.com/jedisct1/dnscrypt-proxy/blob/master/ChangeLog)
### v2.9.0
- 将二进制文件和示例配置更新为 2.0.27
- 更新控制脚本
### v2.7.5
- 移除手动模式
- 将二进制文件更新为 2.0.23
- 更新控制脚本
- 适配 Magisk v19
### v2.6.1
- 将二进制文件更新为 2.0.19
- 添加控制脚本

## 感谢
- DNSCrypt-Proxy2 upstream | [jedisct1](https://github.com/jedisct1/dnscrypt-proxy)
- Keycheck binary | [sonyxperiadev](https://github.com/sonyxperiadev/device-sony-common-init/tree/master/keycheck) compiled by [Zackptg5](https://github.com/Zackptg5/Keycheck)
- Idea for keycheck code implementation | [Zappo @xda-developers](https://forum.xda-developers.com/showpost.php?p=71016567&postcount=98)
