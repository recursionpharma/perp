# Python Environment Resolver Profiler (PERP)

A Repository for housing scripts to generate your own Python environment
resolver benchmark.

## How it works

You will need to provide your own one-to-one installation files for each of the
following optional formats:

- `environment-conda.yml` - For conda and mamba resolvers. This version should
  use only conda channels and/or meta-channels.
- `environment-pip.yml` - Similar to above, but should use PyPI versions of all
  dependencies.
- `environment-lock.yml` - Will be generated automatically when you call
  `run-suite.sh`
- `Pipfile` - Used by pyenv.
- `Pipfile.lock` - Will be generated automatically when you call `run-suite.sh`
- `pyproject.toml` - Used by poetry.
- `poetry.lock` - Will be generated automatically when you call `run-suite.sh`
- `requirements.in` - This is the unpinned requirements file used by pip's
  resolver.
- `requirements.txt` - Will be generated automatically when you call
  `run-suite.sh`

We have leveraged [DepHell](https://github.com/dephell/dephell) largely to
do the majority of the conversions and then executed `poetry`, `pip-compile`,
and `pyenv` locally to generate the requisite lockfiles for each of their
respective resolvers. (This step can probably be automated away from the user).

There is a convenience script (`generate-inputs.sh`) that will generate pipenv
and poetry inputs if you provide it a `requirements.in` file for your benchmark.
Unfortunately, at the time of this writing `environment.yml` support from
DepHell was not working.

## Example

TODO
