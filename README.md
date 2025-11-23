# Modular Bayes

A research project on Bayesian modular inference.

## Overview

This repository contains R code for implementing and exploring Bayesian modular inference methods.

## Requirements

- R (>= 4.0.0)
- RStudio (recommended)

## Setup

This project uses [`renv`](https://rstudio.github.io/renv/) for reproducible package management.

### Initial Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/modular_bayes.git
   cd modular_bayes
   ```

2. **Open R or RStudio in the project directory**

3. **Initialize renv (if not already initialized):**
   ```r
   install.packages("renv")
   renv::init()
   ```

4. **Restore package dependencies:**
   ```r
   renv::restore()
   ```

### For Existing Users

If the `renv.lock` file exists (which tracks all package dependencies), simply restore the environment:

```r
renv::restore()
```

This will install all the packages at the versions specified in `renv.lock`.

## Using renv

### Adding New Packages

When you install a new package during development:

```r
install.packages("package_name")
```

Then update the lockfile to capture this dependency:

```r
renv::snapshot()
```

### Updating Packages

To update packages to newer versions:

```r
renv::update()
renv::snapshot()
```

### Check Project Status

To see which packages are used in your project but not recorded in the lockfile (or vice versa):

```r
renv::status()
```

## Project Structure

```
modular_bayes/
├── R/                  # R source code
├── data/              # Data files
├── scripts/           # Analysis scripts
├── tests/             # Unit tests
├── docs/              # Documentation
├── results/           # Output and results
├── renv/              # renv library (not tracked in git)
├── renv.lock          # Package dependency lockfile
├── .Rprofile          # Auto-activates renv
├── DESCRIPTION        # Project metadata
└── README.md          # This file
```

## Development Workflow

1. Make changes to your R code
2. Install any new packages you need with `install.packages()`
3. Run `renv::snapshot()` to update the lockfile
4. Commit both your code changes and the updated `renv.lock` file

## Contributing

[Add contribution guidelines if applicable]

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

[Add your contact information]

## References

[Add relevant academic references]
