[Eleventy](https://github.com/11ty/eleventy) is a simpler static site generator.

This project is an Eleventy template for creating a simple personal page.

1. Simple and clean web pages.

## Demo

## Getting Started

### 2. Clone the repository

```
git clone https://github.com/ginqi7/gin-page
```

### 3. Navigate to the directory

```
cd gin-page
```

### Install dependencies

```
npm install
```

### Run Eleventy

Generate a production-ready build to the `_site` folder:

```
npm run build
```

Or build and host on a local development server:

```
npm run serve
```

## Docker

By utilizing the Docker image, you can write page without needing the gin-page directory.

### Build

```
 git clone https://github.com/ginqi7/gin-page.git gin-page
 cd gin-page
 docker build -t gin-page .
```

### Start Serve

In your page directory:

```
docker run -p 8080:8080 -v $(pwd):/app/posts gin-page
```

### Start export

In your page directory:

```
docker run -v $(pwd):/app/posts -v $(pwd)/_site:/app/_site gin-page npx eleventy
```

### Utilizing the Docker Image in GHCR.

In your page directory:

```
docker run -p 8080:8080 -v $(pwd):/app/_data  ghcr.io/ginqi7/gin-page
```

or

```
docker run -v $(pwd):/app/_data -v $(pwd)/_site:/app/_site ghcr.io/ginqi7/gin-page npm build
```

## Github Page

You can easily publish your page on GitHub Pages:

1. Create a repository for your configuration file.
2. Create a GitHub Action to build the website (similar to [this](https://github.com/ginqi7/page/blob/main/.github/workflows/publish.yml)).
3. Every time you push your page to the master branch, it will deploy a GitHub page. You can refer to [my page repository](https://github.com/ginqi7/page).
