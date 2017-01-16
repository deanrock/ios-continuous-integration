#!/bin/bash
set -e

# install Xcode Command Line Tools
# https://github.com/timsutton/osx-vm-templates/blob/ce8df8a7468faa7c5312444ece1b977c1b2f77a4/scripts/xcode-cli-tools.sh
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
PROD=$(softwareupdate -l |
  grep "\*.*Command Line" |
  head -n 1 | awk -F"*" '{print $2}' |
  sed -e 's/^ *//' |
  tr -d '\n')
softwareupdate -i "$PROD" -v;

# force utf-u locale
echo "export LANG=en_US.UTF-8" >> ~/.profile
source ~/.profile

# disable software updates
sudo softwareupdate --schedule off

# install homebrew
TRAVIS=true ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install ruby 2.3
brew install ruby

# install iOS dev related gems
sudo gem install cocoapods
sudo gem install xcpretty
sudo gem install xcodeproj
sudo gem install deliver
sudo gem install cocoaseeds
sudo gem install fastlane

# carthage
brew install carthage

# xcode
sudo -E gem install xcode-install

# symlink itms for altool:
ln -s /Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/itms/ /usr/local/itms

# titanium pre-requirements
brew install homebrew/versions/node4-lts

#java
brew tap caskroom/cask
brew install Caskroom/cask/java

# titanium stuff
sudo npm install -g grunt-cli titanium alloy appcelerator tisdk
