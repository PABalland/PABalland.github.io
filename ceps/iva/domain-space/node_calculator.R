library(jsonlite);
library(argparse);

FixOverlaps <- function(nodes, visual_size_pixels, buffer_pixels, container_width, container_height, scale_padding, max_iterations, cleanup_iterations, overlap_buffer, micro_overlap_buffer) {
  nodes_copy <- lapply(nodes, function(n) { n });  
  x_coords <- sapply(nodes_copy, function(n) n$x);  
  y_coords <- sapply(nodes_copy, function(n) n$y);  
  coord_width <- max(x_coords) - min(x_coords);  
  coord_height <- max(y_coords) - min(y_coords);  
  scale <- min(container_width / coord_width, container_height / coord_height) * scale_padding;  
  visual_radius <- visual_size_pixels / 2;  
  required_separation <- (visual_radius * 2 + buffer_pixels) / scale;  

  n <- length(nodes_copy);  
  for (iter in seq_len(max_iterations)) {
    worst <- NULL; worst_sev <- 0;
    for (i in seq_len(n - 1)) {
      for (j in (i + 1):n) {
        n1 <- nodes_copy[[i]]; n2 <- nodes_copy[[j]];
        dx <- n2$x - n1$x; dy <- n2$y - n1$y;
        dist <- sqrt(dx^2 + dy^2);
        if (dist < required_separation) {
          sev <- required_separation - dist;
          if (sev > worst_sev) { worst_sev <- sev; worst <- list(i=i, j=j, dist=dist); }
        }
      }
    }
    if (is.null(worst)) break;
    i <- worst$i; j <- worst$j; dist <- worst$dist;
    n1 <- nodes_copy[[i]]; n2 <- nodes_copy[[j]];
    dx <- n2$x - n1$x; dy <- n2$y - n1$y;
    if (dx == 0 && dy == 0) {
      angle <- runif(1, 0, 2*pi); dx <- cos(angle); dy <- sin(angle);
    } else {
      len <- sqrt(dx^2 + dy^2); dx <- dx/len; dy <- dy/len;
    }
    curr <- if (dist > 0) dist else 0.1;
    target <- required_separation + overlap_buffer;
    move <- (target - curr) / 2;
    nodes_copy[[i]]$x <- n1$x - dx * move; nodes_copy[[i]]$y <- n1$y - dy * move;
    nodes_copy[[j]]$x <- n2$x + dx * move; nodes_copy[[j]]$y <- n2$y + dy * move;
  }

  for (iter in seq_len(cleanup_iterations)) {
    micro <- list();
    for (i in seq_len(n - 1)) {
      for (j in (i + 1):n) {
        n1 <- nodes_copy[[i]]; n2 <- nodes_copy[[j]];
        dx <- n2$x - n1$x; dy <- n2$y - n1$y;
        dist <- sqrt(dx^2 + dy^2);
        if (dist < required_separation) {
          micro[[length(micro) + 1]] <- list(i=i, j=j, dist=dist);
        }
      }
    }
    if (length(micro) == 0) break;
    for (m in micro) {
      i <- m$i; j <- m$j; dist <- m$dist;
      n1 <- nodes_copy[[i]]; n2 <- nodes_copy[[j]];
      dx <- n2$x - n1$x; dy <- n2$y - n1$y;
      if (dx == 0 && dy == 0) { dx <- 1; dy <- 0; }
      else { len <- sqrt(dx^2 + dy^2); dx <- dx/len; dy <- dy/len; }
      move <- (required_separation + micro_overlap_buffer - dist) / 2;
      nodes_copy[[i]]$x <- n1$x - dx * move; nodes_copy[[i]]$y <- n1$y - dy * move;
      nodes_copy[[j]]$x <- n2$x + dx * move; nodes_copy[[j]]$y <- n2$y + dy * move;
    }
  }

  return(nodes_copy);
}

main <- function() {
  parser <- ArgumentParser();
  parser$add_argument("--input", default="input.json", help="Input route.json");
  parser$add_argument("--output", default="output.json", help="Output route.json");
  parser$add_argument("--visual-size-pixels", type="double", default=60);
  parser$add_argument("--buffer-pixels", type="double", default=5);
  parser$add_argument("--container-width", type="double", default=800);
  parser$add_argument("--container-height", type="double", default=600);
  parser$add_argument("--scale-padding", type="double", default=0.9);
  parser$add_argument("--max-iterations", type="integer", default=200);
  parser$add_argument("--cleanup-iterations", type="integer", default=10);
  parser$add_argument("--overlap-buffer", type="double", default=0.1);
  parser$add_argument("--micro-overlap-buffer", type="double", default=0.05);
  args <- parser$parse_args();

  nodes <- fromJSON(args$input, simplifyVector = FALSE);
  resolved <- FixOverlaps(
    nodes,
    args$visual_size_pixels,
    args$buffer_pixels,
    args$container_width,
    args$container_height,
    args$scale_padding,
    args$max_iterations,
    args$cleanup_iterations,
    args$overlap_buffer,
    args$micro_overlap_buffer
  );
  write(toJSON(resolved, pretty=TRUE, auto_unbox=TRUE), file = args$output);
}

if (sys.nframe() == 0) main();