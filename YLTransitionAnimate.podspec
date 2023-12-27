# 初始化代码
# pod spec create 项目名

Pod::Spec.new do |s|

# 名称
  s.name             = 'YLTransitionAnimate'
  s.version          = '0.0.6'
  s.summary          = '自己日常使用的过渡动画'

  s.description      = <<-DESC
		自己日常使用的过渡动画,会在有更好的思路之后持续更新
                       DESC

  s.homepage         = 'https://github.com/StudentLinn/YLTransitionAnimate'
  s.license          = 'MIT'
  s.author           = { 'StudentLinn' => '792007074@qq.com' }
  s.source           = { :git => 'https://github.com/StudentLinn/YLTransitionAnimate.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'YLTransitionAnimate/*'
  s.swift_version = '4.0'
  s.framework    = 'UIKit'
  s.dependency 'SnapKit'

end