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
- 文明上网时须把 DNS 设置为使用非53端口查询(例如 `127.0.0.1:5354` )或使用 `1.1.1.1:53`
- 控制脚本
 用法: dnsproxy {string}
 常用命令: `-start` `-stop` `-help`
### 手动模式
- 对于ipv4，DNS 服务器地址为 `127.0.0.1:53`，对于ipv6，DNS 服务器地址为 `[::1]:53`
- 如果您使用 [AfWall](https://github.com/ukanth/afwall/releases) ，则可以编写此自定义脚本
  开启脚本
  ```
  iptables -t nat -A OUTPUT -p tcp ! -d 1.1.1.1 --dport 53 -j DNAT --to-destination 127.0.0.1:53
  iptables -t nat -A OUTPUT -p udp ! -d 1.1.1.1 --dport 53 -j DNAT --to-destination 127.0.0.1:53
  ip6tables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination [::1]:53
  ip6tables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination [::1]:53
  ```
  关闭脚本
  ```
  iptables -t nat -D OUTPUT -p tcp ! -d 1.1.1.1 --dport 53 -j DNAT --to-destination 127.0.0.1:53
  iptables -t nat -D OUTPUT -p udp ! -d 1.1.1.1 --dport 53 -j DNAT --to-destination 127.0.0.1:53
  ip6tables -t nat -D OUTPUT -p tcp --dport 53 -j DNAT --to-destination [::1]:53
  ip6tables -t nat -D OUTPUT -p udp --dport 53 -j DNAT --to-destination [::1]:53
  ```

## 配置 (安装后)
- 默认配置，存储于 `/data/media/dnscrypt-proxy` ，你可以对其进行调整
- 有关更详细的配置，请参阅[官方文档](https://github.com/jedisct1/dnscrypt-proxy/wiki/Configuration)或使用[其他预设](https://github.com/jedisct1/dnscrypt-proxy/wiki/Public-blacklists)

[CNMan/dnscrypt-proxy-config](https://github.com/CNMan/dnscrypt-proxy-config) 针对中国用户的广泛且不断更新的黑名单，转发和隐藏规则
由 [CNMan](https://github.com/CNMan) 维护

## 更新日志
- [Core 更新日志](https://github.com/jedisct1/dnscrypt-proxy/blob/master/ChangeLog)
### v2.7.3
- 将二进制文件更新为 2.0.22
- 更新示例配置
- 适配 Magisk v19
- 更新控制脚本
### v2.6.1
- 将二进制文件更新为 2.0.19
- 添加控制脚本

## 感谢
- DNSCrypt-Proxy2 upstream | [jedisct1](https://github.com/jedisct1/dnscrypt-proxy)
- Keycheck binary | [sonyxperiadev](https://github.com/sonyxperiadev/device-sony-common-init/tree/master/keycheck) compiled by [Zackptg5](https://github.com/Zackptg5/Keycheck)
- Idea for keycheck code implementation | [Zappo @xda-developers](https://forum.xda-developers.com/showpost.php?p=71016567&postcount=98)
