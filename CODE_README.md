# 代码说明文档

## 一、编译依赖

### 1、skia

- https://skia.org/user/build
- clone skia 源码

```
# 编译 arm64 版本
bin/gn gen out/arm64 --args='target_cpu="arm64" target_os="ios" is_official_build=true  is_debug=false skia_use_system_expat=false skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_zlib=true extra_cflags_cc=["-Wno-unused-result","-Wno-unused-variable"]'

ninja -C out/arm64

# 编译 x86_64 版本
bin/gn gen out/x86_64 --args='target_cpu="x64" target_os="ios" is_official_build=true  is_debug=false skia_use_system_expat=false skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_zlib=true extra_cflags_cc=["-Wno-unused-result","-Wno-unused-variable"]'

ninja -C out/x86_64

# 其它的省略
# 最后，合并 Thin Binaries 为 Fat Binaries
lipo -create arm64/libskia.a  x86_64/libskia.a -output libskia.a
```

### 2、ffmpeg 编译

- https://github.com/kewlbear/FFmpeg-iOS-build-script 
- https://github.com/kewlbear/FFmpeg-iOS-build-script/blob/master/build-ffmpeg.sh

#### 需要先编译 ffmpeg 依赖的库：

2.1、 libx264 编译 

- https://github.com/kewlbear/x264-ios

2.2、lib fdk aac 编译

- https://github.com/kewlbear/fdk-aac-build-script-for-iOS

2.3、 OpenSSL 编译

- https://github.com/x2on/OpenSSL-for-iPhone/blob/master/build-libssl.sh
- https://github.com/Bilibili/ijkplayer/blob/master/ios/compile-openssl.sh

### 4、libcurl 编译

- http://www.bugclosed.com/post/39

### 4、lib expat 直接使用源码

- https://github.com/x2on/expat-ios

### 6、glog 编译 有问题，iOS 端改用 miniglog

- https://github.com/tzutalin/miniglog

- https://github.com/google/glog

### 7、libyuv

- 直接使用已经编译好的
- https://github.com/wccw/libyuv-ios


### 8、添加依赖的 iOS 系统库

手动添加：

```
VideoToolbox.framework
CoreMedia.framework
AVFoundation.framework
AudioToolbox.framework
Accelerate.framework

libz.dylib
libbz2.dylib
libiconv.dylib
```
