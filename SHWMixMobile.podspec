#
# Be sure to run `pod lib lint SHWMixMobile.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SHWMixMobile'
  s.version          = '0.1.0'
  s.summary          = '新华智云 mix 引擎 iOS 端.'
  s.description      = <<-DESC
                        mix: 随心所欲的视频编辑引擎,新华智云 mix 引擎 iOS 端
                        DESC
  s.homepage         = 'https://code.aliyun.com/xhzy-frontend/mix-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yehot' => 'yehao@shuwen.com' }
  s.source           = { :git => 'https://code.aliyun.com/xhzy-frontend/mix-ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'

  s.subspec 'x264' do |ss|
    ss.source_files        = 'SHWMixMobile/mix/x264/include/**/*.h'
    ss.header_mappings_dir = 'SHWMixMobile/mix/x264/include'
    ss.vendored_libraries  = 'SHWMixMobile/mix/x264/lib/*.a'
  end

  s.subspec 'libyuv' do |ss|
    ss.source_files        = 'SHWMixMobile/mix/libyuv/include/**/*.h'
    ss.vendored_libraries  = 'SHWMixMobile/mix/libyuv/lib/*.a'
    ss.header_mappings_dir = 'SHWMixMobile/mix/libyuv/include'
  end

  s.subspec 'fdk-aac' do |ss|
    ss.source_files        = 'SHWMixMobile/mix/fdk-aac/include/**/*.h'
    ss.vendored_libraries  = 'SHWMixMobile/mix/fdk-aac/lib/*.a'
    ss.header_mappings_dir = 'SHWMixMobile/mix/fdk-aac/include'
  end

   s.subspec 'libheif' do |ss|
     ss.source_files        = 'SHWMixMobile/mix/libheif/**/*.h'
     ss.vendored_libraries  = 'SHWMixMobile/mix/libheif/*.a'
   end

#  s.subspec 'glog' do |ss|
#    ss.source_files        = 'SHWMixMobile/mix/glog/**/*.{h,cc}'
#    ss.header_mappings_dir = 'SHWMixMobile/mix/glog/include'
#    ss.public_header_files = 'SHWMixMobile/mix/glog/include/*.h'
#  end

#   s.subspec 'expat' do |ss|
#     ss.source_files        = 'SHWMixMobile/mix/expat/**/*{.h,.c}'
#     ss.header_mappings_dir = 'SHWMixMobile/mix/expat/include'
#     ss.public_header_files = 'SHWMixMobile/mix/expat/include'
#   end

   s.subspec 'Skia' do |ss|
    ss.source_files        =  'SHWMixMobile/mix/Skia/include/**/*.h',
                              'SHWMixMobile/mix/Skia/third_party/**/*.h'
    ss.vendored_libraries  =  'SHWMixMobile/mix/Skia/lib/*.a'
    ss.pod_target_xcconfig = {
        "CLANG_CXX_LIBRARY" => "libc++",
        'CLANG_CXX_LANGUAGE_STANDARD' => 'c++14',
    }
  end
  
#  s.subspec 'MixModel' do |ss|
#    ss.source_files        =  'SHWMixMobile/MixModel/**/*{.h,.m}'
#  end

#  s.subspec 'Vender' do |ss|
#    ss.source_files        =  'SHWMixMobile/Vender/**/*{.h,.m}'
#  end
  
  s.subspec 'ffmpeg' do |ss|
    ss.source_files        = 'SHWMixMobile/mix/ffmpeg/include/**/*.h'
    ss.public_header_files = 'SHWMixMobile/mix/ffmpeg/include/**/*.h'
    ss.header_mappings_dir = 'SHWMixMobile/mix/ffmpeg/include'
    ss.vendored_libraries  = 'SHWMixMobile/mix/ffmpeg/lib/*.a'
    ss.libraries = 'avcodec', 'avdevice', 'avfilter', 'avformat', 'avutil', 'postproc', 'swresample', 'swscale', 'iconv', 'z', 'bz2'
  end
  
  
  s.default_subspec = 'ffmpeg', 'libyuv', 'x264', 'fdk-aac', 'Skia', 'libheif'#, 'expat'#, 'Mix', 'glog', 'Vender', , 'MixModel'

  s.requires_arc = true
  s.frameworks = 'UIKit', 'Foundation', 'VideoToolbox', 'CoreMedia', 'AVFoundation', 'AudioToolbox', 'Accelerate', 'GLKit'
  s.libraries = "z", "bz2", "iconv", "c++"
      

end
