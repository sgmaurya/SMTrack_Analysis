function images = load_images4(path)

%LOAD_IMAGES Summary of this function goes here

%   Detailed explanation goes here



    images = arrayfun(@(image) double(image.data), tiffread30(path), 'UniformOutput', false);

end



