
function r = pagerankv2(A, tol, alpha)

  % function r = pagerankv2(A, tol, alpha)

  % purpose: find the page rank for the web pages
  %          represented with modified adjacency matrix by A
  %          to a given tolerance tol with boredom factor alpha

  % create "modified" adjacency matrix
  S = sum(A); ids = find(S==0); S(ids) = 1;
  A = A/diag(S);
  
  % stopping residual
  epsilon = 1;

  % number of web pages
  N = size(A,1);

  % initial guess for r
  r = rand(N,1);

  % keep iterating while the stopping criterion is not met
  while(epsilon>tol)

    % premultiply the current page rank vector
    % with the adjacency matrix and modify with boredom factor
    s = alpha*(A*r) + (1-alpha)*sum(r)/N;

    % use an absolute stopping residual
    epsilon = norm(s-r);

    % update the page rank vector
    r = s;

  end

  % normalize the page rank to have unit sum
  s = sum(r);
  r = r./s;
