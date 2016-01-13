##################################################
# Personality Profiles
##################################################

# Personality traits
traits = c("Adventurousness", "Artistic Interests", "Intellect", "Excitement Seeking", "Outgoing")

# User personality profile
user = c(0.98, 0.82, 1.00, 0.02, 0.06)
user.2d = user[1:2]

# Restaurant personality profiles
profile1 = c(0.65, 0.49, 0.77, 0.02, 0.21)
profile2 = c(0.67, 0.31, 0.78, 0.03, 0.13)
profile3 = c(0.73, 0.67, 0.80, 0.02, 0.51)
profile4 = c(0.63, 0.59, 0.57, 0.02, 0.66)
profile5 = c(0.60, 0.53, 0.62, 0.03, 0.66)
profiles = data.frame(profile1, profile2, profile3, profile4, profile5)
rownames(profiles) = traits
profiles.names = c("profile1", "profile2", "profile3", "profile4", "profile5")
profiles.2d = profiles[1:2,]
profiles.2d.names = profiles.names

##################################################
# Helper Functions
##################################################

# Euclidean distance from user personality profile
euc.dist <- function(profile) {
  sqrt(sum((user - profile) ^ 2))
}

# Euclidean distance from user's 2D personality profile
euc.dist.2d <- function(profile) {
  sqrt(sum((user.2d - profile) ^ 2))
}

##################################################
# 2D Plots
##################################################

# 2D compute distances
k.2d = 3
distances.2d = apply(profiles.2d, 2, euc.dist.2d)
threshold.2d = sort(distances.2d)[k.2d]

# 2D compute colors
euc.dist.2d.color <- function(profile) {
  if (euc.dist.2d(profile) <= threshold.2d) {
    "green"
  } else {
    "red"
  }
}
profiles.2d.colors = apply(profiles.2d, 2, euc.dist.2d.color)

# 2D plot profiles
plot(0:1, 0:1, type = "n", xlab = "Adventurousness", ylab = "Artistic Interests", main = "Personalities (2D)")
points(     user.2d[1],      user.2d[2], cex = 5, pch = 19, col = "blue")
points(profiles.2d[1,], profiles.2d[2,], cex = 5, pch = 19, col = profiles.2d.colors)

# 2D distance plot
xlim = c(0, 1)
ylim = c(0, 1)
px = c(0, distances.2d)
py = rep(0, length(px))
lx.buf = 0.1
lx = seq(xlim[1] + lx.buf, xlim[2] - lx.buf, len = length(px))
ly = 0.35
opar = par(xaxs = "i", yaxs = "i", mar = c(5, 1, 1, 1))
plot(NA, xlim = xlim, ylim = ylim, axes = F, ann = F)
axis(1)
title(main = "Personality Distances (2D)", line = -5)
segments(px, py, lx, ly)
points(px, py, pch = 16, xpd = NA, col = c("blue", profiles.2d.colors))
text(lx, ly, round(px, digit = 2), pos = 3)
par(opar)

##################################################
# Multi-D Plots: PCA (2 Dimensions)
##################################################

# collapse to 2D using PCA
pca = prcomp(rbind(user, t(profiles)))
user.pca = pca$x[1,1:2]
profiles.pca = t(pca$x[1: ncol(profiles)+1,1:2])

# Euclidean distance from user's 2D PCA personality profile
euc.dist.pca <- function(profile) {
  sqrt(sum((user.pca - profile) ^ 2))
}

# 2D compute distances
k.pca = 3
distances.pca = apply(profiles.pca, 2, euc.dist.pca)
threshold.pca = abs(sort(distances.pca)[k.pca])

# 2D compute colors
euc.dist.pca.color <- function(profile) {
  if (euc.dist.pca(profile) <= threshold.pca) {
    "green"
  } else {
    "red"
  }
}
profiles.pca.colors = apply(profiles.pca, 2, euc.dist.pca.color)

# 2D plot profiles
plot(-1:1, -1:1, type = "n", xlab = "Component 1", ylab = "Component 2", main = "Personalities (PCA)")
points(     user.pca[1],      user.pca[2], cex = 5, pch = 19, col = "blue")
points(profiles.pca[1,], profiles.pca[2,], cex = 5, pch = 19, col = profiles.pca.colors)

# 2D distance plot
xlim = c(0, 1)
ylim = c(0, 1)
px = c(0, distances.pca)
py = rep(0, length(px))
lx.buf = 0.1
lx = seq(xlim[1] + lx.buf, xlim[2] - lx.buf, len = length(px))
ly = 0.35
opar = par(xaxs = "i", yaxs = "i", mar = c(5, 1, 1, 1))
plot(NA, xlim = xlim, ylim = ylim, axes = F, ann = F, main = "Personality Distances")
axis(1)
title(main = "Personality Distances (PCA)", line = -5)
segments(px, py, lx, ly)
points(px, py, pch = 16, xpd = NA, col = c("blue", profiles.pca.colors))
text(lx, ly, round(px, digit = 2), pos = 3)
par(opar)

##################################################
# Multi-D Plots: All Dimensions
##################################################

# compute distances
k = 3
distances = apply(profiles, 2, euc.dist)
threshold = sort(distances)[k]

# compute colors
euc.dist.color <- function(profile) {
  if (euc.dist(profile) <= threshold) {
    "green"
  } else {
    "red"
  }
}
profiles.colors = apply(profiles, 2, euc.dist.color)

# distance plot
xlim = c(0, 1)
ylim = c(0, 1)
px = c(0, distances)
py = rep(0, length(px))
lx.buf = 0.1
lx = seq(xlim[1] + lx.buf, xlim[2] - lx.buf, len = length(px))
ly = 0.35
opar = par(xaxs = "i", yaxs = "i", mar = c(5, 1, 1, 1))
plot(NA, xlim = xlim, ylim = ylim, axes = F, ann = F)
axis(1)
title(main = "Personality Distances (All Traits)", line = -5)
segments(px, py, lx, ly)
points(px, py, pch = 16, xpd = NA, col = c("blue", profiles.colors))
text(lx, ly, round(px, digit = 2), pos = 3)
par(opar)