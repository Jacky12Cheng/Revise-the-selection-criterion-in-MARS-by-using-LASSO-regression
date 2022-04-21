# Revise-the-selection-criterion-in-MARS-by-using-LASSO-regression

## **Motivation and background**
In the Data Science/Machine Learning community, Multivariate adaptive regression splines (MARS) is a somewhat neglected model. It can handle more complex problem and still preserve model interpretability. 
However, one of the drawbacks of the standard MARS algorithm is the greedy selection scheme for basis functions. MARS only looks for the locally best term to add or remove.
We want to find a method to select basis function globally and hope to get a more efficient solution.

- **Literature Review**
    - Conic MARS (CMARS)
    
Conic MARS has a special form of selection criterion in backward pass, it use “PRSS” to replace GCV. This method simply suggests to implement a penalized residual sum of squares (PRSS) for MARS as a ridge regression, also known as the Tikhonov regularization, by eliminating the backward stepwise algorithm of MARS.
CMARS chooses knots t more far from the input variables. 
    - Nongreedy MARS regression
    
In this method, we want to use every training example as a possible knot point for the spline and let the penalized regression find the optimal linear combination among all possible knots. The model in problems are therefore.

Above formula is the PRSS term

 
Where N is the size of observations. It chooses LASSO to select basis function and it is flexible as changing penalty in LASSO.
However, it left the mirrored hinge functions out and it would spend much processing time and be inelastic in big data.

- **Problem Definition**

This project revises the selection criterion in MARS by using LASSO regression.
