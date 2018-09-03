function [n_index] = assign_index(above, D)
f = @(x) x * ones(2 * D,1);
index = arrayfun(f, above, 'UniformOutput', false);
n_index = cell2mat(index);
n_index = reshape(n_index,1,[]);
end

