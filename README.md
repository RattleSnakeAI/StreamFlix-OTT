StreamFlixOTT – Project Description

Project Name: StreamFlixOTT
Platform: iOS
Language: Swift
Architecture: MVC / MVVM (depending on modules)
Data Persistence: Core Data for offline storage (user accounts, downloaded videos, watch history)

Overview:

StreamFlixOTT is a feature-rich OTT (Over-The-Top) streaming application for iOS devices that allows users to watch movies and TV shows, create personal watchlists, and manage their profiles. The app supports online streaming of video content, offline downloads for later viewing, and personalized user experiences.

Key Features:

User Authentication

Sign up / Login functionality with username and password.

Core Data used to securely store user credentials.

Session management for returning users.

Home & Video Playback

Browse featured movies and shows with thumbnails.

Play videos online via AVPlayer.

Download videos for offline playback.

Supports trailer and full video streaming.

Video Download & Offline Playback

Download videos with progress tracking.

Store videos locally and save metadata (title, thumbnail, duration) in Core Data.

Offline thumbnail caching using Data and custom ImageCacheManager.

Profile Section

View and manage user profile (username, password, mobile number, etc.).

Access watch history, My List, and settings.

Sign Out option integrated.

My List & Watch History

Users can save favorite content to "My List".

Watch history tracks the last viewed content.

Custom UITableView with images, titles, and durations.

Settings

Manage app preferences, notifications, and privacy settings.

Dark/light mode support.

Help & Support

FAQ section, contact support.

Scrollable content with helpful instructions for users.

UI/UX Features

Modern, clean, dark-themed design.

Smooth navigation with UINavigationController.

Launch screen with app branding and loading animations.

Responsive layouts compatible with all iPhone models, including 16 Pro.

Media & Caching

Asynchronous image loading using ImageCacheManager.

NSCache for offline thumbnail caching.

Video streaming optimized for mobile bandwidth.

Technology Stack

Swift, UIKit

Core Data (local storage)

AVKit / AVFoundation (video playback)

URLSession (network requests)

NSCache for image caching

Storyboard and programmatic UI for flexible design
