% return an empty filter bank

function fbf = emptyFilter

  fbf = struct('name', '<empty>', 'soscoef', [1 0 0 1 0 0], ...
              'fs', 16384, 'design', '<none>');
  fbf = repmat(fbf, 10, 1);