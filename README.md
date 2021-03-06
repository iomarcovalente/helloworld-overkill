# helloworld-overkill

Scope of this repo is to demonstrate a (_not-so_) simple deployment pipeline for a "hello world" web app.

## Tech stack

Please find tech stack and tooling below:

- aws ECR
- aws ECS
- aws FARGATE
- aws IAM
- aws VPC
- bash
- curl
- docker
- flask
- gh
- github-changelog-generator
- jq
- pip
- Python3
- terraform v1.0

## Usage

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

- creating cloud infrastructure
  - from `./terraform` run `terraform init`
  - run `terraform apply` (Note: [issue/14](https://github.com/iomarcovalente/helloworld-overkill/issues/14))

## Tagging scheme

Chosen tagging scheme follows standard [semantic versioning](https://semver.org/).
Pre-prod app will be tagged `v0.1.0` and will increase minor/patch version until production ready.

## Deployment

Cloud provider of choice is AWS.
To deploy we use terraform: after cloning the repo, it is required to set a profile named `personal` in `~/.aws/config` with relevant credentials (Note: [issue/16](https://github.com/iomarcovalente/helloworld-overkill/issues/16)) and run `terraform init` from `./terraform` folder.

Successively run `terraform apply`. Note it might take more than one attempt (Note: [issue/14](https://github.com/iomarcovalente/helloworld-overkill/issues/14)).

Ensure that the web app docker image is pushed to the relevant ecr repo: from project root run `./build_and_push.sh $ECR_REPO_URL`

Once deployment is completed and tested, check functionality by accessing the ALB endpoint - manual for now, no test is present :(

Upon successful testing, tear down infra by running `terraform destroy`

## Releases

> NOTE: we use github-changelog-generator to automatically create releases, so below steps are relevant to facilitate automated changelog generation

Releases are based on a combination of multiple optional and non optional requirements:
- one or multiple commit being pushed and a tag created
  - __required__; we cannot create a release without changes
- milestones met
  - __optional__; we can create a milestone in advance to track issues and PRs or just create one for the purpose of creating a release, this applies only to facilitate automated changelog generation
- issues closed
  - __optional__; no need to close an issue to create a release
- Pull Requests closed
  - __optional__; no need to close PRs to create a release

#### Release Steps

Release process follow below steps:
- a tag is created and pushed:

  `git tag -a $TARGET_VERSION -m "$TAG_MESSAGE" && git push --tags`

- an issue is opened and closed in github with relevant release summary:

  `gh issue close $(gh issue create -t "release target $TARGET_VERSION" -m "$TARGET_VERSION" -l release-summary -b $RELEASE_SUMMARY | tail -n1 | cut -d '/' -f7)`

- full and delta changelogs are generated:

  `./generate_changelog.sh && ./generate_changelog.sh -d yes`

- new release is created based on latest pushed tag

  `./release.sh`

- new docker image is built

  `./build_and_push.sh helloworld-overkill $TARGET_VERSION`

- commit updated CHANGELOG.md

- create new future milestone

  ```
    echo '{
      "title": "$FUTURE_TARGET_TAG",
      "state": "open",
      "due_on": "2022-12-31T23:59:59Z",
      "description": "Description foo bar"
    }' | gh createMilestone
  ```
#### Workarounds

- Manage milestones with `gh` (https://github.com/cli/cli/issues/1200); relevant command:

      gh alias set --shell createMilestone "gh api --method POST repos/:owner/:repo/milestones --input - | jq '{ html_url: .html_url, state: .state, created_at: .created_at }'"
