#
# Be sure to run `pod lib lint JSSAlertView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'JSSAlertView'
s.version          = '5.0.2'
s.summary          = 'Custom HUD, with buttons supporting themes and Tinder like countdown'
s.description      = <<-DESC
A custom modal alert view
with a couple basic themes and support for custom icons, fonts, Tinder like countdown and UITextField ability.
The early version was inspired by and modeled after vikmeup's SCLAlertView.
DESC

s.homepage         = 'https://github.com/JSSAlertView/JSSAlertView'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Jay Stakelon' => '', 'Tomas Sykora, jr.' => 'jump@syky.cz' }
s.source           = { :git => 'https://github.com/JSSAlertView/JSSAlertView.git', :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/syky27'
s.swift_version = '5.0'


s.platform     = :ios, '8.0'
s.requires_arc = true

s.source_files = 'JSSAlertView/Classes/*'
end
