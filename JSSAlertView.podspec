#
# Be sure to run `pod lib lint JSSAlertView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'JSSAlertView'
s.version          = '4.0.0'
s.summary          = 'Custom HUD, with buttons supporting themes and Tinder like countdown'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
s.description      = <<-DESC 
A custom modal alert view for swift4, swift3 and swift2,
with a couple basic themes and support for custom icons and fonts
and Tinder like countdown.
The early version was inspired by and modeled after vikmeup's SCLAlertView.
DESC

s.homepage         = 'https://github.com/JSSAlertView/JSSAlertView'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Jay Stakelon' => '', 'Tomas Sykora, jr.' => 'jump@syky.cz' }
s.source           = { :git => 'https://github.com/JSSAlertView/JSSAlertView.git', :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/syky27'

s.platform     = :ios, '8.0'
s.requires_arc = true

s.source_files = 'JSSAlertView/Classes/*'
end
