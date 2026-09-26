# Local, opt-in build of the previously verified background-window fix.
class SketchybarBackgroundFix < Formula
  env :std
  desc "SketchyBar with its background below component windows"
  homepage "https://github.com/FelixKratz/SketchyBar"
  url "https://codeload.github.com/FelixKratz/SketchyBar/tar.gz/6284ee816601486ace33ca48a0271832eec6de35"
  version "2.24.0"
  sha256 "940beb05c87f3c0f546effa3a3d1f748058bc9ec7a7faed14ef0b0db3a88e0b4"
  license "GPL-3.0-only"
  keg_only "keeps the original SketchyBar installation available for rollback"

  def install
    inreplace "src/bar.c",
              "window_set_level(&bar->window, g_bar_manager.window_level);",
              "window_set_level(&bar->window, g_bar_manager.window_level - 1);"
    system "make", Hardware::CPU.arm? ? "arm64" : "x86"
    system "codesign", "--force", "-s", "-", "bin/sketchybar"
    bin.install "bin/sketchybar"
    (var/"log/sketchybar").mkpath
  end

  service do
    run [opt_bin/"sketchybar"]
    environment_variables PATH: std_service_path_env, LANG: "en_US.UTF-8"
    keep_alive true
    process_type :interactive
    log_path var/"log/sketchybar/sketchybar.out.log"
    error_log_path var/"log/sketchybar/sketchybar.err.log"
  end

  test do
    assert_match "2.24.0", shell_output("#{bin}/sketchybar --version")
  end
end
