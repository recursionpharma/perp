# Python Environment Resolution Profiler (PERP)

A Repository for housing scripts to generate your own Python environment
resolver benchmark.

## How it works

You will need to provide your own one-to-one installation files for each of the
following optional formats:

- `environment-conda.yml` - For conda and mamba resolvers. This version should
  use only conda channels and/or meta-channels where possible.
- `environment-pip.yml` - Similar to above, but should use PyPI versions of all
  dependencies.
- `Pipfile` - Used by pyenv.
- `pyproject.toml` - Used by poetry.
- `requirements.in` - This is the unpinned requirements file used by pip's
  resolver.

The following lock files will be automatically generated for the respective toolchains and placed into a `lockfiles` directory beside the files listed above:

- `poetry.lock`
- `environment-lock.yml`
- `Pipfile.lock`
- `requirements.txt`

We have leveraged [DepHell](https://github.com/dephell/dephell) largely to
do the majority of the conversions. There is a convenience script
(`generate-inputs.sh`) that will generate pipenv and poetry inputs if you
provide it a `requirements.in` file for your benchmark. Unfortunately, at the
time of this writing `environment.yml` support from DepHell was not working.

## Example

```
git submodule init
git submodule update
```

```
./run-suite.sh utility 3.9.1
```
