# TODO List: Art Explorer Chicago App

This to-do list breaks down the development of the Art Explorer Chicago app into manageable tasks.

## Phase 1: Setup & Core Structure

* [x] **Project Setup:**
  * [x] Create new Flutter project (`flutter create art_explorer_chicago`).
* [x] **Dependencies:**
  * [x] Add `http` or `dio` for API calls.
  * [x] Add a state management solution (e.g., `provider` or `riverpod`).
  * [x] Add `cached_network_image` for efficient image loading and caching.
  * [x] Add `sqflite` or `sembast` for offline data storage.
  * [x] Add `url_launcher` for opening external links (maps, website).
  * [x] Add `flutter_svg` if any SVG assets are needed (e.g., for icons).
* [ ] **Basic App Structure:**
  * [ ] Set up `main.dart` and basic `MaterialApp` or `CupertinoApp`.
  * [ ] Create a main navigation structure (e.g., `BottomNavigationBar` or `Drawer`).
  * [ ] Create placeholder screens for: Artworks, Exhibitions, Museum Info, Artists.

## Phase 2: API Integration & Data Models

* [ ] **API Client:**
  * [ ] Define data models for API responses (e.g., `Artwork`, `Artist`, `Exhibition`, `MuseumInfo`).
  * [ ] Implement API service class with methods for:
    * Fetching lists of artworks, artists, exhibitions.
    * Fetching details for a single artwork, artist, exhibition.
    * Searching artworks.
    * Fetching museum hours and general info.
  * [ ] Implement IIIF URL generation logic for artwork images.
* [ ] **State Management Setup:**
  * [ ] Integrate chosen state management solution.
  * [ ] Set up providers/controllers for managing API data.

## Phase 3: UI Development & Feature Implementation

* [ ] **Artworks Section:**
  * [ ] `ArtworksListScreen`: Display artworks in a grid/list.
  * [ ] `ArtworkDetailScreen`:
    * [ ] Display high-resolution image using `cached_network_image` and IIIF URL.
    * [ ] Implement zoom/pan functionality for images.
    * [ ] Display artwork metadata (title, artist, dates, description, etc.).
    * [ ] Link to Artist Detail screen.
  * [ ] Implement search bar and filtering UI for artworks.
* [ ] **Exhibitions Section:**
  * [ ] `ExhibitionsListScreen`: Display current/upcoming exhibitions.
  * [ ] `ExhibitionDetailScreen`: Display exhibition details and associated artworks.
* [ ] **Museum Info Section:**
  * [ ] `MuseumInfoScreen`:
    * [ ] Display museum hours.
    * [ ] Display address and integrate `url_launcher` for map integration.
    * [ ] Display contact information.
* [ ] **Artists Section:**
  * [ ] `ArtistListScreen`: Display list of artists.
  * [ ] `ArtistDetailScreen`: Display artist biography and list of their artworks.

## Phase 4: Offline Functionality & Polish

* [ ] **Offline Access Implementation:**
  * [ ] Implement caching logic for artwork details and museum info.
  * [ ] Ensure images are cached for offline viewing.
  * [ ] Integrate local database (`sqflite`/`sembast`) for persistent storage of cached data.
  * [ ] Implement logic to fetch data from cache when offline, and sync when online.
* [ ] **User Experience Enhancements:**
  * [ ] Implement smooth screen transitions and animations.
  * [ ] Add loading indicators and error handling.
  * [ ] Optimize image loading performance.
  * [ ] Ensure UI is responsive across different screen sizes.
* [ ] **Testing:**
  * [ ] Unit tests for API client and data models.
  * [ ] Widget tests for UI components.
  * [ ] Integration tests for user flows.
  * [ ] Manual testing on various devices.
* [ ] **Final Touches:**
  * [ ] Add app icon and splash screen.
  * [ ] Review and refactor code.
  * [ ] Prepare for deployment.
