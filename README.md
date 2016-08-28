# ios-continuous-integration

Scripts for setting up and running iOS continuous integration machine (with support for native iOS and Titanium/Appcelerator apps).

###Set-up

1.) install OS X El Capitan & Xcode 7

2.) enable SSH server

    sudo systemsetup -setremotelogin on

3.) change password of "user" account and add your public SSH key to ~/.ssh/authorized_keys

4.) disable password SSH login via:

    UsePam yes
    ChallengeResponseAuthentication no
    PasswordAuthentication no
    kbdInteractiveAuthentication no

5.) install packages by typing:

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    sudo gem install cocoapods -v 0.39.0
    sudo gem install xcpretty
    sudo gem install xcodeproj
    sudo gem install deliver
    sudo gem install cocoaseeds
    sudo gem install fastlane
    brew install x11vnc #for remote desktop
    
    # carthage
    curl -OlL "https://github.com/Carthage/Carthage/releases/download/0.16.2/Carthage.pkg"
    sudo installer -pkg ./Carthage.pkg -target /
    rm "Carthage.pkg"

6.) add:

    export LANG=en_US.UTF-8

to ~/.profile


7.) Symlink itms for altool:

    ln -s /Applications/Xcode.app/Contents/Applications/Application\ Loader.app/Contents/itms/ /usr/local/itms

8.) Titanium pre-requirements (titanium needs node 4.x):

    brew install homebrew/versions/node4-lts
    sudo npm install -g grunt-cli titanium alloy appcelerator tisdk
    
    #java
    brew tap caskroom/cask
    brew install Caskroom/cask/java


### Setting up static networking

List all adapters

    networksetup -listallnetworkservices  

Set IP address 192.168.1.100 with netmask 255.255.255.0 and router address 192.168.1.1:

    networksetup -setmanual en0 192.168.1.100 255.255.255.0 192.168.1.1  

Use Google's DNS servers:

    networksetup -setdnsservers en0 8.8.8.8 8.8.4.4
