import numpy as np
from numpy.typing import ArrayLike


class GaussianMeanShift:
    """Synthetic data generator for a two-module Gaussian mean-shift model.

    The generative model draws two independent datasets:

    .. math::

        Y_i \\sim \\mathcal{N}(\\phi,\\, \\sigma_Y^2), \\quad i = 1, \\ldots, n_Y

        Z_j \\sim \\mathcal{N}(\\phi + \\theta,\\, \\sigma_Z^2), \\quad j = 1, \\ldots, n_Z

    where :math:`\\phi` is a shared location parameter and :math:`\\theta` is
    an additive shift that links the two modules.

    Parameters
    ----------
    phi : float
        True value of the shared location parameter.
    theta : float
        True value of the mean-shift parameter.
    n_y : int
        Sample size for dataset Y.
    n_z : int
        Sample size for dataset Z.
    sigma_y : float
        Standard deviation of the noise in dataset Y.
    sigma_z : float
        Standard deviation of the noise in dataset Z.

    Examples
    --------
    >>> gen = GaussianMeanShift(phi=0, theta=1, n_y=50, n_z=50,
    ...                         sigma_y=2, sigma_z=1)
    >>> y, z = gen.sample(seed=42)
    >>> y.shape
    (50,)
    """

    def __init__(
        self,
        phi: float,
        theta: float,
        n_y: int,
        n_z: int,
        sigma_y: float,
        sigma_z: float,
    ) -> None:
        if n_y <= 0 or n_z <= 0:
            raise ValueError("Sample sizes n_y and n_z must be positive integers.")
        if sigma_y <= 0 or sigma_z <= 0:
            raise ValueError(
                "Standard deviations sigma_y and sigma_z must be positive."
            )

        self.phi = phi
        self.theta = theta
        self.n_y = n_y
        self.n_z = n_z
        self.sigma_y = sigma_y
        self.sigma_z = sigma_z

    def sample(
        self,
        seed: int | None = None,
    ) -> tuple[np.ndarray, np.ndarray]:
        """Generate a pair of datasets ``(y, z)`` from the model.

        Parameters
        ----------
        seed : int or None, optional
            Random seed for reproducibility. If ``None``, no seed is set.

        Returns
        -------
        y : np.ndarray of shape ``(n_y,)``
            Samples from :math:`\\mathcal{N}(\\phi, \\sigma_Y^2)`.
        z : np.ndarray of shape ``(n_z,)``
            Samples from :math:`\\mathcal{N}(\\phi + \\theta, \\sigma_Z^2)`.
        """
        rng = np.random.default_rng(seed)
        y = rng.normal(loc=self.phi, scale=self.sigma_y, size=self.n_y)
        z = rng.normal(loc=self.phi + self.theta, scale=self.sigma_z, size=self.n_z)
        return y, z

    def log_likelihood_y(self, y: ArrayLike, phi: float) -> float:
        """Compute the log-likelihood of dataset Y given ``phi``.

        Parameters
        ----------
        y : array_like of shape ``(n_y,)``
            Observed data from the first module.
        phi : float
            Value of the location parameter.

        Returns
        -------
        float
            Log-likelihood :math:`\\sum_i \\log p(y_i \\mid \\phi)`.
        """
        y = np.asarray(y)
        return np.sum(
            -0.5 * np.log(2 * np.pi * self.sigma_y**2)
            - 0.5 * ((y - phi) / self.sigma_y) ** 2
        )

    def log_likelihood_z(self, z: ArrayLike, phi: float, theta: float) -> float:
        """Compute the log-likelihood of dataset Z given ``phi`` and ``theta``.

        Parameters
        ----------
        z : array_like of shape ``(n_z,)``
            Observed data from the second module.
        phi : float
            Value of the location parameter.
        theta : float
            Value of the mean-shift parameter.

        Returns
        -------
        float
            Log-likelihood :math:`\\sum_j \\log p(z_j \\mid \\phi, \\theta)`.
        """
        z = np.asarray(z)
        mu = phi + theta
        return np.sum(
            -0.5 * np.log(2 * np.pi * self.sigma_z**2)
            - 0.5 * ((z - mu) / self.sigma_z) ** 2
        )

    def __repr__(self) -> str:
        return (
            f"GaussianMeanShift(phi={self.phi}, theta={self.theta}, "
            f"n_y={self.n_y}, n_z={self.n_z}, "
            f"sigma_y={self.sigma_y}, sigma_z={self.sigma_z})"
        )
