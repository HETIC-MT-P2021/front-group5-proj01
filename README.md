# La Galeria de Papel - Front

  

## About

  

The goal of this project is to create a web app with an image gallery where you can manage your images : add, update and delete images. You will also be able to edit categories and tags to use them in filters.

The real goal of this project is to learn how to use Elm to make web app.

  

You are on the Front-end of the Project, we used Elm and Nginx to make a fast loading Web app.

  

## Requirements

  

- You must have Docker on your computer
- You must have Node.js  to build the project 

- Must have clone and installed the API of La Galeria de Papel : 
[https://github.com/HETIC-MT-P2021/back-group5-proj01](https://github.com/HETIC-MT-P2021/back-group5-proj01)
  

## Installation

  

```bash

TODO:

git clone https://github.com/HETIC-MT-P2021/front-group5-proj01.git

docker run



 
```
The app is now available at  http://localhost:8000
##  Prerequisites

  
Make sure that you have already started the Back of La Galeria De Papel
### Installing
```bash
docker build --tag galeria:1.0 ./
docker run --publish 8000:8080 --name galeria_app galeria:1.0

```

You can now access the web app At http://localhost:8001

  

## Features

  

- All of CRUD for images and categories.

- You can also edit the categories.
- You can filter by date, tags and categories

- An image is linked with one category, deleting the category will delete all linked images.

  

## Technical Choices

Feel free to discuss with any contributor about the technical choices that were made.
You can find te technical documentation [here](https://docs.google.com/document/d/1r71o5M6YeAlaBeZXdfL-Blp9kiznD9vudYctsmzviE0/edit?usp=sharing)

  
## Deployment  
You have to install Node.js 

    cd front-group5-proj01/app
    npm start

## Contributing

  

See [contributing guidelines](https://github.com/HETIC-MT-P2021/front-group5-proj01/blob/master/CONTRIBUTING.md)

  

## Any Questions ?

If you have any questions, feel free to open an issue. Please check the open issues before submitting a new one ;)

  

## Authors

  [Jean-Jacques Akakpo ](https://github.com/gensjaak)
  [Tsabot](https://github.com/Tsabot)
  [myouuu](https://github.com/myouuu)

## Licence

The code is available under the MIT license.
