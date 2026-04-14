# Modular Bayes

A research project on Bayesian modular inference.

## Overview

This repository contains Python and R code for implementing and exploring computational methods for Bayesian modular inference methods.

## Requirements

- Python (>= 3.12)
- R (>= 4.0.0)

## Setup

This project uses venv and [`renv`](https://rstudio.github.io/renv/) for reproducible package management.

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

### Python Setup

This project uses Python 3.12. Follow these steps to create and activate a virtual environment with the required packages.

**Prerequisites:** Python 3.12 installed (verify with `python3.12 --version`).

1. **Create the virtual environment:**
   ```bash
   python3.12 -m venv .venv
   ```

2. **Activate the virtual environment:**
   ```bash
   source .venv/bin/activate
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

To deactivate the environment when done:
```bash
deactivate
```

### For Existing R Users

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

## Generating Synthetic Data

The `modular.data` package provides classes for generating synthetic datasets used in the simulation studies.

### Gaussian Mean-Shift Model

`GaussianMeanShift` generates data from a two-module Gaussian model:

$$Y_i \sim \mathcal{N}(\phi,\, \sigma_Y^2), \qquad Z_j \sim \mathcal{N}(\phi + \theta,\, \sigma_Z^2)$$

```python
from modular.data import GaussianMeanShift

# Configure the data-generating process
gen = GaussianMeanShift(
    phi=0,        # shared location parameter
    theta=1,      # mean-shift parameter
    n_y=50,       # sample size for Y
    n_z=50,       # sample size for Z
    sigma_y=2,    # noise std dev for Y
    sigma_z=1,    # noise std dev for Z
)

# Draw a reproducible dataset
y, z = gen.sample(seed=123)
```

Log-likelihoods for each module are also available:

```python
gen.log_likelihood_y(y, phi=0.0)
gen.log_likelihood_z(z, phi=0.0, theta=1.0)
```

### Epidemiology Dataset

`load_epidemiology` returns the HPV prevalence and cervical-cancer incidence data from Plummer (2015) as a dictionary of NumPy arrays:

```python
from modular.dataloaders import load_epidemiology

data = load_epidemiology()
# data["y"] – HPV cases per study  (13,)
# data["N"] – survey participants  (13,)
# data["z"] – cancer cases         (13,)
# data["P"] – population sizes     (13,)
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
