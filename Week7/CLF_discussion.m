clear; echo on;
pvar x1 x2;
vars = [x1; x2];

f = [-x1-2*x2^2;
    -x2-x1*x2-2*x2^3];

prog = sosprogram(vars);

% you have to provide the order of the monomials
% 1, x1, x2, x1^2, x2^2, x1x2
order = 2; 
% Give the "form" or at least the order of the Lyapunov function
% you are looking for.
[prog, V] = sospolyvar(prog, monomials(vars, [2:order]));

% Constraint 1
prog = sosineq(prog, V-(x1^2 + x2^2));

% Constraint 2
expr = -(diff(V,x1)*f(1) + diff(V,x2)*f(2));
prog = sosineq(prog, expr);

solver_opt.solver = 'sedumi';
prog = sossolve(prog, solver_opt);

SOLV = sosgetsol(prog, V)
echo off;