function [cost, dists] = pointCloudCompareCost(pointCloudIn,pointCloudRef)

upperBound = max(1, round(.5*pointCloudIn.Count));
% Find the correspondence
[indices, dists] = knnsearch(pointCloudIn.Location, pointCloudRef.Location);

% Remove outliers
keepInlier = false(pointCloudIn.Count, 1);
[~, idx] = sort(dists);
keepInlier(idx(1:upperBound)) = true;
inlierDist = dists(keepInlier);
cost =sqrt(sum(inlierDist)/length(inlierDist));

