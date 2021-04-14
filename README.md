# beebusy

- [Grundidee der Anwendung](#grundidee-der-anwendung)
- [Features](#features)
- [Verwendete Technologien und Framworks](#verwendete-technologien-und-frameworks)
- [Klickbarer Prototyp](#klickbarer-prototyp)
- [Installation](#installation)
    - [Release Setup](#release-setup)
    - [Development Setup](#development-setup)
- [Contributors](#contributors)

## Grundidee der Anwendung

Tool zum operativen Projektmanagement à la Jira oder Wekan. Alles in einem Docker Image  für leichtes Deployment in der Cloud oder lokal.

## Features
- User erstellen, bearbeiten, löschen
- Projekt erstellen, löschen, editieren, archivieren
- User in Projekte einladen
- Tasks erstellen, bearbeiten, löschen
- Task einem User zuweisen
- Übersicht *TODO*, *IN PROGRESS*, *REVIEW*, *DONE*
- Automatische Kürzelgenerierung
- Containerisierung
- Drag & Drop von Tasks zwischen Spalten im Board
- „Autologin“
- Darkmode
- zweisprachig (Deutsch und Englisch), Sprache abhängig vom System (keine Auswahlmöglichkeit)
 

## Verwendete Technologien und Frameworks
- Flutter for Web
- Docker
- Postgresql in Docker
- REST API mit Aqueduct (Dart)
- Figma


## Klickbarer Prototyp

https://www.figma.com/file/X7CGnJGD3yEt4guqu6wgW6/BeeBusy?node-id=9%3A50



## Installation

### Release Setup
> Only docker needs to be installed to start a release version of the app. See: https://www.docker.com/get-started

1. Open terminal and navigate to src folder inside project root
```
cd /path/to/beebusy/src
```

2. To start DB, Server and WebApp for the first time run:
```
docker-compose -f docker-compose-prod.yml up --build -d
```

3. To start and stop the server subsequently run (inside src): 
    - Starting:
    ```
    docker-compose -f docker-compose-prod.yml start
    ```
    - Stopping:
    ```
    docker-compose -f docker-compose-prod.yml stop
    ```
4. WebApp is available at `localhost` on port 80



### Development Setup

This sets up all needed software for developing backend server and Webapp.

#### Note
> Can't start development and release at the same time.

#### Start Server for development of web app
Make sure you have the required software setup (see below). 

This sets up a docker container with the DB and backend server:

1. Open terminal and navigate to src folder inside project root
2. To start DB, Adminer and Server for the first time run:
```
docker-compose up --build -d
```
3. To start and stop the server subsequently run (inside src): 
    - Starting:
    ```
    docker-compose start
    ```
    - Stopping:
    ```
    docker-compose stop
    ```
4. A PostgreSQL DB should now be available at `localhost:5432`
    - user: postgres
    - passwort: 123
    - db: postgres
5. Also Adminer, a DB managemant tool, is available at `localhost:8080`
6. REST API is available at `localhost:8888`
##### Optional:
7. Install Postman and import `beebusy.postman_collection.json` from beebusy_server folder

#### Software Requirements and Setup

- Docker - *needed for Development of Webapp and Backend server*
- Flutter & Android Studio - *needed for Development of Webapp*
- IntelliJ - *needed for Development of Backend server*
- Aqueduct (Dart package) - *needed for Development of Backend server*

**NOTE:**
> Android-Studio or IntelliJ will work.
> Install the `Flutter` and `Dart` plugins to enable syntax highlighting, automatic download of packages and extended support for debugging.

#### Docker
1. Download and install Docker Desktop
    - https://www.docker.com/get-started
2. Make sure it works by running: 
```
docker --version
```

#### Flutter & Android Studio

1. Install Flutter & Anrdoid Studio
    - https://flutter.dev/docs/get-started/install
    - https://flutter.dev/docs/get-started/editor

2. Make sure path env variable is set correctly to flutter bin directory. Verify by running:
```
flutter --version
```

3. Enable Flutter Web
    - Follow the instructions on: https://flutter.dev/docs/get-started/web
    
or 

```
flutter channel beta
flutter upgrade
flutter config --enable-web
```


#### IntelliJ

IntelliJ is needed to develop the server. You can also use another editor, but IntelliJ is recommended.

1. Install IntelliJ
    - https://www.jetbrains.com/de-de/idea/download/



#### Aqueduct (Dart package)

For more information on aqueduct visit: https://aqueduct.io/docs/tour/

1. If Flutter is installed correctly, the dart command tool should be available. To verify run:
```
dart --version
```

2. Set the following env variables:
 - `PUB_CACHE` to pub cache bin directory, for example: C:\Users\your-user\AppData\Local\Pub\Cache
 - `PUB_HOSTED_URL` to https://pub.dev
 - Add to path env variable:
    - %PUB_CACHE%\bin
    - path-to-flutter\bin\cache\dart-sdk\bin

3. Following command should be available:
```
pub --version
```

4. Open terminal in project root folder and navigate to folder: src/beebusy_server

5. Following command should be available:
```
pub run aqueduct --version
```
##### Optional:
6. Install IntelliJ Templates for aqueduct 
    - https://aqueduct.io/docs/intellij/


#### Beebusy-App (Web-App)
Navigate to the app directory
```
cd /path/to/beebusy/src/beebusy_app
```

##### Get required flutter packages
```
flutter pub get
```

##### Generate autogenerated files

Generate files once:
```
flutter packages pub run build_runner build
```

Keep generating on save:
```
flutter packages pub run build_runner watch
```


## Contributors

HS-KL - Master Informatik - Framworkbasierte UI-Entwicklung - 2021-01-22

- Ariel Lubaschewski
- David Kronhardt
- Jan Feld
