# Apple news application
Display news with using API [News Api](https://newsapi.org).

- You can read news by theme _"Sport"_.
- You can read full news in internal _WebView_ by clicking on it.
- You can filter news by _Search Bar_.
- All loaded images will saved in _Cache_.
- Scroll down and more news for day before will apperar but maximum range is for last _7 days_, after reaching the last news you will shown _allert_ and pagination and downloading will ended.
- You can add news to favotites by clicking favorite button and save this news in _Favorites_ (local storage by _User Defaulsts_).
- You can remove news from _Favorites_ as by _favorites button clicking for second time in News_ or by _sliding in Favorites_ tab.
- You can see more description by clicking on _...Show More_
- You can _Pull-To_Refresh_

###### In this project I mastered:

- Cocoa Pods
- User Defaults
- REST API
- JSON
- Pagination
- Pull-to-Refresh
- Adding/removing to/from _Favorites_
- Search bar

## Requirements
- iOS 12.0+ / macOS 10.14+ / tvOS 12.0+ / watchOS 5.0+

# Tech

- All functions in code are _marked_ with it's description

# Installation

Application requires iOS 12+ to run.

## Installation of Kingfisher

A detailed guide for installation can be found in [Installation Guide](https://github.com/onevcat/Kingfisher/wiki/Installation-Guide).

### Swift Package Manager

- File > Swift Packages > Add Package Dependency
- Add https://github.com/onevcat/Kingfisher.git
- Select "Up to Next Major" with "7.0.0"
### CocoaPods

```sh
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

target 'MyApp' do
  pod 'Kingfisher', '~> 7.0'
end
```

### Carthage

```sh
github "onevcat/Kingfisher" ~> 7.0
```
