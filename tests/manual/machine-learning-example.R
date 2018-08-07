x <-
"    \\node [block] (1l) {get training data};
    \\node [cloud, right of=1l] (1c) {do feature selection};
    \\node [cloud, right of=1c] (1r) {define ``association''};
    \\node [block, below of=1l] (2l) {finalize the predictive model};
    \\node [cloud, right of=2l] (2c) {fit model(s)};
    \\node [cloud, right of=2c] (2r) {define ``association''};
    \\node [block, below of=2l] (3l) {get validation data};
    \\node [cloud, right of=3l] (3c) {apply the model};
    \\node [decision, below of=3l] (4l) {marker(s) associated with outcome?};
    \\node [cloud, right of=4l] (4c) {define ``association''};
%    % Draw edges
    \\path [line, ->, >=latex] (1l) -- (2l);
    \\path [line, ->, >=latex] (2l) -- (3l);
    \\path [line, ->, >=latex] (3l) -- (4l);
    \\path [line,dashed, ->, >=latex] (1c) -- (1l);
    \\path [line,dashed, ->, >=latex] (1r) -- (1c);
    \\path [line,dashed, ->, >=latex] (2c) -- (2l);
    \\path [line,dashed, ->, >=latex] (2r) -- (2c);
    \\path [line,dashed,<->, >=latex] (1r) -- (2r);
    \\path [line,dashed,<->,>=latex] (1c) -- (2c);
    \\path [line,dashed, ->, >=latex] (3c) -- (3l);
    \\path [line,dashed, ->, >=latex] (4c) -- (4l);"


tikz_styles <- list(
  decision = "diamond, draw, fill=blue!20, text width=4.5em, text badly centered, node distance=3cm, inner sep=0pt",
  block = "rectangle, draw, fill=blue!20, text width=5em, text centered, rounded corners, minimum height=4em",
  line = "draw, - latex'",
  cloud = "draw, ellipse,fill=red!20, node distance=5cm, minimum height=2em"
)

write_tikz(x, tempfile(fileext = ".pdf"),
  tikz_library = c("positioning", "shapes.geometric", "calc", "fit", "shapes", "arrows"),
  tikz_style = tikz_styles,
  tikz_picture = c("node distance = 2.5cm", "auto"),
  class_options = c("10pt", "a4paper"))


write_tikz(x, tempfile(fileext = ".png"),
  tikz_library = c("positioning", "shapes.geometric", "calc", "fit", "shapes", "arrows"),
  tikz_style = tikz_styles,
  tikz_picture = c("node distance = 2.5cm", "auto"))
