# Bazel workflows

This repository uses [Aspect Workflows](https://aspect.build) to provide an excellent Bazel developer experience.

## Linting code

Projects use [rules_lint](https://github.com/aspect-build/rules_lint) to run linting tools using Bazel's aspects feature.
Linters produce report files, which they cache like any other Bazel actions.
You can print the report files to the terminal in a couple ways, as follows.

The Aspect CLI provides the [`lint` command](https://docs.aspect.build/cli/commands/aspect_lint) but it is *not* part of the Bazel CLI provided by Google.
The command collects the correct report files, presents them with colored boundaries, gives you interactive suggestions to apply fixes, produces a matching exit code, and more.

- Run `aspect lint //...` to check for lint violations.

## Installing dev tools

For developers to be able to run additional CLI tools without needing manual installation:

1. Add the tool to `tools/tools.lock.json`
2. `cd tools; ln -s _multitool_run_under_cwd.sh name_of_tool`
3. Instruct developers to run `./tools/name_of_tool` rather than install that tool on their machine.

See https://blog.aspect.build/run-tools-installed-by-bazel for details.

## Working with npm packages

To install a `node_modules` tree locally for the editor or other tooling outside of Bazel:

```shell
% ./tools/pnpm install
```

Similarly, you can run other `pnpm` commands to add or remove packages. Use `bazel info workspace` to avoid having a bunch of `../` segments when running tools from a subdirectory:

```shell
path/to/package% $(bazel info workspace)/tools/pnpm add http-server
```

This ensures you use the same pnpm version as other developers, and the lockfile format stays constant.