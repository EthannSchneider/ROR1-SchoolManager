# School Manager

## Description

This is a ruby project for the ROR1 course at CPNV. It is a school management system that allows to manage students, teachers, courses and grades. It main purpose is to be better than the LAGAPEP system used by the DGEP (Easy).

## Getting Started

### Prerequisites

- Ruby 3.4.7 or higher
- Rails 8.1.2 or higher

### Configuration

```shell
bundle # it will install the gems specified in the Gemfile
rails db:migrate # it will run the database migrations
```

## Deployment

### On dev environment

#### Local deployment

```shell
bin/dev # it will start the local development server
```

#### Running tests

```shell
rails test # it will run the tests
```

#### Running linters

```shell
rubocop # it will run the rubocop linter
```

### On integration environment

TODO

PS: i didn't deploy it yet, but i will deploy it soon.

## Directory structure

| Directory  | Purpose                                                                   |
| ---------- | ------------------------------------------------------------------------- |
| `app/`     | Organizes application components: views, helpers, controllers, and models |
| `bin/`     | Contains Rails startup script and other setup/deployment scripts          |
| `config/`  | Configuration files for your application                                  |
| `db/`      | Database schema and migration scripts                                     |
| `lib/`     | Custom libraries and utilities                                            |
| `log/`     | Application error and environment logs                                    |
| `public/`  | Static web files: JavaScript, images, stylesheets, HTML                   |
| `script/`  | Scripts for code generation and tool management                           |
| `storage/` | SQLite databases and Active Storage files                                 |
| `test/`    | Unit tests, fixtures, and functional tests                                |
| `tmp/`     | Temporary files for caching and processing                                |
| `vendor/`  | Third-party vendor libraries and gems                                     |
| `.git/`    | Git repository files                                                      |
| `.github/` | GitHub-specific configuration files                                       |
| `.kamal/`  | Kamal deployment secrets and hooks                                        |

## Collaborate

### Commit Guidelines

Use conventional commit messages to describe your changes. 
- https://www.conventionalcommits.org/en/v1.0.0/
- https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13#file-conventional-commits-cheatsheet-md

Current commit types include:
Changes relevant to the API or UI:
- `feat`: Commits that add, adjust or remove a new feature to the API or UI
- `fix`: Commits that fix an API or UI bug of a preceded feat commit
- `refactor`: Commits that rewrite or restructure code without altering API or UI behavior
- `perf`: Commits are special type of refactor commits that specifically improve performance
- `style`: Commits that address code style (e.g., white-space, formatting, missing semi-colons) and do not affect application behavior
- `test`: Commits that add missing tests or correct existing ones
- `docs`: Commits that exclusively affect documentation
- `build`: Commits that affect build-related components such as build tools, dependencies, project version, ...
- `ops`: Commits that affect operational aspects like infrastructure (IaC), deployment scripts, CI/CD pipelines, backups, monitoring, or recovery procedures, ...
- `chore`: Commits that represent tasks like initial commit, modifying .gitignore, ...

### How to propose a new feature (issue, pull request)

1. Create an issue describing the feature you want to propose, including the problem it solves and any relevant details.
2. If you want to implement the feature yourself, create a new branch from the main branch and name it appropriately (Branching stategy above) or fork the repository if you don't have write access to the main repository.
3. Implement the feature in your branch, following the commit guidelines for any commits you make.
4. Once your implementation is complete, push your branch to the repository and create a pull request (PR) against the main branch.

### Branching Strategy

We follow a simple branching strategy:
- `main`: The main branch contains the stable codebase that is ready for production.
- `feature/*`: Feature branches are created for developing new features or making significant changes. They are merged back into the main branch once the feature is complete and has been reviewed.
- `bugfix/*`: Bugfix branches are created for fixing bugs in the codebase. They are merged back into the main branch once the bug is fixed and has been reviewed.

## License

This project is licensed under the PUPU-1.0 License - see the [LICENSE](LICENSE) file for details.

## Contact

Please do not contact me, I am not interested in any form of communication. If you want to contribute, please follow the guidelines above and create a pull request. (👉🏼👈🏼)
