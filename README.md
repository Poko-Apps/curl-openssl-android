# Curl & OpenSSL Builds for Android
This GitHub Action compiles the latest OpenSSL source and the latest Curl source as a static library for Android native (C/C++) development.

## ABIs We Build
* [x] armeabi-v7a
* [x] arm64-v8a
* [x] x86
* [x] x86_64

## Notes
* Curl is built with SSL/TLS support.
* Curl builds do not include zlib support.
* Minimum API set to 21 both for Curl and OpenSSL

## Download
Downloads are available in the release section. Release names and tags follow this format:

<b>{curlVersion-opensslVersion}</b>.

## Thanks
* [217heidai](https://github.com/217heidai/openssl_for_android)
* [liaokun](https://zhuanlan.zhihu.com/p/614298413?utm_id=0)