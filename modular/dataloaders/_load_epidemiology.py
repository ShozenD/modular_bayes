import numpy as np


def load_epidemiology() -> dict[str, np.ndarray]:
    """Load the epidemiological dataset from Plummer (2015).

    Returns the HPV prevalence and cervical-cancer incidence data used
    in the two-module epidemiological example.  The dataset covers 13
    studies and contains:

    * **y** – number of HPV-positive cases in each prevalence survey,
    * **N** – number of participants in each HPV prevalence survey,
    * **z** – number of cervical-cancer cases in each population,
    * **P** – population size covered by each cancer registry.

    Returns
    -------
    dict of str to np.ndarray
        A dictionary with the following keys:

        ``'y'`` : np.ndarray of shape ``(13,)``
            Number of HPV cases per study.
        ``'N'`` : np.ndarray of shape ``(13,)``
            Number of participants in the HPV prevalence survey.
        ``'z'`` : np.ndarray of shape ``(13,)``
            Number of cervical-cancer cases per population.
        ``'P'`` : np.ndarray of shape ``(13,)``
            Population size covered by each cancer registry.

    References
    ----------
    .. [1] Plummer, M. (2015). Cuts in Bayesian graphical models.
       *Statistics and Computing*, 25(1), 37–43.

    Examples
    --------
    >>> data = load_epidemiology()
    >>> data["y"]
    array([ 7,  6, 10, 10,  1,  1, 10,  4, 35,  0, 10,  8,  4])
    >>> data["P"].shape
    (13,)
    """
    y = np.array([7, 6, 10, 10, 1, 1, 10, 4, 35, 0, 10, 8, 4])

    N = np.array([111, 71, 162, 188, 145, 215, 166, 37, 173, 143, 229, 696, 93])

    z = np.array([16, 215, 362, 97, 76, 62, 710, 56, 133, 28, 62, 413, 194])

    P = np.array(
        [
            26983,
            250930,
            829348,
            157775,
            150467,
            352445,
            553066,
            26751,
            75815,
            150302,
            354993,
            3683043,
            507218,
        ]
    )

    return {"y": y, "N": N, "z": z, "P": P}
