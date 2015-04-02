# HackerNewsApp

![](ScreenShots/ScreenShot-Screens.png)

Simple iOS client for [Hacker News][], inspired by the DesigerNews Client made by [Meng To](https://github.com/MengTo) of [Design+Code]() , written in Swift.

## Usage

1) Download the repository

```
$ git clone https://github.com/NikantVohra/HackerNewsClient-iOS
$ cd HackerNewsClient-iOS
```
    
2) Initialize submodule dependancies

```
$ git submodule update --init --recursive
```

3) Open the project in Xcode

```
$ open HackerNews.xcodeproj
```

4) Compile and run the app in your simulator


# Requirements

- Xcode 6.1
- iOS 8

# Credits

- [libHN][] for Hacker News API requests
- [DTCoreText][] for fast and efficient HTML content display
- [Spring][] for code-less animation

[libHN]:https://github.com/bennyguitar/libHN
[DTCoreText]:https://github.com/Cocoanetics/DTCoreText
[Design+Code]:http://designcode.io
[Designer News]:https://news.layervault.com
[Spring]:https://github.com/MengTo/Spring
[Hacker News]:https://news.ycombinator.com/
