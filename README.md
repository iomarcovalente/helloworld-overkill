# helloworld-overkill

Scope of this repo is to demonstrate a simple deployment pipeline for a "hello world" web app.

## Tech stack

Please find tech stack and tooling below:

- Python3
- flask
- bash
- docker
- gh

## Usage

This repo is to showcase various common use-cases and standard practices when developing a web app, as well as demonstrating other relevant functionalities. Usage of basic commands:
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

## Tagging scheme

Chosen tagging scheme follows standard [semantic versioning](https://semver.org/).
Pre-prod app will be tagged `v0.1.0` and will increase minor/patch version until production ready.

#### Releases

Releases follow below steps:
- a tag is created and pushed:

  `git tag -a v<TARGET-VERSION> -m "First working version of helloworld web app" && git push --tags`

- an issue is created in github with relevant release summary:

  `gh issue create -t release-summary v<TARGET VERSION> -m v<TARGET VERSION> -l release-summary -b <RELEASE SUMMARY>`

- full and delta changelogs are generated:

  `generate_changelog.sh && generate_changelog.sh -d yes`

- new release is created based on latest pushed tag

  `./release.sh`
