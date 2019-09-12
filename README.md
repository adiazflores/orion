# orionmono

Mono repo for orion web development. The monorepo manages dependencies
using [yarn workspaces](https://yarnpkg.com/lang/en/docs/workspaces/) and [lerna](https://lerna.js.org/).

From the root directory, run `yarn install` and then `yarn workspaces run build` to build all packages in the workspace. This will link the packages together as long as the package version matches the dependency version. This allows the projects to depend upon one another without requiring a private repository.

# Tools

- [docker](https://www.docker.com/products/docker-desktop)
- [editorconfig](https://editorconfig.org/)
- [node](https://nodejs.org/en/)
- [prettier](https://prettier.io/)
- [yarn](https://yarnpkg.com/en/)

The root `package.json` includes `prettier` and `husky`. `husky` is used to enforce consistent formatting in the pre-commit hook via prettier. Files/folders can be omitted from the enforced formatting by adding them to `.prettierignore`.

# Yarn Workspaces & Lerna

We manage dependencies using _Yarn Workspaces_ and _Lerna_.

To enable `Yarn Workspaces`:

```
yarn config set workspaces-experimental true
```

Adding a module available to all packages:
`lerna add module-name`

Adding dependencies to the root project can be set using:
`yarn add husky --dev -W`

The `--dev` flag will set the module into the dev dependency section of the root package.json file. Adding the `-W` flag signals we are adding the dependency to the workspace root.

Lerna provides helpful utility commands for handling the execution of tasks across multiple packages.

Adding modules to other packages is a two step process:

1. Add the package: `lerna add @orionmono/orion-lib --scope=@orionmono/orion-ui`
2. Import the package: `import Button from '@orion-ui/my-design-system-button'`

To Remove a module from all packages:
`lerna exec -- yarn remove dep-name`

The `exec` flag executes an arbitrary command within each package.

# Dev Process & Project Management

We manage the project using GH Issues which are assigned to the project. Milestones are equivalent to epics (There are typically dates set, for guidance and planning). Issues are equivalent to agile stories. When creating GH issues, please keep the folowing relationships in mind:

| Stories   | GH Issues                                       |
| --------- | ----------------------------------------------- |
| Iteration | GH Milestone                                    |
| Backlog   | Open, Unmilestoned and Unassigned Issues        |
| WIP       | Open, Milestoned and assigned/unassigned Issues |

...
