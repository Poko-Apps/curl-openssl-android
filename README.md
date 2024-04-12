# Curl & OpenSSL Builds for Android
This GitHub Action compiles the latest OpenSSL source and the latest Curl source as a static library for Android native (C/C++) development.

## ABIs We Build (Currently)
* [x] armeabi-v7a
* [x] arm64-v8a
* [x] x86
* [x] x86_64

## Notes
* Curl is built with SSL/TLS support.
* Curl builds do not include zlib support.

## Download
Downloads are available in the release section. Release names and tags follow this format: {curl_version-openssl_version}.

## Thanks
* [217heidai](https://github.com/217heidai/openssl_for_android)
* [liaokun](https://zhuanlan.zhihu.com/p/614298413?utm_id=0)
