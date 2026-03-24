# final-project-MichaelC1418
Michael Chavez z23616307 Original App Design Project - README
===

# Pokedex

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview
UNIT 10 FINAL VIDEO DEMONSTRATION

[![Watch the video](https://img.youtube.com/vi/VrE32xCd2oM/hqdefault.jpg)](https://www.youtube.com/watch?v=VrE32xCd2oM)

CLICK VIDEO



Unit 9 Demo Youtube Video Link 
https://www.youtube.com/watch?v=RyERzJoRRB8


## GIF UPDATES
UNIT 9

<div>
    <a href="https://www.loom.com/share/017ec45bbdc949b6997d435eb4883837">
      <p>Loom Message - 30 November 2025 - Watch Video</p>
    </a>
    <a href="https://www.loom.com/share/017ec45bbdc949b6997d435eb4883837">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/017ec45bbdc949b6997d435eb4883837-6044c1984fbdaca1-full-play.gif#t=0.1">
    </a>
  </div>



UNIT 8
<div>
    <a href="https://www.loom.com/share/6203f2d69fb84169ac348afebed28d79">
      <p>Loom Message - 30 November 2025 - Watch Video</p>
    </a>
    <a href="https://www.loom.com/share/6203f2d69fb84169ac348afebed28d79">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/6203f2d69fb84169ac348afebed28d79-e1de597dcc3d64bf-full-play.gif#t=0.1">
    </a>
  </div>

### Description

Pokédex is a Pokémon app that combines real-time data from the PokéAPI with cloud-powered features using Firebase.The app allows users to search for any Pokémon, view detailed stats and artwork, save favorites, and explore community-wide favorite trends. A unique Pokémon of the Day feature refreshes every 24 hours, giving users a new highlighted Pokémon each day.

### App Evaluation


- **Category:** Entertainment
- **Mobile:** App is pretty unique do not see many other similar apps. Easy to use very accesbile on the phone.
- **Story:**  Story is compelling with out reach to hardcore pokemon fans or even competitions. 
- **Market:** Market isn't generally high but directly focused on the niche fans of pokemon
- **Habit:** App isn't habit inducing intended for quick use information seeking pokemon fans.
- **Scope:** Don't think the app will be TOO challenging to create.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Must be able to register and login with account
* Must have the option to search ANY Pokemon 
* Must have favorites section to quickly and easily access previously searched up pokemon
* Must show facts and pictures of the desired pokemon

**Optional Nice-to-have Stories**

* Must have UI similar to real pokemon pokedex within shows and games
* Maybe include a history of all pokemon not just the ones favorited
* Maybe we can include the ability to caption by users on why the pokemons are their favorites. 
### 2. Screen Archetypes

- [x] Login Screen
- [x] Registration Screen
- [x] Stream ( View other users favorite pokemon along with the images )
- [x] Search
- [x] Detail (Pokemon details)
- [x] Profile (View your own profile favorites)

### 3. Navigation

**Tab Navigation** (Tab to Screen)


- [x] [First Tab, e.g., Home Feed]
- [x] [Second Tab, e.g., Profile]


**Flow Navigation** (Screen to Screen)

- [x] Home Screen 
  * Leads to search , profile favorites , other users favorites below



## Wireframes
<img width="716" height="935" alt="image" src="https://github.com/user-attachments/assets/467ecbee-8368-45db-8fdd-0d45a8d8ecaf" />


## Schema 


### Models

## User
| Property         | Type     | Description                                       |
|------------------|----------|---------------------------------------------------|
| id               | String   | Firebase Auth user UID                            |
| email            | String   | User’s email address                              |
| displayName      | String  | Optional username                                 |
| privateFavorites | [Int]    | Pokémon IDs saved privately (user-only)           |
| sharedFavorites  | [Int]  | Pokémon IDs the user has chosen to share publicly |

## GlobalSharedFavorite
| Property   | Type     | Description                                               |
|------------|----------|-----------------------------------------------------------|
| id         | String   | Auto-generated Firestore document ID                      |
| userId     | String   | UID of the user who shared the Pokémon                   |
| pokemonId  | Int      | ID of the Pokémon being shared publicly                   |
| timestamp  | Date     | When the Pokémon was shared                               |

## Pokemon
| Property  | Type            | Description                                         |
|-----------|-----------------|-----------------------------------------------------|
| id        | Int             | Pokémon’s ID number                                 |
| name      | String          | Pokémon’s name                                      |
| types     | [String]        | Pokémon types (e.g., “Fire”, “Ghost”)               |
| abilities | [String]        | List of ability names                               |
| stats     | [String : Int]  | Base stats (HP, Attack, Defense, etc.)             |
| imageURL  | String          | URL linking to official artwork                     |

## PokemonSpecies
| Property     | Type      | Description                                           |
|--------------|-----------|-------------------------------------------------------|
| description  | String    | Pokédex flavor text                                   |
| eggGroups    | [String]  | Breeding groups (optional)                            |
| genera       | [String] | Species category (e.g., “Flame Pokémon”)              |

## PokemonOfTheDay
| Property    | Type | Description                                      |
|-------------|------|--------------------------------------------------|
| pokemonId   | Int  | Pokémon ID selected as Pokémon of the Day        |
| lastUpdated | Date | Used to ensure 24-hour Pokémon rotation          |



### Networking

This app uses two networking systems: PokéAPI for all Pokémon data and Firebase (Auth + Firestore) for user accounts, private favorites, and shared favorites.

**PokéAPI Used**
- `[GET] https://pokeapi.co/api/v2/pokemon/{id-or-name}`  
  → Loads Pokémon stats, types, abilities, and official artwork.
- `[GET] https://pokeapi.co/api/v2/pokemon-species/{id}`  
  → Returns Pokédex description (flavor text).
- `[GET] https://pokeapi.co/api/v2/pokemon?limit=20000`  
  → Loads the full Pokédex list.

**Pokémon of the Day**
- Uses PokéAPI GET requests but only once every 24 hours.
- Stores `pokemonId` and `lastUpdated` locally using UserDefaults.
- Refreshes automatically each day.

**Firebase Authentication**
- Register: `Auth.auth().createUser(withEmail:password:)`
- Login: `Auth.auth().signIn(withEmail:password:)`
- Logout: `Auth.auth().signOut()`

**Private Favorites (User-Only)**
Stored in Firestore at:

**Operations:**
- Save Favorite (WRITE)
- Remove Favorite (DELETE)
- Load Favorites (READ via snapshot listener)

**Shared Favorites (Public Feed — User Controlled)**
Stored only when the user taps “Share Publicly.”

**Each shared favorite includes:**
- `userId`
- `pokemonId`
- `timestamp`

**Firestore Queries**
- Load private favorites:
  `/users/{userId}/favorites`
- Load shared favorites (ordered by recency):
  `/shared_favorites?orderBy=timestamp`

**Networking Technologies**
- PokéAPI via `URLSession` + async/await
- FirebaseAuth for secure login/registration
- Firestore real-time listeners for favorites and shared feed



