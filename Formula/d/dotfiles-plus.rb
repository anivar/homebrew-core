class DotfilesPlus < Formula
  desc "AI-powered terminal productivity suite"
  homepage "https://github.com/anivar/dotfiles-plus"
  url "https://github.com/anivar/dotfiles-plus/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "f3ba15e86b02de92fbd0d8edb31afe815677012da4234ec7a08aa2ef17f0513d"
  license "MIT"
  head "https://github.com/anivar/dotfiles-plus.git", branch: "main"

  depends_on "bash"

  def install
    # Install all files to libexec
    libexec.install Dir["*"]
    
    # Create wrapper script
    (bin/"dotfiles-plus").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      
      # Set up environment
      export DOTFILES_PLUS_HOME="${DOTFILES_PLUS_HOME:-$HOME/.dotfiles-plus}"
      export DOTFILES_PLUS_INSTALL_DIR="#{libexec}"
      
      # Handle commands
      case "${1:-}" in
        --version)
          if [[ -f "$DOTFILES_PLUS_HOME/VERSION" ]]; then
            echo "Dotfiles Plus $(cat "$DOTFILES_PLUS_HOME/VERSION")"
          elif [[ -f "#{libexec}/VERSION" ]]; then
            echo "Dotfiles Plus $(cat "#{libexec}/VERSION")"
          else
            echo "Dotfiles Plus 2.0.3"
          fi
          ;;
        --help)
          echo "Dotfiles Plus - AI-powered terminal productivity suite"
          echo ""
          echo "Usage:"
          echo "  dotfiles-plus              # Interactive setup"
          echo "  dotfiles-plus --version    # Show version"
          echo "  dotfiles-plus --help       # Show this help"
          echo ""
          echo "To use in your shell, add to ~/.bashrc or ~/.zshrc:"
          echo "  source #{opt_libexec}/dotfiles-plus.sh"
          ;;
        "")
          # First time setup if needed
          if [[ ! -d "$DOTFILES_PLUS_HOME" ]]; then
            echo "Running first time setup..."
            exec bash "#{libexec}/install.sh"
          else
            echo "Dotfiles Plus is already installed!"
            echo ""
            echo "To use in your shell, add to ~/.bashrc or ~/.zshrc:"
            echo "  source #{opt_libexec}/dotfiles-plus.sh"
            echo ""
            echo "Run 'dotfiles-plus --help' for more information."
          fi
          ;;
        *)
          echo "Unknown option: $1"
          echo "Try 'dotfiles-plus --help' for more information."
          exit 1
          ;;
      esac
    EOS
    
    chmod 0755, bin/"dotfiles-plus"
  end

  def caveats
    <<~EOS
      To use Dotfiles Plus in your shell, add to ~/.bashrc or ~/.zshrc:
        source #{opt_libexec}/dotfiles-plus.sh
      
      For AI features, install one of these providers:
        - Claude Code: https://claude.ai/code
        - Gemini CLI: npm install -g @google/generative-ai-cli
        - Ollama: brew install ollama
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dotfiles-plus --version")
    assert_match "AI-powered terminal productivity suite", 
                 shell_output("#{bin}/dotfiles-plus --help")
  end
end