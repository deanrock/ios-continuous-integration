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


#### Resize disk

You can resize a disk via CLI.

First you need to find out disk name via:
```bash
diskutil list
```
and then you can resize it to maximum size via:
```bash
sudo diskutil resizeVolume disk0s2 R
```
where `disk0s2` is disk you want to resize.

### Setting up Titanium/Appcelerator

1.) Install pre-requirements:

```bash
brew install homebrew/versions/node4-lts

#java
brew tap caskroom/cask
brew install Caskroom/cask/java
```

2.) Install CLI tools:

```bash
sudo npm install -g grunt-cli titanium alloy appcelerator tisdk
```

3.) Set-up appcelerator and install latest titanium SDK (warning - requires interaction):
```bash
appc setup
```

### Setting up static networking

List all adapters

    networksetup -listallnetworkservices  

Set IP address 192.168.1.100 with netmask 255.255.255.0 and router address 192.168.1.1:

    networksetup -setmanual en0 192.168.1.100 255.255.255.0 192.168.1.1  

Use Google's DNS servers:

    networksetup -setdnsservers en0 8.8.8.8 8.8.4.4

### Examples

#### Example .gitlab-ci.yml for native iOS apps

```yaml
stages:
  - build

build_project:
  stage: build
  script:
    - carthage update --platform iOS
    - ~/ios-tools/recreate-user-schemes.sh "MyAwesomeApp"
    - xcodebuild clean archive -archivePath build/App -project MyAwesomeApp.xcodeproj -scheme "MyAwesomeApp" | xcpretty
    - sigh download_all --team_id A1B2C3D4E5 --username user@domain.com --force
    - xcodebuild -configuration Release -exportArchive -exportFormat ipa -archivePath "build/App.xcarchive" -exportPath "build/App.ipa" -exportProvisioningProfile "com.example.myawesomeapp AdHoc"
    - ~/ios-tools/publish-betatesting.sh build/App.ipa "#my-awesome-app"
  tags:
    - ios
  only:
    - master
```

#### Example .gitlab-ci.yml for Titanium iOS apps

```yaml
stages:
  - build

build_project:
  stage: build
  script:
    - ~/ios-tools/titanium-reset-appc.sh ./tiapp.xml
    - ti build --platform ios --target dist-adhoc --distribution-name "Company TLD (A1B2C3D4E5)" --pp-uuid "`~/ios-tools/get_uuid.sh AdHoc_com.example.myawesomeapp`" -O ./dist
    - ~/ios-tools/publish-betatesting.sh dist/MyAwesomeApp.ipa "#my-awesome-app"
  tags:
    - ios
  only:
    - master
```
