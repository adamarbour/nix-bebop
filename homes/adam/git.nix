{
  # Enable git for me everywhere...
  hm.programs.git.enable = true;
  
  # delta - syntax-highlighting pager for git, diff, grep, and blame output
  programs.delta = {
    enable = true;
  };
  
  # Setup my personal git settings
  programs.git.settings = {
    user.name = "Adam Arbour";
    user.email = "845679+adamarbour@users.noreply.github.com";
    
    core.pager = "delta";
    pager = {
      diff = "delta";
      log = "delta";
      reflog = "delta";
      show = "delta";
    };
    interactive.diffFilter = "delta --color-only";
    delta = {
      # UX
      hyperlinks = true;
      navigate = true;
      line-numbers = true;
      side-by-side = false;
      detect-dark-light = true;
      # Readability
      true-color = "auto";
      syntax-theme = "GitHub";
      whitespace-error-style = "22 reverse";
      # Noise
      hunk-header-style = "syntax";
      line-numbers-left-style = "dim";
      line-numbers-right-style = "dim";
      line-numbers-minus-style = "red";
      line-numbers-plus-style = "green";
    };
  };
}
