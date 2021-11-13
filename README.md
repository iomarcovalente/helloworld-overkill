# helloworld-overkill

Scope of this repo is to demonstrate a simple deployment pipeline for a "hello world" web app.

## Tech stack

Please find tech stack below:

- Python3
- flask

## Usage

This repo is to showcase various common use-cases and standard practices when developing a web app, as long as to demonstrate other functionalities, specifically:
- running a local docker registry and push built images to this local registry
  - run with `docker run -d -p 5000:5000 --restart=always --name registry registry:2`
- creating a hello world web app
  - created using Python3 and Flask in a virtual environment
  - run locally with `flask run -p 8080`
  - check functionality in browser @ http://localhost:8080
- creating a Dockerfile to allow for local building and testing of the application
  - build and push to local docker registry with `./build_and_push.sh helloworld-overkill v0.1.0 localhost:5000`
  - test functionality with `docker run --rm -p 8080:8080 localhost:5000/helloworld-overkill:latest`
  - check functionality in browser @ http://localhost:8080
