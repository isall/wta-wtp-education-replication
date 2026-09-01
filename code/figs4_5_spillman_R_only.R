# figs4_5_spillman_R_only.R
# Reproduce Figures 4 and 5: estimated average driving speed as a function of
# one-way distance to a training location, fitted with the Spillman model.
# Points are the distance/speed observations; the red curve is the fitted model.
# The equation, coefficient standard errors, and significance note are rendered
# programmatically.
#   Fig 4 = small_town_site;  Fig 5 = rural_area_site
# Input: speed_distance_deidentified.csv (columns: site, distance_miles, speed_mph).

# ---- Required packages: LOAD only; stop (do NOT install) if missing ----
.required <- c("readr", "dplyr", "ggplot2")
.missing  <- .required[!vapply(.required, requireNamespace, logical(1), quietly = TRUE)]
if (length(.missing)) {
  stop("Missing required package(s): ", paste(.missing, collapse = ", "),
       ".\nInstall them once (e.g. install.packages(c(",
       paste(sprintf('\"%s\"', .missing), collapse = ", "), "))) and re-run.")
}
library(readr)
library(dplyr)
library(ggplot2)

# ---- Paths (relative to this script's folder) & settings ----
input_csv <- "speed_distance_deidentified.csv"
fig4_out  <- "Fig4.tif"   # small_town_site
fig5_out  <- "Fig5.tif"   # rural_area_site
dpi       <- 600          # PLOS accepts 300-600 dpi
# Font: "serif" maps to a Times-like serif on every device (safe default).
# To use Times New Roman, register it (e.g. via extrafont/systemfonts) and set
# base_family <- "Times New Roman".
base_family <- "serif"

# ---- Load & basic checks ----
dat <- read_csv(input_csv, show_col_types = FALSE)
stopifnot(all(c("site", "distance_miles", "speed_mph") %in% names(dat)))
stopifnot(sum(dat$site == "small_town_site") == 1681,
          sum(dat$site == "rural_area_site") == 1387)

# ---- Model: Spillman form, fitted by nonlinear least squares ----
fit_spillman <- function(d) {
  d <- d[complete.cases(d[c("distance_miles", "speed_mph")]), ]
  start <- list(M = max(d$speed_mph),
                A = max(d$speed_mph) - min(d$speed_mph),
                R = 0.5)
  nls(speed_mph ~ M - A * R^distance_miles, data = d, start = start)
}

# ---- QA: fitted coefficients must match the reference values within tolerance ----
qa_coefs <- function(model, M, A, R, tol = 0.01) {
  cf <- coef(model)
  stopifnot(abs(cf["M"] - M) < tol, abs(cf["A"] - A) < tol, abs(cf["R"] - R) < tol)
  invisible(TRUE)
}

# ---- On-figure text (equation via plotmath; SEs and note upright) ----
# Display values are the published rounded coefficients and standard errors; the
# QA check above confirms the fitted values agree with them within tolerance.
make_labels <- function(M, A, R, seM, seA, seR) {
  eq   <- sprintf("AvgMPH == %.3f - %.3f %%*%% %.3f^Distance", M, A, R)  # %*% renders as a times sign
  se   <- sprintf("(%.3f)   (%.3f)   (%.3f)", seM, seA, seR)
  note <- "Note: standard errors of estimates are in parentheses, and all\nestimates are significant at a 0.001 level."
  list(eq = eq, se = se, note = note)
}

# ---- Plot ----
plot_spillman <- function(d, model, p) {
  d   <- d[complete.cases(d[c("distance_miles", "speed_mph")]), ]
  lab <- make_labels(p$M, p$A, p$R, p$seM, p$seA, p$seR)
  # Fitted line: predicted speed at each observed distance. Rows are ordered by
  # distance, so the connected line is smooth; no rows are dropped or resampled.
  pred_data <- dplyr::mutate(d, predicted_speed = predict(model, newdata = d))
  ytop <- ceiling(max(d$speed_mph) / 5) * 5   # round the top up to a 5-mph gridline

  ggplot(d, aes(x = distance_miles, y = speed_mph)) +
    geom_point(color = "blue", size = 1.2) +
    geom_line(data = pred_data, aes(x = distance_miles, y = predicted_speed),
              color = "red", linewidth = 1.75, linetype = "solid") +
    # equation, standard errors, and significance note, rendered inside the plot
    annotate("text", x = p$eq_x,   y = p$eq_y,   label = lab$eq, parse = TRUE,
             hjust = 0.5, size = 5.0) +
    annotate("text", x = p$eq_x,   y = p$se_y,   label = lab$se,
             hjust = 0.5, size = 4.6) +
    annotate("text", x = p$note_x, y = p$note_y, label = lab$note,
             hjust = 0.5, size = 4.0, lineheight = 0.95) +
    # axis breaks only; no scale limits here, so no rows are dropped
    scale_x_continuous(breaks = seq(0, 300, 20)) +
    scale_y_continuous(breaks = seq(0, 60, 10)) +
    # clip the display and put the origin at (0,0); rows outside are hidden, not dropped
    coord_cartesian(xlim = c(0, 300), ylim = c(0, ytop), expand = FALSE) +
    labs(title = NULL, x = "Distance (in miles)",
         y = "Speed (in Miles Per Hour (MPH))") +
    theme_minimal(base_size = 14, base_family = base_family) +
    theme(axis.title = element_text(size = 14, face = "bold"),
          axis.text  = element_text(size = 14),
          axis.line  = element_line(colour = "black", linewidth = 1),  # bold black L-axes
          plot.margin = margin(10, 14, 8, 8))
}

# ---- Run ----
d_small <- filter(dat, site == "small_town_site")   # -> Fig 4
d_rural <- filter(dat, site == "rural_area_site")    # -> Fig 5

m_small <- fit_spillman(d_small)
m_rural <- fit_spillman(d_rural)

qa_coefs(m_small, 53.356, 24.509, 0.978)   # Fig 4
qa_coefs(m_rural, 54.104, 40.822, 0.982)   # Fig 5

# Published rounded coefficients/SEs for display, plus per-figure annotation
# positions (in data units).
p_small <- list(M = 53.356, A = 24.509, R = 0.978, seM = 0.401, seA = 0.561, seR = 0.001,
                eq_x = 158, eq_y = 22.0, se_y = 18.7, note_x = 150, note_y = 9.5)
p_rural <- list(M = 54.104, A = 40.822, R = 0.982, seM = 0.431, seA = 0.521, seR = 0.001,
                eq_x = 150, eq_y = 18.0, se_y = 14.9, note_x = 150, note_y = 8.5)

# ---- Export TIFF (use ragg for LZW if present; otherwise base tiff device) ----
# ragg is OPTIONAL and is NOT auto-installed; without it we write an uncompressed TIFF.
use_ragg <- requireNamespace("ragg", quietly = TRUE)
save_tiff <- function(path, plot) {
  if (use_ragg) {
    ggsave(path, plot, width = 7.5, height = 6, dpi = dpi,
           device = ragg::agg_tiff, compression = "lzw")
  } else {
    message("Package 'ragg' not installed: writing an uncompressed TIFF ",
            "(install 'ragg' for LZW compression).")
    ggsave(path, plot, width = 7.5, height = 6, dpi = dpi, device = "tiff")
  }
}

save_tiff(fig4_out, plot_spillman(d_small, m_small, p_small))
save_tiff(fig5_out, plot_spillman(d_rural, m_rural, p_rural))

message("Done: wrote ", fig4_out, " and ", fig5_out,
        if (use_ragg) " (LZW-compressed via ragg)." else " (uncompressed TIFF).")
