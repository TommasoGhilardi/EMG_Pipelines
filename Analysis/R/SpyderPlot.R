
PlottingSpyder = function(database, lev){


database$Model <- database$Name
database$Name <- NULL


# normalize indices, for better comparison
database <- change_scale(database, exclude = "Model", to = c(.1, 1))

# recode some indices, so higher values = better fit
for (i in c("AIC", "BIC", "RMSE", "Sigma")) {
  if (i %in% colnames(database)) {
    database[[i]] <- 1.1 - database[[i]]
  }
}


database <- data_to_long(database, cols = 2:ncol(database))
database$Name <- factor(database$Name,levels = unique(database$Name))

database$Value[database$Value > 1] <- 1
levels(database$Model) = lev





ggplot(database, aes(
  x = Name,
  y = Value,
  colour = Model,
  group = Model)) +
  geom_polygon(size = 1, alpha = .03) +
  coord_radar() +
  scale_y_continuous(limits = c(0, 1), labels = NULL) +
  guides(fill = "none") +
  theme_radar() +
  scale_color_see()
}
